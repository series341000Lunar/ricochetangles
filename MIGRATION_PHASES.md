---
project: RicochetAngles
document_type: migration_and_phase_gate
status: ACTIVE
active_phase: PHASE-V0.1
updated: 2026-07-28
whole_port_status: SUSPENDED
post_v01_destination: HTML-H5B
---

# RicochetAngles Godot Migration Phases

## 1. Document Purpose

이 문서는 현재 Godot 작업의 순서와 종료 조건을 정의한다.

현재 Godot 작업은 전체 포팅이 아니다.

기존 `Phase V0 — Godot Core Feasibility Spike`는 사용자 검증 결과 `PASS`로 완료되었다.

현재 활성 단계는 오직 다음 하나다.

> `Phase V0.1 — Moving Target Combat Spike`

기존 Godot Phase 1~11은 현재 실행하지 않는다.

V0.1은 기존 Phase 1을 시작하는 작업이 아니다.

V0.1에서 움직이는 표적 1대와 3회 관통 격파만 확인한 뒤 Godot 작업을 중단하고 HTML Pilot의 `H5B — 방향 계약·장갑 체감 진단`으로 복귀한다.

본격 Godot 포팅은 HTML Pilot 규칙과 대표 플레이 기준판이 확정된 뒤 별도 `G0R`에서 전면 재설계한다.

## 2. Current Development Flow

```text
Godot V0 완료
        ↓
V0 결과 PASS 보존
        ↓
사용자 승인 V0.1 예외
        ↓
움직이는 표적 1대
        ↓
HP 3 / 관통 시 HP -1
        ↓
3회 관통 격파
        ↓
탑다운·사선 사용자 검증
        ↓
V0.1 종료 기록
        ↓
Godot 작업 중단
        ↓
HTML H5B 복귀
```

## 3. Phase Status

| Phase | Name | Status | Next Action |
|---|---|---|---|
| V0-A~J | Godot Core Feasibility Spike | COMPLETED / PASS | 결과 보존 |
| V0.1-A | 범위·회귀 감사 | READY | V0 결과와 금지 범위 확인 |
| V0.1-B | 움직이는 표적 1대 | PLANNED | 단순 결정적 이동 |
| V0.1-C | 관통 피해·HP 3 | PLANNED | 관통만 HP 감소 |
| V0.1-D | 격파·초기화 | PLANNED | 파괴 상태와 R reset |
| V0.1-E | 사용자 검증·Stop | BLOCKED | 실행 프로젝트 필요 |
| H5B | HTML 장갑 체감 진단 | QUEUED | V0.1 종료 후 복귀 |
| G0R | 본격 엔진 포팅 재기준화 | SUSPENDED | HTML Pilot 기준판 필요 |
| G1~G11 | 과거 전체 포팅 계획 | SUSPENDED | 자동 재개 금지 |

# Phase V0-A — Repository and Contract Audit

## Status

`READY`

## Goal

Godot 저장소가 V0를 수행할 수 있는 상태인지 확인하고 과거 전체 포팅 문서와 현재 V0 계약의 충돌을 제거한다.

## Required Reads

1. `AGENTS.md`
2. `MIGRATION_PHASES.md`
3. `PHASE_V0_GODOT_FEASIBILITY_SPEC.md`
4. `CODEX_TASK_PHASE_V0_GODOT.md`
5. `PROJECT_CONTEXT.md`
6. `PHASE5_STAGE2_CLOSEOUT.md`
7. `project.godot`
8. 현재 README
9. 현재 scenes와 scripts

## Audit Checklist

- [ ] 현재 branch 확인
- [ ] 현재 작업 트리 확인
- [ ] Godot project root 확인
- [ ] Godot version 확인
- [ ] renderer 확인
- [ ] main scene 유무 확인
- [ ] 기존 scene 확인
- [ ] 기존 script 확인
- [ ] export preset 확인
- [ ] HTML 파일이 저장소에 없는지 확인
- [ ] MCP와 addon이 없는지 확인
- [ ] V0 외 구현이 없는지 확인
- [ ] 수정 예상 파일 목록 작성
- [ ] 기존 Phase 1~11을 시작하지 않음을 확인
- [ ] V0 종료 후 HTML H5B 복귀를 확인

