#!/usr/bin/env python3
"""Download and inspect Persian license-plate models from Hugging Face.

Models:
  - makhresearch/persian-license-plate-detector
  - hezarai/crnn-fa-license-plate-recognition

Usage:
  pip install huggingface_hub
  python tools/download_plate_models.py
"""

from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "tools" / "model_assets" / "source"
ASSETS_MODELS = ROOT / "assets" / "models"
REPORT_PATH = ROOT / "tools" / "model_assets" / "download_report.json"

DETECTOR_REPO = "makhresearch/persian-license-plate-detector"
RECOGNIZER_REPO = "hezarai/crnn-fa-license-plate-recognition"

KNOWN_EXTENSIONS = {
    ".tflite": "tflite",
    ".onnx": "onnx",
    ".pt": "pytorch",
    ".pth": "pytorch",
    ".safetensors": "safetensors",
    ".bin": "bin",
    ".pb": "tensorflow_savedmodel_or_pb",
    ".h5": "keras",
    ".engine": "tensorrt",
    ".yaml": "config",
    ".yml": "config",
    ".json": "config",
    ".txt": "text",
}


def ensure_huggingface():
    try:
        import huggingface_hub  # noqa: F401
        return True
    except ImportError:
        print("ERROR: huggingface_hub is not installed.")
        print("Install with:")
        print("  pip install huggingface_hub")
        return False


def list_files(path: Path) -> list[dict]:
    items = []
    if not path.exists():
        return items
    for file in sorted(path.rglob("*")):
        if not file.is_file():
            continue
        ext = file.suffix.lower()
        items.append(
            {
                "path": str(file.relative_to(ROOT)).replace("\\", "/"),
                "name": file.name,
                "ext": ext,
                "format": KNOWN_EXTENSIONS.get(ext, "unknown"),
                "size_bytes": file.stat().st_size,
            }
        )
    return items


def find_tflite(files: list[dict]) -> list[dict]:
    return [f for f in files if f["format"] == "tflite"]


def download_repo(repo_id: str, local_dir: Path) -> dict:
    from huggingface_hub import snapshot_download

    local_dir.mkdir(parents=True, exist_ok=True)
    print(f"\nDownloading {repo_id} -> {local_dir}")
    try:
        snapshot_download(
            repo_id=repo_id,
            local_dir=str(local_dir),
            local_dir_use_symlinks=False,
        )
        files = list_files(local_dir)
        return {
            "repo": repo_id,
            "ok": True,
            "local_dir": str(local_dir.relative_to(ROOT)).replace("\\", "/"),
            "files": files,
            "tflite_files": find_tflite(files),
            "error": None,
        }
    except Exception as exc:  # noqa: BLE001
        return {
            "repo": repo_id,
            "ok": False,
            "local_dir": str(local_dir.relative_to(ROOT)).replace("\\", "/"),
            "files": [],
            "tflite_files": [],
            "error": str(exc),
        }


def maybe_copy_tflite(source_files: list[dict], target_name: str) -> str | None:
    if not source_files:
        return None
    # Prefer the largest .tflite as the main model.
    best = max(source_files, key=lambda f: f["size_bytes"])
    src = ROOT / best["path"]
    dst = ASSETS_MODELS / target_name
    ASSETS_MODELS.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    print(f"Copied TFLite model: {src} -> {dst}")
    return str(dst.relative_to(ROOT)).replace("\\", "/")


def main() -> int:
    SOURCE_DIR.mkdir(parents=True, exist_ok=True)
    if not ensure_huggingface():
        report = {
            "ok": False,
            "error": "huggingface_hub_missing",
            "install": "pip install huggingface_hub",
            "links": {
                "detector": f"https://huggingface.co/{DETECTOR_REPO}",
                "recognizer": f"https://huggingface.co/{RECOGNIZER_REPO}",
            },
        }
        REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
        REPORT_PATH.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
        return 1

    detector = download_repo(DETECTOR_REPO, SOURCE_DIR / "detector")
    recognizer = download_repo(RECOGNIZER_REPO, SOURCE_DIR / "recognizer")

    copied = {
        "detector": None,
        "recognizer": None,
    }
    if detector["ok"] and detector["tflite_files"]:
        copied["detector"] = maybe_copy_tflite(
            detector["tflite_files"], "iran_plate_detector.tflite"
        )
    if recognizer["ok"] and recognizer["tflite_files"]:
        copied["recognizer"] = maybe_copy_tflite(
            recognizer["tflite_files"], "iran_plate_recognizer.tflite"
        )

    report = {
        "ok": detector["ok"] or recognizer["ok"],
        "detector": detector,
        "recognizer": recognizer,
        "copied_to_assets": copied,
        "ready_for_flutter": bool(copied["detector"] and copied["recognizer"]),
        "notes": [],
        "links": {
            "detector": f"https://huggingface.co/{DETECTOR_REPO}",
            "recognizer": f"https://huggingface.co/{RECOGNIZER_REPO}",
        },
    }

    if not detector["tflite_files"]:
        formats = sorted({f["format"] for f in detector["files"]})
        report["notes"].append(
            f"Detector has no ready .tflite. Found formats: {formats or ['none']}"
        )
    if not recognizer["tflite_files"]:
        formats = sorted({f["format"] for f in recognizer["files"]})
        report["notes"].append(
            f"Recognizer has no ready .tflite. Found formats: {formats or ['none']}"
        )

    REPORT_PATH.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print("\n==== SUMMARY ====")
    print(json.dumps(report, indent=2, ensure_ascii=False))
    print(f"\nReport written to {REPORT_PATH}")
    return 0 if report["ok"] else 2


if __name__ == "__main__":
    sys.exit(main())
