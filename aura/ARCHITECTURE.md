# AURA: Autonomous Unified Responsive Assistant
Version: 1.0 (Execution Blueprint)  
Date: February 10, 2026  
Scope: Local-first autonomous desktop assistant with permissioned control

## 1. Mission and Operating Model

AURA is a local-first agent platform for desktop automation, multimodal interaction, and personal workflow assistance.

Core intent:
- Run primarily on-device.
- Execute user-authorized actions reliably.
- Learn user workflows without leaking personal data.
- Degrade gracefully under low resources or component failure.

Normalization:
- Use `AURA` as the canonical product name.
- Keep module names from the concept (`TotalSystemControl`, `VoiceCortex`, etc.) as service names.

## 2. Non-Negotiable Engineering Constraints

1. No silent actions: every privileged action must be logged and attributable.
2. No unbounded autonomy: high-risk actions require explicit policy approval.
3. No single point of failure in core loop (planner, executor, policy, storage).
4. No hard coupling to one OS/provider/model.
5. No default cloud dependency for core functions.

## 3. Safety and Compliance Boundary

Allowed:
- Desktop automation for user-owned systems.
- Message drafting, triage, and user-approved sends.
- Web automation that respects terms and rate limits.
- Local model inference and optional cloud augmentation.

Not in baseline:
- Anti-detection evasion systems.
- Automated CAPTCHA bypass services.
- Unauthorized account automation.
- Covert surveillance behavior.

Rationale:
- These create legal/security risk and reduce long-term product viability.

## 4. System Architecture (Macro)

Architecture style:
- Modular local services + shared event bus + policy-enforced orchestration.

Core planes:
- Control Plane: intent parsing, planning, policy checks, capability routing.
- Data Plane: voice/video/text streams, screen frames, action events, memory ops.

```text
User (Voice/Text/Mobile)
   -> API Gateway (local gRPC/HTTP + auth)
      -> Orchestrator (Planner + Router + Policy Engine)
         -> Capability Services:
            - TotalSystemControl
            - VoiceCortex
            - VisionOmni
            - CommsAgent
            - CodeForge
            - WebVoyager
            - MobileBridge
            - EcoSystem
            - APIOmniverse
            - NeuroCore
         -> Event Bus (NATS/Redis Streams)
         -> Storage (SQLite + Chroma + object store)
         -> Audit Log (append-only)
```

## 5. Runtime Topology

Always-on minimal services:
- `aura-core` (gateway, orchestrator, policy evaluator, health manager)
- `ecosystem` (resource manager + mode transitions)
- `mobilebridge` (optional but default-on for remote notification/control)

On-demand services:
- `voicecortex`
- `visionomni`
- `webvoyager`
- `codeforge`
- heavyweight model workers

State modes:
- `sleep`: low memory, wakeword/VAD + urgent event listeners only.
- `idle`: basic orchestration active, low-frequency perception.
- `active`: full pipeline and high-priority task execution.
- `degraded`: reduced feature set when resources or dependencies fail.

## 6. Service Contracts (Per Module)

### 6.1 TotalSystemControl
Responsibilities:
- Keyboard/mouse input synthesis.
- Window/process/file operations.
- Multi-monitor awareness.

Primary interfaces:
- `execute_action(ActionSpec) -> ActionResult`
- `query_system(SystemQuery) -> QueryResult`

Fallback hierarchy:
1. Native API adapter (Win32/Quartz/X11/Wayland).
2. Accessibility/UI automation framework.
3. Vision-guided interaction.

Guardrails:
- Blocklist sensitive actions unless approved.
- Confirmation prompts for destructive operations.

### 6.2 VoiceCortex
Responsibilities:
- Wake-word/VAD.
- STT and TTS.
- Multilingual handling.

Interfaces:
- `start_listening(SessionConfig)`
- `transcribe(AudioChunkStream)`
- `speak(Text, VoiceProfile)`

Execution strategy:
- Local STT/TTS by default.
- Cloud fallback only with explicit opt-in.