## Required Report Before Coding

### Repository State

- project root
- branch
- git status
- Godot version
- renderer
- current main scene
- existing files

### Contract Assessment

- 문서 충돌 여부
- V0 범위
- 명시적 제외 범위
- Stop Rule

### Planned Changes

- 생성 또는 수정 파일
- 각 파일의 책임
- 예상 검증 명령
- export 계획

## Completion Criteria

- 저장소 구조를 확인함
- 세 계약 문서가 같은 V0 범위를 가리킴
- 과거 Phase 1~11이 `SUSPENDED`임을 확인함
- HTML 수정이 필요하지 않음을 확인함
- 사용자 승인 범위 밖 작업 계획이 없음

# Phase V0-B — Minimal Test Range

## Status

`PLANNED`

## Dependencies

- V0-A 완료

## Goal

다른 게임 시스템 없이 조작, 조준, 충돌, 장갑 판정을 검증할 최소 3D 테스트장을 만든다.

## In Scope

- 단색 평면
- 격자 또는 원점
- 최소 조명
- 플레이어 primitive 전차 1대
- 고정 표적 최대 3대
- 탑다운 직교 카메라
- 사선 직교 카메라
- 최소 debug UI
- R 초기화 기반

## Out of Scope

- 정식 맵
- 장애물 시스템
- 적 AI
- 보스
- Stage 데이터
- 정식 아트
- 정식 HUD

## Manual Check

- 프로젝트 실행
- 바닥과 전차 표시
- 표적 표시
- 두 카메라 존재
- F1 overlay 표시
- R 초기화

## Completion Criteria

- 테스트장이 오류 없이 실행됨
- V0 기능을 추가할 최소 노드 구조가 있음
- 정식 게임 구조로 과설계하지 않음

# Phase V0-C — Movement, Turret, and Ground Aim

## Status

`PLANNED`

## Dependencies

- V0-B 완료

## Goal

차체 이동, 차체·포탑 회전 분리, 마우스 지면 조준을 검증한다.

## In Scope

- W 전진
- S 후진
- A/D 선회
- delta 기반
- 간단한 가속
- 간단한 감속
- 차체와 포탑 독립
- 화면 마우스 ray
- XZ 평면 교차
- 월드 조준점
- 포탑 yaw
- 조준점 debug marker

## Required Debug

- player position
- hull yaw
- turret yaw
- forward speed
- mouse screen position
- world aim point

## Test V0-T01

### Scenario

기본 이동

### Checks

- W/S 전후진
- A/D 선회
- 횡이동 없음
- 포탑 독립
- 프레임레이트 변화에 큰 불안정 없음

## Test V0-T02

### Scenario

탑다운 조준

### Checks

- 화면 중심 조준
- 화면 가장자리 조준
- 포탑이 월드 지점을 향함
- 차체 회전 중 조준 유지

## Completion Criteria

- V0-T01 Codex 검증 통과
- V0-T02 Codex 검증 통과 또는 위험 기록
- 이동감 부족을 구조 실패로 오판하지 않음

# Phase V0-D — Orthographic Camera Comparison

## Status

`PLANNED`

## Dependencies

- V0-C 완료

## Goal

탑다운과 사선 직교 카메라에서 동일한 논리 조준 구조가 성립하는지 확인한다.

## In Scope

- top-down orthographic
- oblique orthographic
- C 전환
- active camera 표시
- 전환 직전 월드 조준점 저장
- 전환 직후 저장 목표 유지
- 다음 mouse motion에서 새 ray-plane 결과 사용

## Camera Switch Contract

1. current world aim point 저장
2. C 입력
3. camera 전환
4. mouse motion 전까지 stored aim 유지
5. mouse motion 후 새 camera ray-plane 결과 적용

## Required Debug

- active camera
- stored aim point
- current aim point
- mouse moved after switch
- camera transform

## Test V0-T03

### Scenario

사선 조준

### Checks

- 화면 중심
- 화면 가장자리
- 포탑 world aim
- 카메라 각도와 장갑 판정 독립

