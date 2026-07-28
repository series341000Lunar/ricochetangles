---
project: RicochetAngles
document_type: validation_spec
phase_id: PHASE-V0
title: Godot Core Feasibility Spike
status: READY
updated: 2026-07-28
engine_candidate: Godot
fallback_candidate: Unreal Engine 5
authority:
  scope: this_file
  coding_contracts: AGENTS.md
  implementation_truth: generated_godot_project
---

# Phase V0 — Godot Core Feasibility Spike

## 1. Phase 목적

이 Phase는 HTML판 전체를 Godot으로 포팅하는 작업이 아니다.

> Godot에서 RicochetAngles의 핵심 전차 조작, 마우스 조준, 2D 장갑 판정, 도탄 및 사선 카메라 표현을 합리적인 구조로 구현할 수 있는가?

합격 시:

1. Godot를 본 포팅 엔진 후보로 잠정 확정한다.
2. 검증 결과와 실행 가능한 프로젝트를 보존한다.
3. Godot 개발을 즉시 중단한다.
4. HTML Pilot 개발로 복귀한다.

불합격 시:

1. 실패가 단순 학습비용인지 구조적 부적합인지 분류한다.
2. 구조적 부적합일 때만 UE5 최소 검증을 별도 수행한다.
3. 어느 엔진을 선택하든 본격 포팅은 HTML Pilot 규칙 확정 뒤 시작한다.

## 2. 핵심 원칙

- 논리 판정은 2D 평면을 기준으로 한다.
- 카메라와 시각 표현은 논리 판정에서 분리한다.
- 사선 또는 아이소메트릭 화면에서도 동일한 2D 판정 결과가 나와야 한다.
- 정식 아트보다 디버그 가시성을 우선한다.
- HTML판의 전체 구조를 복제하지 않는다.
- V0 코드의 장기 재사용보다 엔진 적합성 판단을 우선한다.
- 합격 조건을 충족하면 더 개발하지 않는다.

## 3. 최소 테스트 환경

### 3.1 테스트장

- 단색 평면 바닥
- 좌표 격자 또는 월드 원점 표시
- 플레이어 전차 1대
- 고정 표적 최대 3대
- primitive mesh 또는 단순 임시 모델
- 조명은 판독 가능한 최소 수준

### 3.2 플레이어 전차

필수:

- 차체 전진·후진
- 차체 좌우 선회
- 간단한 가속·감속 또는 관성
- 차체와 포탑 독립 회전
- 포탑이 마우스 월드 지점을 조준
- 차체 방향과 무관하게 포탑 조준 유지

검증:

- 프레임레이트 변화에 따른 이동 안정성
- 직교 카메라의 ray-plane 교차
- 카메라 전환 뒤 동일 월드 지점 조준
- 차체·포탑 로컬/월드 회전 분리

### 3.3 카메라

필수:

1. 탑다운 직교 카메라
2. 사선 직교 카메라

사선 카메라는 엄격한 아이소메트릭 완성을 요구하지 않는다.

검증:

- 카메라 각도와 무관한 마우스 지면 조준
- 화면 중심과 가장자리의 조준 오차
- 카메라 전환 후 동일 월드 지점 유지
- 2D 논리 좌표와 3D 시각 좌표의 일치

### 3.4 포탄

- APHE 1종만 사용
- 직선 이동 또는 단순 3D sweep
- 발사 위치·진행 방향 표시
- 명중 시 충돌점과 법선 표시

결과:

- 도탄
- 비관통
- 관통

## 4. 2D 장갑 판정 사양

### 4.1 입력

- 표적 2D 위치
- 표적 차체 yaw
- 포탄 2D 진행 방향
- 충돌 위치 또는 표적 로컬 충돌 방향
- 전면·측면·후면 장갑값
- 포탄 관통력

### 4.2 면 구분

- 전면
- 측면
- 후면

판정은 3D mesh triangle, 시각 material, 카메라 transform에 종속되지 않는다.

### 4.3 필수 판정 사례

- 정면 수직 명중
- 정면 비스듬한 명중
- 측면 수직 명중
- 후면 명중
- 표적 차체 회전 후 동일 발사점 명중

### 4.4 디버그 출력

- 맞은 면
- 표적 차체 각도
- 포탄 진행 방향
- 표면 법선 또는 2D 기준 법선
- 입사각
- 기본 장갑값
- 유효 장갑값
- 관통력
- 최종 결과
- 도탄 시 반사 방향

## 5. 권장 구조

```text
GodotSpike/
├─ project.godot
├─ scenes/
│  ├─ test_range.tscn
│  ├─ player_tank.tscn
│  ├─ target_tank.tscn
│  └─ projectile.tscn
├─ scripts/
│  ├─ player_tank.gd
│  ├─ turret_aim.gd
│  ├─ projectile.gd
│  ├─ armor_logic_2d.gd
│  ├─ target_tank.gd
│  ├─ camera_controller.gd
│  └─ debug_overlay.gd
└─ README_V0.md
```

