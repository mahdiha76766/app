import 'dart:ui';

import 'package:camera/camera.dart';

import '../../domain/entities/plate_consensus_result.dart';
import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_frame_quality.dart';
import '../../domain/entities/plate_ocr_candidate.dart';
import '../../domain/services/iranian_plate_ocr_service.dart';
import '../../domain/services/plate_consensus_service.dart';
import '../../domain/services/plate_detector_service.dart';
import '../../domain/services/plate_quality_service.dart';
import '../ml/camera_image_converter.dart';

/// پردازش یک فریم: crop راهنما → OCR → consensus.
class PlateScanPipeline {
  PlateScanPipeline({
    required this.detector,
    required this.ocr,
    required this.quality,
    required this.consensus,
  });

  final PlateDetectorService detector;
  final IranianPlateOcrService ocr;
  final PlateQualityService quality;
  final PlateConsensusService consensus;

  Future<PlatePipelineResult> processFrame({
    required CameraImage cameraImage,
    required Rect sensorRoi,
  }) async {
    final roiImage = CameraImageConverter.cropRoi(cameraImage, sensorRoi);
    final qualityResult = quality.evaluate(roiImage);

    if (roiImage.width <= 1 ||
        roiImage.height <= 1 ||
        roiImage.bytes.isEmpty ||
        roiImage.bytes.length < roiImage.width * roiImage.height * 3) {
      return PlatePipelineResult.rejected(
        quality: qualityResult,
        roiImage: roiImage,
        rejectionReason: 'ROI نامعتبر',
      );
    }

    final candidate = await ocr.recognize(roiImage);
    if (candidate == null) {
      return PlatePipelineResult.noOcr(
        quality: qualityResult,
        roiImage: roiImage,
      );
    }

    final consensusResult = consensus.addCandidate(
      PlateOcrCandidate(
        plate: candidate.plate,
        confidence: candidate.confidence,
        timestamp: DateTime.now(),
        boundingBox: candidate.boundingBox,
      ),
    );

    return PlatePipelineResult(
      quality: qualityResult,
      roiImage: roiImage,
      detection: candidate.boundingBox,
      candidate: candidate,
      consensus: consensusResult,
    );
  }
}

class PlatePipelineResult {
  const PlatePipelineResult({
    required this.quality,
    required this.roiImage,
    this.detection,
    this.candidate,
    this.consensus = PlateConsensusResult.none,
    this.rejected = false,
    this.noOcr = false,
  });

  factory PlatePipelineResult.rejected({
    required PlateFrameQuality quality,
    required PlateImage roiImage,
    DetectedPlate? detection,
    String? rejectionReason,
  }) =>
      PlatePipelineResult(
        quality: PlateFrameQuality(
          brightness: quality.brightness,
          blurScore: quality.blurScore,
          glareScore: quality.glareScore,
          plateSizeRatio: quality.plateSizeRatio,
          horizontalAngle: quality.horizontalAngle,
          isAcceptable: false,
          rejectionReason: rejectionReason ?? quality.rejectionReason,
        ),
        roiImage: roiImage,
        detection: detection,
        rejected: true,
      );

  factory PlatePipelineResult.noOcr({
    required PlateFrameQuality quality,
    required PlateImage roiImage,
    DetectedPlate? detection,
  }) =>
      PlatePipelineResult(
        quality: quality,
        roiImage: roiImage,
        detection: detection,
        noOcr: true,
      );

  final PlateFrameQuality quality;
  final PlateImage roiImage;
  final DetectedPlate? detection;
  final PlateOcrCandidate? candidate;
  final PlateConsensusResult consensus;
  final bool rejected;
  final bool noOcr;
}