## Test V0-T04

### Scenario

카메라 전환

### Checks

- 전환 직후 동일 월드 목표 유지
- 마우스 이동 후 새 카메라 기준 갱신
- 포탑 순간 튐 또는 잘못된 회전 없음

## Completion Criteria

- 두 카메라에서 조준 구조 성립
- 카메라 transform이 장갑 계산에 들어가지 않음
- V0-T03, T04 결과 기록

# Phase V0-E — APHE Projectile and Collision

## Status

`PLANNED`

## Dependencies

- V0-D 완료

## Goal

APHE 1종의 발사, 이동, 최초 충돌, 충돌점과 노멀 획득을 검증한다.

## In Scope

- 좌클릭 발사
- APHE 1종
- projectile ID
- source ID
- previous position
- current intended position
- ray 또는 작은 sweep
- nearest first hit
- physics hit point
- physics hit normal
- projectile cleanup
- R reset cleanup

## Out of Scope

- 탄약
- reload
- APCR
- HE
- bloom
- sound
- particle polish

## Manual Checks

- 고속 이동 중 표적 통과 없음
- 가장 가까운 표적만 처리
- 한 프레임 다중 피해 없음
- 충돌점 표시
- physics normal 표시
- reset 후 포탄 없음

## Completion Criteria

- 안정적인 최초 충돌 확보
- logical armor 모듈에 전달할 입력 확보
- 물리 노멀은 진단값으로 분리

# Phase V0-F — Independent 2D Armor Logic

## Status

`PLANNED`

## Dependencies

- V0-E 완료

## Goal

카메라, mesh, 3D triangle normal과 독립된 XZ 평면 장갑 판정을 구현한다.

## Required Inputs

- target position 2D
- target yaw
- projectile direction 2D
- hit point 또는 local hit direction
- front armor
- side armor
- rear armor
- penetration
- ricochet threshold

## Required Outputs

- zone
- logical armor normal
- incidence angle
- base armor
- effective armor
- penetration
- result
- reason
- reflected direction

## Result Values

- `RICOCHET`
- `NON_PENETRATION`
- `PENETRATION`

## Test V0-T05

### Scenario

정면 판정

### Cases

- 정면 수직 명중
- 정면 비스듬한 명중
- 자동 도탄 경계 전후

## Test V0-T06

### Scenario

측면과 후면

### Cases

- 측면 수직 명중
- 후면 수직 명중
- 올바른 장갑값 선택

## Test V0-T07

### Scenario

표적 차체 회전

### Cases

- 발사점과 포탄 방향 고정
- target yaw만 변경
- zone 변경
- incidence 변경
- result 변경

## Completion Criteria

- 카메라 전환으로 결과가 변하지 않음
- primitive mesh 변경으로 결과가 변하지 않음
- 전·측·후 구분 일관적
- 수치 폭주 없음
- T05~T07 결과 기록

# Phase V0-G — Ricochet Direction and Debug Visualization

## Status

`PLANNED`

## Dependencies

- V0-F 완료

## Goal

논리적 도탄 반사와 실제 화면상의 포탄 반사가 일치하는지 확인한다.

## Required Separation

### physics_hit_normal_3d

- Godot query 결과
- 시각 및 collider 진단
- 장갑 권위값 아님

### logical_armor_normal_2d

- target yaw와 zone에서 계산
- 입사각 권위값
- effective armor 권위값
- ricochet direction 권위값

## In Scope

- incoming vector 표시
- physics normal 표시
- logical normal 표시
- reflected vector 표시
- 포탄 실제 반사
- separation offset
- 최근 판정 overlay
- F1 toggle

## Test V0-T08

### Scenario

도탄 방향

### Checks

- 계산 벡터와 debug arrow 일치
- 포탄 실제 진행 방향과 일치
- 표적 yaw 변경 시 자연스럽게 변화
- 카메라 전환에도 논리 방향 유지
- 동일 표면 즉시 재충돌 없음

## Completion Criteria

- 반사 계산과 시각 반사가 일치
- 두 normal을 혼동하지 않음
- 디버그 정보가 실제 결과 객체를 사용
- T08 결과 기록

