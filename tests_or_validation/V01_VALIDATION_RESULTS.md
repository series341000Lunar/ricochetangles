---
project: RicochetAngles
phase_id: PHASE-V0.1
document_type: validation_results
status: PENDING_USER_VALIDATION
validated: 2026-07-28
godot: 4.7.1.stable.official.a13da4feb
---

# Phase V0.1 Moving Target Combat Spike Validation Results

## Summary

기존 V0 사용자 판정 `PASS` 위에 정확히 한 대의 이동 표적을 추가했다. 표적은 결정론적 2점 순찰을 하며, 기존 APHE와 독립 2D 장갑 판정의 `PENETRATION`에만 HP 1을 잃는다. HP 3에서 세 번 관통되면 한 번만 `DESTROYED`로 전환한다.

- Codex automated assessment: `PASS`
- Overall gate: `PENDING_USER_VALIDATION`
- Existing V0 regression: `PASS`
- Windows export/run: `PASS`
- Web export: V0에서 이미 PASS; V0.1에서는 필수 Windows gate에 집중해 재export하지 않음

## Repository Audit

- 시작 branch: `main`
- 시작 HEAD: `abd32aeade05190bef05df7f378914f38834ba6c`
- 시작 status: `M scenes/test_range.tscn`
- 시작 변경 원인: 사용자가 Godot 편집 중 `TopDownCamera`를 실수로 삭제하고 기타 씬 직렬화 변경을 남김
- 복구 승인: 사용자 명시 승인 후 `CameraRig/TopDownCamera`만 복원
- 복구 직후 기존 V0 runner: `PASS=9 FAIL=0`, exit 0
- 검증 엔진: `C:\Godot\Godot_console.exe`, Godot `4.7.1.stable.official.a13da4feb`
- 계약: `AGENTS.md`와 `MIGRATION_PHASES.md` 모두 `PHASE-V0.1`
- commit/push/branch 변경: 없음

## Changed Files and Responsibilities

- `scripts/moving_target_controller.gd`: delta 기반 월드 X축 2점 순찰, 반전, 격파 정지, reset
- `scenes/moving_target_tank.tscn`: 기존 표적 primitive/collider를 재사용하는 유일한 이동 표적
- `scripts/target_tank.gd`: 선택적 HP 3, 관통 피해, 단일 DESTROYED 전환, collider/시각/reset
- `scenes/test_range.tscn`: 기존 세 표적 중 SideTarget 한 대만 이동 표적으로 교체, debug 경로 연결
- `scripts/debug_overlay.gd`: 실제 판정 report의 피해·HP·상태와 이동 표적 live 상태 표시
- `tests_or_validation/v01_validation_runner.gd`: V0.1-T01~T05 결정론적 자동 검사
- `README_V0.md`: V0.1 실행·규칙·검증·범위 기록
- `tests_or_validation/V01_VALIDATION_RESULTS.md`: 본 결과 문서

`scripts/armor_logic_2d.gd`, `scripts/projectile.gd`, `scripts/turret_aim.gd`, `scripts/camera_controller.gd`의 판정·포탄·조준·카메라 의미론은 변경하지 않았다.

## Automated Validation Results

| Test | Codex | User | Evidence | Notes |
|---|---|---|---|---|
| V0.1-T01 이동·조준 | PASS | NOT_TESTED | 이동 표적 group 1대; 60/30Hz 위치 오차 0.0000m; 끝점 반전; 두 카메라 aim true | 실제 추적 조준 감각은 사용자 확인 필요 |
| V0.1-T02 이동 중 장갑 | PASS | NOT_TESTED | 이동 yaw에서 TOP_DOWN/OBLIQUE 모두 `FRONT/NON_PENETRATION`, 결과·logical normal 동일 | 실제 화면의 normal 가독성 확인 필요 |
| V0.1-T03 피해 구분 | PASS | NOT_TESTED | 실제 projectile 처리 1회로 HP 3→2, report 1개; 비관통/도탄 후 HP 2 유지 | 실사격 확인 필요 |
| V0.1-T04 3회 관통 격파 | PASS | NOT_TESTED | HP `[2, 1, 0]`; DESTROYED event 1회; 추가 피해 0; 이동 정지; collider disabled | 격파 시각 확인 필요 |
| V0.1-T05 완전 초기화 | PASS | NOT_TESTED | 2회 반복 R 경로에서 HP/state/start/yaw/direction/progress/collider/visual/projectile/debug/camera 복원, 이동 재개 | 반복 키 입력 확인 필요 |

