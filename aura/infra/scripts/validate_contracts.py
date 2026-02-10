#!/usr/bin/env python3
"""Validate AURA contract files for required fields and basic value constraints."""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]
AURA_ROOT = REPO_ROOT / "aura"
SCHEMA_PATH = AURA_ROOT / "libs" / "event-schemas" / "event-envelope.v1.schema.json"
CAPS_DIR = AURA_ROOT / "libs" / "capability-registry" / "capabilities"

REQUIRED_CAPABILITY_FIELDS = {
    "capability_id",
    "service",
    "supported_os",
    "risk_tier",
    "preconditions",
    "primary_method",
    "fallback_methods",
    "verification_strategy",
    "timeout_ms",
    "max_retries",
    "confidence_score",
}
ALLOWED_RISK_TIERS = {"low", "medium", "high", "critical"}


def _load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def validate_event_schema() -> list[str]:
    errors: list[str] = []
    schema = _load_json(SCHEMA_PATH)
    required = set(schema.get("required", []))
    expected = {
        "event_id",
        "event_type",
        "event_version",
        "occurred_at",
        "trace_id",
        "actor",
        "payload",
    }
    if expected - required:
        errors.append(
            f"Schema missing required keys: {sorted(expected - required)}"
        )
    return errors


def validate_capabilities() -> list[str]:
    errors: list[str] = []
    files = sorted(CAPS_DIR.glob("*.json"))
    if not files:
        errors.append("No capability manifests found")
        return errors

    for path in files:
        data = _load_json(path)
        missing = REQUIRED_CAPABILITY_FIELDS - set(data)
        if missing:
            errors.append(f"{path.name}: missing fields {sorted(missing)}")
            continue

        if data["risk_tier"] not in ALLOWED_RISK_TIERS:
            errors.append(f"{path.name}: invalid risk_tier '{data['risk_tier']}'")

        if not isinstance(data["supported_os"], list) or not data["supported_os"]:
            errors.append(f"{path.name}: supported_os must be non-empty list")

        score = data["confidence_score"]
        if not isinstance(score, (int, float)) or not 0 <= score <= 1:
            errors.append(f"{path.name}: confidence_score must be between 0 and 1")

        if data["timeout_ms"] <= 0:
            errors.append(f"{path.name}: timeout_ms must be > 0")

        if data["max_retries"] < 0:
            errors.append(f"{path.name}: max_retries must be >= 0")

    return errors


def main() -> int:
    errors: list[str] = []
    errors.extend(validate_event_schema())
    errors.extend(validate_capabilities())

    if errors:
        print("Contract validation failed:")
        for error in errors:
            print(f" - {error}")
        return 1

    print("Contract validation passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