# Phase V0-H — Reset, Export, and Codex Validation

## Status

`PLANNED`

## Dependencies

- V0-G 완료

## Goal

반복 초기화, Windows export, 가능하면 Web export와 Codex 자체 검증을 완료한다.

## Test V0-T09

### Scenario

반복 초기화

### Checks

- R 반복
- player transform 초기화
- target transform 초기화
- camera 초기화
- aim state 초기화
- projectile 제거
- debug result 초기화
- 충돌 표시 제거
- 상태 누수 없음

## Test V0-T10

### Scenario

Export

### Required

- Windows export 생성
- Windows 실행
- 조작
- 조준
- 발사
- 판정
- 카메라 전환
- reset

### Optional

- Web export 생성
- 로컬 서버 실행
- 브라우저 조작과 판정
- 실패 시 원인 분류

## Codex Assessment

Codex는 다음 중 하나를 제시한다.

- PASS
- PASS_WITH_RISK
- FAIL_TECHNICAL
- FAIL_PRODUCTIVITY
- INCONCLUSIVE

사용자 검증 전에는 `Preliminary`라고 명시한다.

## Completion Criteria

- V0-T01~T10 표 작성
- Windows export 실행
- Web 결과 또는 실패 사유
- README_V0
- V0_VALIDATION_RESULTS
- 캡처 또는 영상
- preliminary assessment
- Stop Rule 확인

# Phase V0-I — User Direct Validation

## Status

`BLOCKED`

## Dependencies

- V0-H 완료
- 사용자가 실행 프로젝트 또는 Windows build를 받음

## Goal

Codex가 대신 판단할 수 없는 조작감, 조준감, 판정 설득력, 생산성을 사용자가 직접 확인한다.

## User Checklist

1. 탑다운 조준 감각
2. 사선 조준 감각
3. 화면 중심과 가장자리 조준 오차
4. 차체·포탑 분리
5. 카메라 전환 직후 월드 목표 유지
6. 마우스 이동 후 새 카메라 조준 갱신
7. 정면 판정
8. 측면 판정
9. 후면 판정
10. 표적 yaw 변경
11. 비스듬한 명중 도탄 변화
12. 도탄 방향의 시각적 설득력
13. 반복 R 초기화
14. Windows build
15. Godot 작업 생산성 체감

## User Result Format

각 항목:

- PASS
- RISK
- FAIL
- NOT_TESTED

사용자는 다음을 별도로 기록한다.

- 가장 불편한 조작
- 이해하기 어려운 판정
- 카메라별 선호
- 도탄 표현의 설득력
- Godot 수정·검증 사이클의 체감
- 본 포팅 후보로 보존할 가치

## Completion Criteria

- 핵심 사용자 항목 테스트
- 기술 결과와 체감 결과의 차이 기록
- 최종 판정에 필요한 근거 확보

# Phase V0-J — Final Assessment and Stop

## Status

`COMPLETED — PASS`

## Dependencies

- V0-I 완료 또는 사용자가 검증 불가 사유를 명시

## Goal

Godot V0의 최종 결과는 `PASS`로 확정되었다.

이후 사용자가 움직이는 표적과 최소 격파 감각을 한 번 더 확인하기 위해 V0.1을 명시적으로 승인했다. 이는 Stop Rule의 일회성 사용자 승인 예외이며, 전체 포팅 재개로 해석하지 않는다.

## Final Values

### PASS

- 기술적 핵심 성립
- 생산성 합리적
- 중대한 위험 없음

### PASS_WITH_RISK

- 기술적 핵심 성립
- 관리 가능한 위험 존재
- 본 포팅 전 G0R에서 재설계 필요

### FAIL

원인을 함께 기록한다.

- `FAIL_TECHNICAL`
- `FAIL_PRODUCTIVITY`
- 둘 다

### INCONCLUSIVE

- 결론을 막은 항목
- 필요한 최소 추가 검증
- 지금 추가 검증을 하지 않는 이유

## Required Outputs

- 최종 판정
- 기술 근거
- 사용자 근거
- 위험
- export 결과
- 보존할 산출물
- 폐기 가능한 코드
- 미래 G0R 참고사항
- Stop confirmation