### 6.3 VisionOmni
Responsibilities:
- Screen capture pipeline.
- OCR + layout parsing.
- UI element detection and scene summary.

Interfaces:
- `analyze_frame(FrameRequest) -> SceneGraph`
- `locate_element(ElementQuery) -> BoundingBox[]`

Performance controls:
- Adaptive FPS (1-60).
- ROI-based processing to reduce compute.

### 6.4 CommsAgent
Responsibilities:
- Ingestion connectors (email/chat platforms).
- Priority triage.
- Draft responses in user style.

Interfaces:
- `fetch_messages(SourceFilter)`
- `classify_priority(MessageBatch)`
- `draft_reply(MessageContext, StyleProfile)`

Guardrails:
- `auto-send` disabled by default.
- Approval workflow for external sends.

### 6.5 CodeForge
Responsibilities:
- Generate scripts/code changes.
- Run tests in sandbox.
- Package and register new capabilities.

Interfaces:
- `generate_code(TaskSpec)`
- `run_sandbox(TestPlan)`
- `register_capability(CapabilityManifest)`

Security:
- Restricted execution sandbox.
- Signed artifact requirement for installation.

### 6.6 WebVoyager
Responsibilities:
- Browser/API/web data workflows.
- Method selection engine.

Interfaces:
- `navigate(WebTaskSpec)`
- `extract(WebExtractionSpec)`

Method policy:
1. API when available.
2. HTTP parser pipeline.
3. Browser automation for interactive flows.

### 6.7 MobileBridge
Responsibilities:
- Remote command channel.
- Notifications and approvals.
- Local/LAN-first pairing.

Interfaces:
- `pair_device(PairingMethod)`
- `push_event(NotificationEvent)`
- `receive_command(RemoteCommand)`

Security:
- Device-bound keys.
- Session rotation and revocation.

### 6.8 EcoSystem
Responsibilities:
- Resource policy enforcement.
- Thermal/battery-aware scheduling.
- Mode transitions and throttling.

Interfaces:
- `evaluate_mode(SystemTelemetry) -> ModeDecision`
- `apply_budget(ServiceBudgets)`

### 6.9 APIOmniverse
Responsibilities:
- API catalog, connector lifecycle, token management.
- Plugin lifecycle and enable/disable control.

Interfaces:
- `discover_api(CatalogQuery)`
- `invoke_connector(ConnectorCall)`
- `enable_plugin(PluginId)`

### 6.10 NeuroCore
Responsibilities:
- Preference learning and pattern mining.
- Retrieval-augmented personalization.
- Predictive assistance proposals.

Interfaces:
- `record_interaction(InteractionEvent)`
- `retrieve_context(ContextQuery)`
- `propose_automation(PatternSignal)`

Privacy:
- Local storage default.
- Opt-in encrypted sync only.

## 7. Orchestration Pipeline

1. Input received (voice/text/mobile).
2. Intent parse + confidence estimation.
3. Policy engine checks permissions/risk level.
4. Planner builds multi-step execution graph.
5. Router dispatches to required services.
6. Executor runs with retries and fallback methods.
7. Verifier validates outcome (vision/system readback).
8. User-facing response emitted.
9. Audit + telemetry + learning signals persisted.

Timeout and retry policy:
- Per-step timeout with capped retries.
- Circuit breaker for unstable dependencies.
- Step compensation hooks for partial failure rollback.

## 8. Cross-Platform Abstraction Layer

Package: `os_abstractor`

Sub-layers:
- `process_adapter`: launch/kill/query apps.
- `window_adapter`: enumerate/move/focus windows.
- `input_adapter`: keyboard/mouse synthesis.
- `notification_adapter`: system notifications.
- `display_adapter`: monitor topology/screen capture.

OS support strategy:
- Phase 1: Windows-first stable baseline.
- Phase 2: macOS parity for core features.
- Phase 3: Linux support (X11 first, Wayland partial then full).

Capability gating:
- Each feature publishes support matrix by OS and confidence score.

