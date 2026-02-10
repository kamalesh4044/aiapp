# AURA Project Bootstrap (Phase 0)

This folder is the initial executable scaffold for the AURA architecture.

## What is included

- `services/aura-core/` minimal local control-plane service skeleton.
- `libs/event-schemas/` versioned event envelope schema.
- `libs/capability-registry/` capability manifest examples.
- `infra/scripts/validate_contracts.py` contract validator (schema + capability fields).
- empty test folders for integration/chaos/performance tracks.

## Quick start

From repository root:

```bash
python3 aura/infra/scripts/validate_contracts.py
python3 aura/services/aura-core/main.py
```

Then open:

- `http://127.0.0.1:8088/health`
- `http://127.0.0.1:8088/capabilities`

## Notes

- This is intentionally lightweight and dependency-free to establish a clean Phase 0 baseline.
- Future phases can swap this HTTP skeleton for gRPC + event bus while preserving contracts.