## Mandatory Stop

V0.1 예외 외에는:

- Godot 기능 추가 금지
- bugfix 확장 금지
- polish 금지
- refactor 금지
- 보스 금지
- 탄종 추가 금지
- AI 금지
- Stage 금지
- 전체 포팅 금지

결과 보존에 필요한 다음만 허용한다.

- 문서 오탈자 수정
- 실행법 보완
- 검증 캡처 정리
- export 파일 위치 정리
- 명백한 결과 기록 오류 수정

## Completion Criteria

- V0 결과 `PASS` 확정
- V0 산출물과 export 보존
- 사용자 승인 V0.1만 예외로 등록
- 기존 Phase 1~11은 계속 `SUSPENDED`


# Phase V0.1-A — Scope and Regression Audit

## Status

`READY`

## Goal

V0의 합격 결과를 보존하면서 V0.1의 범위를 움직이는 표적 1대와 관통 격파로 제한한다.

## Required Checks

- [ ] V0 자동 검증이 계속 통과
- [ ] 탑다운·사선 카메라 유지
- [ ] 기존 2D 장갑 판정 변경 없음
- [ ] APHE 1종 외 탄종 추가 없음
- [ ] 움직이는 표적은 정확히 1대
- [ ] 플레이어 공격 AI 없음
- [ ] 경로 탐색 없음
- [ ] 생성·리스폰 없음
- [ ] HP는 3
- [ ] 관통만 피해 적용
- [ ] V0.1 완료 뒤 HTML H5B 복귀

## Planned Changes

허용되는 새 책임:

- 움직이는 표적의 단순 이동
- HP와 파괴 상태
- 기존 장갑 결과를 피해에 연결
- R reset 확장
- V0.1 검증 결과 기록

## Completion Criteria

- V0 회귀 없음
- 범위 밖 구현 계획 없음
- 수정 파일과 테스트 계획 보고

# Phase V0.1-B — Single Moving Target

## Status

`PLANNED`

## Dependencies

- V0.1-A 완료

## Goal

고정 표적 중 하나를 단순 이동 표적으로 바꾸거나 움직이는 표적 1대를 추가한다.

## Movement Contract

- 표적 수: 정확히 1대
- 결정적이고 반복 가능한 이동
- 두 지점 왕복, 짧은 순찰 원 또는 동등한 단순 패턴
- delta 기반
- 방향 전환 시 차체 yaw 갱신 가능
- 플레이어 추격 없음
- 회피 없음
- 장애물 경로 탐색 없음
- 포탑 조준 없음
- 플레이어 공격 없음
- 생성·리스폰 없음

## Test V0.1-T01

### Scenario

반복 가능한 이동

### Checks

- 실행할 때마다 같은 시작 위치
- 이동이 프레임레이트에 크게 의존하지 않음
- 방향 전환 정상
- R 입력 후 시작 위치와 진행 방향 복원
- 탑다운·사선 카메라에서 표시 정상

## Completion Criteria

- 움직이는 표적 1대만 존재
- 기존 V0 장갑·포탄 기능 회귀 없음
- V0.1-T01 기록

# Phase V0.1-C — Penetration Damage and HP 3

## Status

`PLANNED`

## Dependencies

- V0.1-B 완료

## Goal

기존 장갑 판정의 결과를 표적 HP에 연결한다.

## Damage Contract

- maximum HP: 3
- initial HP: 3
- `PENETRATION`: HP -1
- `NON_PENETRATION`: HP 변화 없음
- `RICOCHET`: HP 변화 없음
- projectile당 피해 최대 1회
- HP clamp: 0~3
- debug overlay에 현재 HP 표시
- damage result와 armor result를 같은 이벤트로 기록

## Test V0.1-T02

### Scenario

이동 중 장갑 판정

### Checks

- 이동과 yaw 변화 중 전면·측면·후면 판정
- 카메라 모드가 결과에 영향 없음
- physics normal이 피해 권위값이 아님

## Test V0.1-T03

### Scenario

피해 구분

### Checks

- 관통 시에만 HP 감소
- 비관통은 HP 유지
- 도탄은 HP 유지
- 한 포탄의 중복 피해 없음