| 파일 | 책임 |
|---|---|
| `player_tank.gd` | 차체 이동·선회 |
| `turret_aim.gd` | 마우스 지면 조준·포탑 회전 |
| `projectile.gd` | 발사·이동·충돌 요청 |
| `armor_logic_2d.gd` | 카메라·mesh와 독립된 장갑 판정 |
| `target_tank.gd` | 표적 방향·장갑 profile |
| `camera_controller.gd` | 탑다운/사선 카메라 전환 |
| `debug_overlay.gd` | 판정 정보 표시 |

## 6. 입력 제안

| 입력 | 기능 |
|---|---|
| `W/S` | 전진·후진 |
| `A/D` | 차체 선회 |
| 마우스 | 포탑 조준 |
| 좌클릭 | APHE 발사 |
| `C` | 카메라 전환 |
| `F1` | 디버그 오버레이 |
| `R` | 테스트장 초기화 |
| `Esc` | 종료 또는 메뉴 |

## 7. 명시적 제외 범위

- Stage 1 또는 Stage 2 이식
- 보스
- 부위파괴·궤도·엔진·폭주
- APCR·HE·GAS
- 경전차·대전차포·보병
- 곡사포·Q 포격·불릿타임
- SCORE·XP·드롭
- Stage Director·체크포인트
- 맵 에디터·저장
- 정식 UI·사운드·모델링·이펙트
- Steam 기능
- HTML판 전체 데이터 구조

## 8. 검증 시나리오

| ID | 시나리오 | 확인 항목 |
|---|---|---|
| V0-T01 | 기본 이동 | 차체 이동·선회, 포탑 독립 |
| V0-T02 | 탑다운 조준 | 중심·가장자리 지면 조준 정확도 |
| V0-T03 | 사선 조준 | 카메라 각도와 무관한 월드 조준 |
| V0-T04 | 카메라 전환 | 동일 월드 목표 유지 |
| V0-T05 | 정면 판정 | 수직·비스듬한 명중 결과 |
| V0-T06 | 측면·후면 판정 | 올바른 면·장갑값 선택 |
| V0-T07 | 차체 회전 | yaw 변화에 따른 면·입사각 변화 |
| V0-T08 | 도탄 방향 | 계산 반사와 시각 반사 일치 |
| V0-T09 | 반복 초기화 | 포탄·표시·상태 누수 없음 |
| V0-T10 | export | Windows, 가능하면 Web 실행 |

## 9. 합격 기준

| 항목 | 합격 기준 |
|---|---|
| 차체·포탑 분리 | 두 회전 체계가 안정적으로 독립 |
| 마우스 조준 | 탑다운·사선 모두 정확 |
| 판정 분리 | 카메라·mesh 변경이 2D 결과에 영향 없음 |
| 면 판정 | 전면·측면·후면이 일관되게 구분 |
| 도탄 | 입사각 결과와 시각 반사 방향이 일치 |
| 생산성 | 소규모 기능 추가·디버깅이 비합리적으로 복잡하지 않음 |
| 배포 | Windows export 정상 |
| 웹 | 가능하면 Web export 정상, 실패 시 원인 기록 |

판정값:

- `PASS`
- `PASS_WITH_RISK`
- `FAIL_TECHNICAL`
- `FAIL_PRODUCTIVITY`
- `INCONCLUSIVE`

## 10. 불합격으로 오해하지 않을 현상

- Godot 문법과 노드 구조가 낯섦
- 첫 구현이 HTML보다 느림
- 임시 이동감이 HTML과 다름
- primitive mesh가 보기 좋지 않음
- 첫 raycast 구현 오류
- 초기 export 설정 필요
- 아직 튜닝하지 않은 가속·선회감

구조적 문제와 단순 구현 오류를 구분한다.

## 11. 종료 산출물

- 실행 가능한 Godot 최소 프로젝트
- `README_V0.md`
- 검증 결과표
- 각 항목의 `PASS / RISK / FAIL`
- 실행 캡처 또는 짧은 영상
- Windows export
- 가능하면 Web export
- 알려진 문제
- 엔진 적합성 최종 판정
- 다음 행동

## 12. Stop Rule

다음 중 하나가 충족되면 종료한다.

1. 핵심 합격 기준이 확인됨
2. Godot의 구조적 부적합이 충분히 입증됨
3. 제한된 추가 검증 없이는 결론을 낼 수 없다고 기록됨

합격 뒤 다음을 추가하지 않는다.

- 보스
- Stage 1·2
- 정식 모델
- APCR·HE
- 적 AI
- 본격 Godot판 개발

V0의 성공은 더 개발하는 것이 아니라 불확실성을 제거하고 HTML로 돌아가는 것이다.