## 9. Reliability Model (Zero-Failure Reframed)

Engineering definition:
- "Zero failure" means no silent failure and no dead-end execution path for supported tasks.

Mechanisms:
- Multi-method strategy per capability.
- Heartbeat + watchdog for each service.
- Supervisor restarts with exponential backoff.
- Event-sourced audit trail for replay/debug.
- Automatic degraded mode when dependencies fail.

Failure classes:
- Recoverable transient: retry/backoff.
- Recoverable persistent: fallback method.
- Non-recoverable: safe abort + actionable user notice.

## 10. Security Model

Identity and auth:
- Local user identity + device-bound keys.
- Optional remote identity provider.

Authorization:
- Capability-scoped permissions.
- Risk-tiered actions (`low`, `medium`, `high`, `critical`).

Data protection:
- Secrets in OS keychain/DPAPI.
- At-rest encryption for sensitive stores.
- TLS for all remote/mobile channels.

Governance:
- Append-only audit log.
- Signed plugin manifests.
- Policy packs (consumer, enterprise, strict privacy).

## 11. Data and Memory Architecture

Stores:
- SQLite: config, tasks, permissions, schedules, stats.
- Chroma (or equivalent): semantic memory embeddings.
- Object store: screenshots/audio/snippets with retention policy.
- Log store: structured events + traces.

Memory tiers:
- Short-term: active session context and recent turns.
- Long-term: preferences, workflow patterns, historical outcomes.
- Episodic: timestamped task episodes for replay.

Retention defaults:
- Raw screenshots/audio: 7-30 days configurable.
- Structured logs: 90 days default.
- Summarized memory: indefinite unless user deletes.

## 12. Resource and Performance Budgets

State budgets (target):
- Sleep: <= 250 MB RAM, <= 2% CPU.
- Idle: <= 700 MB RAM, <= 5% CPU.
- Active (no heavy vision): <= 2 GB RAM, <= 20% CPU.
- Active (vision/model heavy): <= 6 GB RAM, bounded by policy.

Latency SLOs:
- Wake-word detection: p95 < 250 ms.
- Command parse (local LLM): p95 < 800 ms.
- Screen summary (1080p ROI): p95 < 400 ms.
- Simple system action (open app): p95 < 2 s.

Degradation rules:
- Drop frame rate before dropping critical control loops.
- Prefer smaller local model under pressure.
- Suspend non-critical background learning first.

## 13. Plugin and API Ecosystem

Plugin model:
- Python wheel or containerized plugin.
- Manifest includes permissions, events, commands, health checks.
- Runtime sandbox profile required.

Connector lifecycle:
1. Discover.
2. Validate schema/auth.
3. Sandbox test.
4. User approval.
5. Enable + monitor.
6. Disable on policy violation.

## 14. Observability and Ops

Telemetry:
- Structured logs (JSON).
- Metrics: latency, success rate, fallback rate, resource usage.
- Traces across orchestration steps.

Health scoring:
- Service-level health score 0-100.
- Capability confidence updated from rolling outcomes.
- Alert thresholds for drift/regression.

Admin surfaces:
- Local dashboard.
- CLI for diagnostics.
- Exportable incident bundles.

## 15. 20-Week Implementation Roadmap

### Phase 0 (Weeks 1-2): Foundation
- Monorepo setup, service scaffolding, CI.
- Local gateway + orchestrator skeleton.
- Config, secrets, audit log baseline.
- Basic policy engine with permission prompts.

Exit criteria:
- Core service starts reliably and processes no-op commands.

### Phase 1 (Weeks 3-6): Control + Voice MVP
- `TotalSystemControl` for app launch/window/input actions.
- `VoiceCortex` wakeword + STT + TTS.
- End-to-end: voice command -> system action -> spoken result.
- Basic failure handling and retries.

Exit criteria:
- 20 core commands with >= 90% success on test rig.

### Phase 2 (Weeks 7-10): Vision + Verification
- `VisionOmni` frame capture, OCR, UI element locator.
- Post-action verification loop.
- ROI and adaptive FPS controls.