## Completion Criteria

- 장갑 결과와 HP가 정확히 연결
- V0.1-T02, T03 기록
- 신규 탄종과 전투 AI 없음

# Phase V0.1-D — Destroyed State and Reset

## Status

`PLANNED`

## Dependencies

- V0.1-C 완료

## Goal

3회 관통 후 표적이 명확히 격파되고 R로 완전히 복구되는지 확인한다.

## Destroyed State

HP 0에서:

- `DESTROYED` 상태 진입
- 이동 중단
- 추가 피해 중단
- 전투용 collider 비활성화 또는 동등한 중복 피격 방지
- 색상 변경, 기울어짐, 비활성 표시 또는 소멸 중 하나
- 정식 폭발 VFX와 사운드 없음
- SCORE, XP, drop 없음
- respawn 없음

## Reset

R 입력 시:

- HP 3
- ALIVE 상태
- 시작 transform
- 시작 이동 방향
- 이동 타이머
- collider
- 파괴 표시
- 최근 damage debug
- 기존 포탄과 충돌 표시

## Test V0.1-T04

### Scenario

3회 관통 격파

### Checks

- 첫 관통: HP 2
- 두 번째 관통: HP 1
- 세 번째 관통: HP 0 / DESTROYED
- 파괴 후 이동 없음
- 파괴 후 추가 피해 없음

## Test V0.1-T05

### Scenario

반복 초기화

### Checks

- R 이후 HP 3
- 이동 재개
- collider 복구
- 파괴 표시 제거
- 반복 reset 누수 없음

## Completion Criteria

- 3회 관통 격파 정상
- 파괴 후 상태 안정
- reset 정상
- V0.1-T04, T05 기록

# Phase V0.1-E — User Validation and Final Stop

## Status

`BLOCKED`

## Dependencies

- V0.1-D 완료
- Windows build 또는 실행 가능한 Godot 프로젝트

## User Checklist

1. 움직이는 표적을 탑다운에서 조준 가능
2. 움직이는 표적을 사선 카메라에서 조준 가능
3. 이동 중 전면·측면·후면 판정이 납득됨
4. 관통에만 HP가 감소
5. 비관통·도탄에는 HP가 유지
6. 세 번 관통하면 명확히 격파
7. 파괴 후 움직임과 추가 피해 중단
8. R 이후 완전 복구
9. 현재 조준 정책의 체감 위험 기록

## Result

V0.1은 별도의 엔진 합격 판정을 다시 하지 않는다.

기록값:

- `V0 RESULT: PASS`
- `V0.1 COMBAT LINK: PASS`
- `V0.1 COMBAT LINK: PASS_WITH_RISK`
- `V0.1 COMBAT LINK: FAIL`

FAIL이어도 V0의 기술 가능성 판정을 자동 취소하지 않는다.

## Mandatory Stop

V0.1 검증 뒤:

- 표적 2대 이상 금지
- 적 공격 금지
- 신규 탄종 금지
- 보스 금지
- Stage 금지
- AI 확장 금지
- polish 금지
- 전체 포팅 금지

## Stop Confirmation

> Phase V0.1의 검증 범위에서 작업을 종료했으며, 움직이는 표적 1대·HP 3·관통 격파를 넘어 보스·Stage·전체 탄종·전투 AI·정식 아트·전체 포팅으로 확장하지 않았다.

## Completion Criteria

- 사용자 직접 검증
- V0.1 결과 기록
- Stop confirmation
- Godot 작업 `STOPPED`
- HTML H5B를 다음 활성 Phase로 기록


# Post-V0.1 — Return to HTML H5B

## Status

`QUEUED`

## Goal

V0와 V0.1 결과만 보존하고 HTML Pilot의 장갑 체감과 방향 계약 작업으로 복귀한다.

## H5B Focus

- AGENTS와 개발 문서를 HTML Pilot 목표에 맞게 정정
- 플레이어 장갑 72/60/32와 적 관통력 관계 측정
- 피격 면·도탄·비관통·관통 피드백 확인
- 문제 원인을 다음으로 분류
  - 피드백
  - 수치
  - 전장 구조

