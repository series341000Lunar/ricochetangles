---
project: RicochetAngles
phase_id: PHASE-V0
document_type: validation_results
status: PENDING_USER_VALIDATION
validated: 2026-07-28
godot: 4.7.stable.official.5b4e0cb0f
---

# Phase V0 Validation Results

## Summary

V0의 테스트장, 이동, 포탑 분리, 두 직교 카메라, 마우스 XZ 지면 조준, APHE ray 충돌, 독립 2D 장갑 계산, 도탄 반사, 디버그 표시와 초기화를 구현했다.

Codex 자동/실행 검증은 V0-T01~T10을 모두 통과했다. 최종 엔진 판정은 사용자 직접 조작·판정 검증 전이므로 확정하지 않는다.

- Codex preliminary assessment: `PASS_WITH_RISK`
- Overall gate: `PENDING_USER_VALIDATION`
- Windows export: `PASS`
- Web export/browser load: `PASS`

## Repository Audit

- 시작 branch: `main`
- 시작 HEAD: `6fd4f7568c2664708b8002515beebe08ef6c309e`
- 시작 status: clean
- 기존 파일: `AGENTS.md`, `MIGRATION_PHASES.md`, `PHASE_V0_GODOT_FEASIBILITY_SPEC.md`, 빈 `project.godot`, icon
- 기존 main scene/script/export preset: 없음
- renderer: Compatibility
- PATH의 Godot: 없음
- 검증에 사용한 엔진: 공식 Godot `4.7.stable.official.5b4e0cb0f` portable
- HTML 파일/addon/MCP/C#/외부 package: 없음
- `PROJECT_CONTEXT.md`, `PHASE5_STAGE2_CLOSEOUT.md`: 저장소에 없음. 더 높은 우선순위의 현재 V0 계약 세 문서가 일치하므로 V0 구현을 막는 충돌로 보지 않았다.
- 과거 Godot Phase 1~11: `SUSPENDED`, 시작하지 않음

## Validation Results

| Test | Codex | User | Evidence | Notes |
|---|---|---|---|---|
| V0-T01 기본 이동 | PASS | NOT_TESTED | runner exit 0; 60Hz 4.067m, 30Hz 4.133m, 선회 뒤 포탑 오차 0.0000° | 실제 조작감은 사용자 확인 필요 |
| V0-T02 탑다운 조준 | PASS | NOT_TESTED | center/edge ray-plane 후 screen roundtrip 오차 0.5px 이내; 탑다운 캡처 | 조준 감각은 사용자 확인 필요 |
| V0-T03 사선 조준 | PASS | NOT_TESTED | center/edge ray-plane 후 screen roundtrip 오차 0.5px 이내; 사선 캡처 | 조준 감각은 사용자 확인 필요 |
| V0-T04 카메라 전환 | PASS | NOT_TESTED | 전환 뒤 world/stored aim 동일, `switch_hold=true`; 첫 mouse motion에서 해제 | 순간 전환 체감은 사용자 확인 필요 |
| V0-T05 정면 판정 | PASS | NOT_TESTED | 수직 관통, 비스듬한 비관통, 75° 이상 도탄 자동 검사; Web 실제 정면 관통 표시 | 경계 체감은 사용자 확인 필요 |
| V0-T06 측면·후면 | PASS | NOT_TESTED | SIDE 55mm, REAR 35mm 선택과 관통 결과 자동 검사 | 실제 표적 사격 확인 필요 |
| V0-T07 표적 yaw | PASS | NOT_TESTED | 발사점/방향 고정 후 yaw만 변경해 FRONT→SIDE와 armor 값 변경 | 사용자 판정 가독성 확인 필요 |
| V0-T08 도탄 방향 | PASS | NOT_TESTED | armor reflection vector와 projectile continuation vector exact match | 화면상 설득력은 사용자 확인 필요 |
| V0-T09 반복 초기화 | PASS | NOT_TESTED | 3회 반복에서 포탄, debug result, camera, world aim 초기화 | 반복 키 입력은 사용자 확인 필요 |
| V0-T10 export | PASS | NOT_TESTED | Windows/Web export exit 0; Windows build run exit 0; Web canvas 로드, console warn/error 0 | 사용자 Windows 조작 확인 필요 |

자동 러너 결과:

```text
V0_AUTOMATED_SUMMARY PASS=9 FAIL=0
VALIDATION_EXIT=0
```

추가 실행 결과:

```text
IMPORT_EXIT=0
MAIN_SCENE_EXIT=0
WINDOWS_EXPORT_EXIT=0
WEB_EXPORT_EXIT=0
WINDOWS_BUILD_RUN_EXIT=0
```

## Export Evidence

### Windows

- preset: `Windows Desktop`
- output: `build/windows/RicochetAnglesV0.exe`
- size: `109,124,816` bytes
- release export: exit 0
- exported build headless 120-frame run: exit 0

### Web