Exit criteria:
- "What is on screen?" and "click target element" workflows stable.

### Phase 3 (Weeks 11-13): Comms + Mobile
- `CommsAgent` for email/Slack/Discord connectors (read + draft).
- `MobileBridge` pairing, push alerts, approval actions.
- Message triage and draft generation.

Exit criteria:
- Urgent message triage and approval flow operational.

### Phase 4 (Weeks 14-16): Web + API + Plugin Runtime
- `WebVoyager` method selector (API/HTTP/browser).
- `APIOmniverse` connector registry and plugin lifecycle.
- Plugin permissions and health checks.

Exit criteria:
- 10 vetted connectors enabled with policy controls.

### Phase 5 (Weeks 17-18): Learning + Optimization
- `NeuroCore` preference model + pattern mining.
- Automation suggestions with approval UX.
- Resource-aware scheduling via `EcoSystem`.

Exit criteria:
- At least 3 accepted user automation suggestions generated from behavior.

### Phase 6 (Weeks 19-20): Hardening + Release
- Security review and threat-model validation.
- Reliability chaos tests (service kill, dependency failure).
- Packaging + installer + upgrade channel.

Exit criteria:
- Public beta quality gate passed.

## 16. MVP Cutline (Ship First)

Must-have:
- Voice/text commands.
- Safe system control actions.
- Screen read + simple UI interaction.
- Audit log + permission engine.
- Mobile approval channel.

Defer:
- Full personality layer.
- Broad API auto-discovery at scale.
- Advanced proactive behavior.
- Self-modifying code in production (keep behind gated developer mode).

## 17. Acceptance Test Matrix (Examples)

1. `open chrome` succeeds on supported OSes.
2. Wakeword triggers under ambient noise profile.
3. OCR reads standard UI text at 1080p and 125% scaling.
4. High-risk action requires approval and logs actor/time.
5. Service crash auto-recovers within supervisor timeout.
6. Idle resource budget remains within threshold for 8 hours.

## 18. Suggested Repository Structure

```text
aura/
  ARCHITECTURE.md
  services/
    aura-core/
    totalsystemcontrol/
    voicecortex/
    visionomni/
    commsagent/
    codeforge/
    webvoyager/
    mobilebridge/
    ecosystem/
    apiomniverse/
    neurocore/
  libs/
    os-abstractor/
    policy-engine/
    capability-registry/
    event-schemas/
  infra/
    docker/
    scripts/
  tests/
    integration/
    chaos/
    performance/
```

## 19. Key Risks and Mitigations

Risk: OS automation brittleness  
Mitigation: layered adapters + vision verification + fallback paths.

Risk: Resource spikes from multimodal inference  
Mitigation: dynamic model scaling, queue control, strict budgets.

Risk: Over-automation and unsafe actions  
Mitigation: policy gates, risk tiers, approval requirements, auditability.

Risk: Connector breakage due to external API/UI changes  
Mitigation: contract tests, canary rollout, health-based auto-disable.

## 20. Immediate Next Actions

1. Approve this architecture as baseline.
2. Initialize monorepo with service skeletons and shared schema package.
3. Implement Phase 0 and Phase 1 thin slice end-to-end.
4. Start an executable capability registry with confidence and fallback metadata.

## 21. Contract-First Event Schemas (Initial)

To reduce integration ambiguity, all inter-service communication should use versioned envelopes.

Envelope (required fields):
- `event_id` (UUID)
- `event_type` (string, namespaced)
- `event_version` (semver)
- `occurred_at` (ISO8601 UTC)
- `trace_id` (string)
- `actor` (user/device/service)
- `payload` (object)

Initial event types:
1. `intent.received.v1`
2. `policy.decision.v1`
3. `plan.created.v1`
4. `action.executed.v1`
5. `action.verified.v1`
6. `task.completed.v1`
7. `task.failed.v1`
8. `approval.requested.v1`
9. `approval.resolved.v1`