## H5B Prohibitions

- 새 장갑 시스템
- 신규 탄종
- 신규 적
- Stage geometry 대규모 변경
- Godot V0·V0.1 기능 계속 개발
- Godot와 HTML 동시 재설계

## Transition

```text
V0 PASS
        ↓
V0.1 moving target combat check
        ↓
Godot STOPPED
        ↓
HTML H5B ACTIVE
```

# Future G0R — Full Engine Port Re-Baselining

## Status

`SUSPENDED`

## Start Conditions

다음을 모두 충족해야 한다.

- V0 PASS 또는 PASS_WITH_RISK
- HTML Pilot 1.0 규칙 확정
- 대표 Stage 존재
- 대표 보스전 존재
- 정상 플레이 영상 존재
- 기준 commit 존재
- 사용자 본격 포팅 승인

## G0R Purpose

과거 Phase 1~11을 이어서 실행하지 않는다.

최신 HTML 기준으로 다음을 다시 작성한다.

- 게임 규칙
- Stage Director
- 체크포인트
- 정비 구역
- 전투 판정
- 탄종
- 보스
- 일반 적
- 지원 공격
- 불렛타임
- 저장
- export
- 생산 구조

## G0R Prohibitions

- V0 코드를 무검증으로 본편 구조에 확대
- 과거 c99ccd2를 최종 기준으로 강제
- 포팅과 게임성 변경을 동시에 수행
- HTML과 엔진판 규칙을 동시에 재설계
- 과거 G1~G11 자동 재개

# Historical Phase 1~11

## Status

`SUSPENDED`

과거 문서의 다음 단계는 현재 실행하지 않는다.

- Phase 1: 월드·플레이어·카메라·오디오
- Phase 2: 포탄·충돌·장애물
- Phase 3: 장갑·탄종
- Phase 4: 보스·약점
- Phase 5: HE·곡사포
- Phase 6: 일반 적
- Phase 7: 자원·점수
- Phase 8: 악용 방지
- Phase 9: 아군 포격
- Phase 10: 불렛타임
- Phase 11: 정합성·export

이 목록은 역사적 의존 순서 참고일 뿐이다.

현재 Codex 작업 지시가 아니며 V0 합격 뒤에도 실행하지 않는다.

# Completion Report Template

## Summary

- V0에서 확인한 기술
- 확인하지 않은 기능
- Godot 버전
- 실행 방법

## Repository Audit

- branch
- start status
- end status
- existing files
- changed files

## Validation Results

### V0 Results

| Test | Codex | User | Evidence | Notes |
|---|---|---|---|---|
| V0-T01 | | | | |
| V0-T02 | | | | |
| V0-T03 | | | | |
| V0-T04 | | | | |
| V0-T05 | | | | |
| V0-T06 | | | | |
| V0-T07 | | | | |
| V0-T08 | | | | |
| V0-T09 | | | | |
| V0-T10 | | | | |

### V0.1 Results

| Test | Codex | User | Evidence | Notes |
|---|---|---|---|---|
| V0.1-T01 | | | | |
| V0.1-T02 | | | | |
| V0.1-T03 | | | | |
| V0.1-T04 | | | | |
| V0.1-T05 | | | | |

## Final Assessment

- V0 Result: PASS
- V0.1 Combat Link Result:
- Technical reason:
- Productivity reason:
- User validation:
- Windows export:
- Web export:

## Risks

- aiming
- camera switch
- armor separation
- boundary angles
- ricochet visualization
- productivity
- export

## Deferred

- 보스
- Stage
- 전체 탄종
- AI
- 포격
- 불렛타임
- 정식 아트
- 전체 포팅

## Preserved Outputs

- source project
- README
- validation report
- Windows build
- Web build if available
- screenshots/video

## Stop Confirmation

> Phase V0.1의 검증 범위에서 작업을 종료했으며, 움직이는 표적 1대·HP 3·관통 격파를 넘어 보스·Stage·전체 탄종·전투 AI·정식 아트·전체 포팅으로 확장하지 않았다.

## Next Active Phase

`HTML H5B — 방향 계약·장갑 체감 진단`
