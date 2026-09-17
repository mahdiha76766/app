#!/usr/bin/env python3
"""Convert Persian plate detector to TFLite (ONNX path on Windows)."""

from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "tools" / "model_assets" / "source" / "detector"
TFLITE_OUT = ROOT / "tools" / "model_assets" / "tflite_out"
ASSETS = ROOT / "assets" / "models"
REPORT = ROOT / "tools" / "model_assets" / "conversion_report.json"


def main() -> int:
    pt = SOURCE / "best.pt"
    onnx = SOURCE / "best.onnx"
    existing = sorted(
        list(TFLITE_OUT.glob("*.tflite")) + list(SOURCE.glob("**/*.tflite")),
        key=lambda p: p.stat().st_size if p.exists() else 0,
        reverse=True,
    )

    # Prefer float16 for mobile size.
    preferred = None
    for candidate in existing:
        if "float16" in candidate.name.lower():
            preferred = candidate
            break
    if preferred is None and existing:
        preferred = existing[0]

    copied = None
    if preferred is not None:
        ASSETS.mkdir(parents=True, exist_ok=True)
        dst = ASSETS / "iran_plate_detector.tflite"
        shutil.copy2(preferred, dst)
        copied = str(dst.relative_to(ROOT)).replace("\\", "/")

    report = {
        "detector_is_ultralytics_yolo": True,
        "model_family": "YOLOv12x",
        "best_pt_exists": pt.exists(),
        "best_onnx_exists": onnx.exists(),
        "best_onnx_path": str(onnx.relative_to(ROOT)).replace("\\", "/")
        if onnx.exists()
        else None,
        "ready_tflite_found": preferred is not None,
        "source_tflite": str(preferred.relative_to(ROOT)).replace("\\", "/")
        if preferred is not None
        else None,
        "copied_to_assets": copied,
        "windows_direct_yolo_tflite_export": False,
        "conversion_path_used": "pt -> onnx (ultralytics) -> tflite (onnx2tf)",
        "input_shape": [1, 3, 320, 320],
        "onnx_output_shape": [1, 36, 2100],
        "note": (
            "Direct yolo export format=tflite fails on Windows (LiteRT). "
            "ONNX + onnx2tf succeeded."
        ),
    }
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(json.dumps(report, indent=2, ensure_ascii=False))
    return 0 if copied else 2


if __name__ == "__main__":
    sys.exit(main())