- preset: `Web`
- output: `build/web/index.html`
- release export: exit 0
- local HTTP browser load: PASS
- page title: `ricochetangles`
- canvas: 1
- internal canvas: 1920×1080
- displayed canvas: 1280×720
- browser warning/error console entries: 0
- top-down capture: `tests_or_validation/v0_web_capture.jpg`
- oblique capture: `tests_or_validation/v0_web_oblique_capture.jpg`

공식 Godot 4.7 TPZ에서 Windows x86_64 release와 Web non-threaded release template 항목만 설치해 export했다. template은 저장소에 포함하지 않았다.

## Implemented Files and Responsibilities

- `project.godot`: V0 main scene, viewport, Compatibility 실행 설정
- `export_presets.cfg`: Windows x86_64와 non-threaded Web release preset
- `scenes/test_range.tscn`: 바닥, 원점 축, 조명, 플레이어, 고정 표적 3대, 두 카메라, debug UI
- `scenes/player_tank.tscn`: primitive 플레이어, 이동 collider, 독립 turret pivot
- `scenes/target_tank.tscn`: primitive 고정 표적과 단순 물리 collider
- `scenes/projectile.tscn`: APHE 시각 노드
- `scripts/test_range.gd`: 발사, hit 전달, R 전체 초기화
- `scripts/player_tank.gd`: delta 기반 전후진·선회·가감속
- `scripts/turret_aim.gd`: 화면 ray와 XZ 지면 교차, 월드 포탑 yaw
- `scripts/camera_controller.gd`: 탑다운/사선 전환과 world aim hold
- `scripts/projectile.gd`: 프레임간 ray, 최초 충돌, 도탄 계속 비행
- `scripts/armor_logic_2d.gd`: 카메라·mesh 독립 장갑 순수 계산
- `scripts/target_tank.gd`: target ID, yaw, armor profile과 계산 호출
- `scripts/debug_overlay.gd`: 실제 hit result 표시와 월드 방향선
- `tests_or_validation/v0_validation_runner.gd`: V0-T01~T09 결정론적 검사
- `README_V0.md`: 실행, 조작, 계산 규칙, 범위

## Preliminary Engine Assessment

`PASS_WITH_RISK`

기술 근거:

- 차체/포탑 transform 분리와 두 직교 카메라의 XZ ray-plane 조준이 같은 구조에서 성립했다.
- 장갑 결과는 `Camera3D`, mesh, material, `physics_hit_normal_3d`를 입력으로 사용하지 않는다.
- 2D 논리 반사 결과가 실제 포탄 continuation vector로 직접 사용된다.
- 자동 시나리오, main scene, Windows export/run, Web export/browser load가 모두 성공했다.

남은 위험은 기술 실패가 아니라 사용자 검증 gate다.

- 탑다운/사선 실제 조준 감각
- 카메라 전환 순간의 체감
- 전/측/후 결과 가독성
- 비스듬한 명중과 도탄의 시각적 설득력
- Windows GUI 빌드에서의 직접 조작
- Godot 수정·검증 생산성에 대한 사용자 평가

## User Validation Checklist

각 항목을 `PASS / RISK / FAIL / NOT_TESTED`로 기록한다.

1. 탑다운 중심/가장자리 조준
2. 사선 중심/가장자리 조준
3. W/S/A/D와 차체·포탑 독립
4. C 직후 월드 목표 유지
5. mouse motion 후 새 카메라 조준 갱신
6. 정면/측면/후면 판정
7. 표적 yaw에 따른 결과 변화
8. 비스듬한 명중 도탄 변화
9. 도탄 방향의 시각적 설득력
10. 반복 R 초기화
11. Windows build 실행과 조작
12. Godot 작업 생산성 체감

## Risks

- 경계각 tie는 `abs(forward) >= abs(side)`일 때 FRONT/REAR로 고정했다.
- 유효 장갑 cosine은 수치 폭주 방지를 위해 최소 `0.05`로 clamp한다.
- 도탄 수는 V0에서 최대 1회다.
- 자동 검사는 조준 정확도와 벡터 정합성을 확인하지만 인간의 조준감/설득력은 대신 판정하지 못한다.
- 다른 브라우저/GPU와 다른 PC의 Windows 실행은 아직 확인하지 않았다.

## Deferred

보스, Stage, 전체 탄종, APCR, HE, GAS, AI, 일반 적, 생성/리스폰, 곡사포, 불릿타임, SCORE/XP, 아이템, 저장, 정식 HUD·사운드·모델·텍스처·VFX, 전체 포팅 구조는 V0 범위 밖이라 구현하지 않았다.

## Stop Confirmation

> Phase V0의 검증 범위에서 작업을 종료했으며, 보스·Stage·전체 탄종·AI·정식 아트·전체 포팅으로 확장하지 않았다.

Godot 기능 추가는 여기서 중단한다. 다음 gate는 사용자 직접 검증이며, 그 뒤 최종 판정과 HTML H5B 복귀를 기록한다.