```text
V01_AUTOMATED_SUMMARY PASS=5 FAIL=0
V01_VALIDATION_EXIT=0
IMPORT_EXIT=0
MAIN_SCENE_EXIT=0
```

## Existing V0 Regression

```text
V0_AUTOMATED_SUMMARY PASS=9 FAIL=0
V0_REGRESSION_EXIT=0
```

기존 W/S/A/D, 포탑 독립, 두 카메라 ray-plane 조준, 카메라 전환 world aim hold, 전/측/후 장갑, yaw 변화, 도탄 방향, 반복 reset이 유지된다.

## Windows Export

- preset: `Windows Desktop`
- output: `build/windows/RicochetAnglesV0.exe`
- size: `109,522,096` bytes
- release export: exit 0
- exported build headless 120-frame run: exit 0

첫 export는 Godot `4.7.1.stable` Windows template 부재로 exit 1이었다. 공식 Godot 4.7.1 export template 패키지에서 Windows x86_64 debug/release 항목만 Godot 사용자 template 폴더에 설치한 뒤 재실행해 통과했다. template은 저장소에 포함하지 않았다.

```text
WINDOWS_EXPORT_EXIT=0
WINDOWS_BUILD_RUN_EXIT=0
```

## User Validation Checklist

각 항목을 `PASS / RISK / FAIL / NOT_TESTED`로 기록한다.

1. 탑다운에서 이동 표적 추적 조준
2. 사선에서 이동 표적 추적 조준
3. 마우스를 멈췄을 때 기존 world aim 유지
4. 이동 중 전면·측면·후면과 3D/logical normal 표시
5. 관통만 HP를 1 줄이는지
6. 비관통·도탄이 HP를 줄이지 않는지
7. 세 번째 관통에서 한 번만 DESTROYED가 되는지
8. 격파 후 이동·추가 피해·충돌이 중지되는지
9. R 후 HP 3, ALIVE, 시작 위치·방향과 collider/시각이 복구되는지
10. Windows export 빌드에서 전체 흐름이 조작되는지

## Risks

- 이동은 V0.1 판정에 필요한 단순 2점 순찰이며 장애물 회피나 navigation이 없다.
- 자동 검사는 수치와 상태 전이를 검증하지만 움직이는 표적을 마우스로 추적하는 감각은 사용자 판단이 필요하다.
- 격파 표현은 primitive를 어둡게 하고 기울이는 진단용 표현이다.
- Web은 V0에서 이미 PASS했으며 V0.1의 필수 gate는 Windows export다.

## Deferred

공격·추적·회피 AI, navigation, 장애물 반응, 이동 표적 추가, 웨이브·스폰·리스폰, 다른 탄종, 보스, Stage, SCORE/XP/drop, 사운드·정식 VFX·정식 아트, 전체 포팅은 구현하지 않았다.

## Stop Confirmation

> Phase V0.1의 검증 범위에서 작업을 종료했으며,
> 움직이는 표적 1대·HP 3·관통 격파를 넘어
> 보스·Stage·전체 탄종·전투 AI·정식 아트·전체 포팅으로 확장하지 않았다.

Codex 검증 이후 다음 gate는 사용자 직접 검증이다. V0.1 결과 기록 뒤 Godot 기능 추가를 중단하고 HTML Pilot H5B로 복귀한다.
