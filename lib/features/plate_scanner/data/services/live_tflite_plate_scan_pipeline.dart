import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';

import '../../domain/entities/plate_consensus_result.dart';
import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_frame_quality.dart';
import '../../domain/entities/plate_recognition_candidate.dart';
import '../../domain/services/live_plate_recognition_service.dart';
import '../../domain/services/plate_quality_service.dart';
import '../ml/camera_image_converter.dart';
import 'fast_plate_voting_service.dart';

/// pipeline زنده TFLite: crop ROI → detector → classify → vote.
class LiveTflitePlateScanPipeline {
  LiveTflitePlateScanPipeline({
    required this.recognition,
    required this.quality,
    required this.voting,
  });

  final LivePlateRecognitionService recognition;
  final PlateQualityService quality;
  final FastPlateVotingService voting;

  Future<LivePipelineResult> processFrame({
    required CameraImage cameraImage,
    required Rect sensorRoi,
  }) async {
    final roiImage = CameraImageConverter.cropRoi(cameraImage, sensorRoi);
    final qualityResult = quality.evaluate(roiImage);

    if (roiImage.width <= 1 ||
        roiImage.height <= 1 ||
        roiImage.bytes.isEmpty) {
      return LivePipelineResult.rejected(
        quality: qualityResult,
        roiImage: roiImage,
        rejectionReason: 'ROI نامعتبر',
      );
    }

    final candidate = await recognition.recognize(
      Uint8List.fromList(roiImage.bytes),
      roiImage.width,
      roiImage.height,
    );

    if (candidate == null) {
      return LivePipelineResult.noDetection(
        quality: qualityResult,
        roiImage: roiImage,
      );
    }

    final consensusResult = voting.addCandidate(candidate);

    return LivePipelineResult(
      quality: qualityResult,
      roiImage: roiImage,
      candidate: candidate,
      consensus: consensusResult,
      detectedBbox: candidate.boundingBox,
    );
  }

  void reset() => voting.reset();

  Future<void> dispose() => recognition.dispose();
}

class LivePipelineResult {
  const LivePipelineResult({
    required this.quality,
    required this.roiImage,
    this.candidate,
    this.consensus = PlateConsensusResult.none,
    this.detectedBbox,
    this.rejected = false,
    this.noDetection = false,
  });

  factory LivePipelineResult.rejected({
    required PlateFrameQuality quality,
    required PlateImage roiImage,
    String? rejectionReason,
  }) =>
      LivePipelineResult(
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
        rejected: true,
      );

  factory LivePipelineResult.noDetection({
    required PlateFrameQuality quality,
    required PlateImage roiImage,
  }) =>
      LivePipelineResult(
        quality: quality,
        roiImage: roiImage,
        noDetection: true,
      );

  final PlateFrameQuality quality;
  final PlateImage roiImage;
  final PlateRecognitionCandidate? candidate;
  final PlateConsensusResult consensus;
  final DetectedPlate? detectedBbox;
  final bool rejected;
  final bool noDetection;
}