Compatibility rules:
- Additive payload changes are allowed in minor versions.
- Breaking field changes require new major version and dual-read period.
- Services must reject unknown major versions and emit `task.failed.v1` with reason.

## 22. Capability Registry Contract (Executable Metadata)

Every capability must publish a machine-readable manifest:

Required manifest keys:
- `capability_id`
- `service`
- `supported_os`
- `risk_tier`
- `preconditions`
- `primary_method`
- `fallback_methods[]`
- `verification_strategy`
- `timeout_ms`
- `max_retries`
- `confidence_score`

Execution rules:
- Orchestrator can only route actions to registered capabilities.
- Missing or stale manifest implies capability is unavailable.
- `confidence_score` is updated from rolling success/fallback rates.

Example (illustrative):

```json
{
  "capability_id": "system.open_app",
  "service": "totalsystemcontrol",
  "supported_os": ["windows", "macos", "linux-x11"],
  "risk_tier": "low",
  "preconditions": ["app_installed"],
  "primary_method": "native_api",
  "fallback_methods": ["accessibility", "vision_click"],
  "verification_strategy": "window_title_match",
  "timeout_ms": 8000,
  "max_retries": 2,
  "confidence_score": 0.93
}
```

## 23. Phase Deliverables with Definition of Done

Phase 0 DoD (Weeks 1-2):
- Gateway, orchestrator, and policy services run under a supervisor.
- Audit log captures `intent -> decision -> action -> result` chain.
- A dry-run command completes with trace ID and deterministic replay.

Phase 1 DoD (Weeks 3-6):
- Voice command can trigger at least 20 control actions.
- 90%+ success measured across a fixed regression command suite.
- Failure paths return actionable user messages within timeout budget.

Phase 2 DoD (Weeks 7-10):
- Vision verification required for medium/high-risk UI actions.
- OCR + element locator pass baseline dataset thresholds.
- Adaptive FPS policy activates under load as designed.

Phase 3 DoD (Weeks 11-13):
- Comms connectors support read + draft + approval gate.
- Mobile approvals include cryptographic session validation.
- All send actions are attributable in audit records.

Phase 4 DoD (Weeks 14-16):
- Connector registry enforces schema + policy validation pre-enable.
- Plugin runtime sandbox blocks unauthorized filesystem/network access.
- Connector health degradation auto-disables failing integrations.

Phase 5 DoD (Weeks 17-18):
- NeuroCore suggests automations with explicit rationale.
- Users can accept/reject suggestions, and decisions retrain ranking.
- EcoSystem budgets are enforced under stress/perf test.

Phase 6 DoD (Weeks 19-20):
- Threat model review issues are closed or risk-accepted.
- Chaos scenarios meet recovery objectives.
- Installer, update, and rollback paths validated.

## 24. Test Gates and Release Criteria

Pre-merge quality gates:
- Unit tests for policy, planner, and adapters must pass.
- Contract tests for event schemas and capability manifests must pass.
- Integration tests for top 20 user commands must pass.
- Security checks (secrets scan, dependency scan, manifest signature validation) must pass.

Release gates (beta):
- Core command success rate >= 95% on supported baseline hardware.
- No `critical` action can execute without explicit policy or approval evidence.
- p95 latency targets in Section 12 must be met for 48-hour soak runs.
- Degraded mode must preserve command acknowledgment and safe abort behavior.

## 25. Alignment with Existing Repository (Immediate Practical Mapping)

This repository currently contains a Flutter app with offline/online AI workflows. To keep delivery incremental:

Near-term integration mapping:
- Use `lib/data/services/` as initial integration point for local gateway client stubs.
- Add policy and audit abstractions first in `lib/domain/usecases/` and `lib/data/repositories/`.
- Introduce capability metadata under a new `assets/config/capabilities/` directory.
- Keep existing chat/image features operational while Phase 0 scaffolding is added behind feature flags.

Migration principle:
- No big-bang rewrite. Ship AURA capabilities as additive slices with backward-compatible routing from current app screens.
