# RicochetAngles Godot Migration Phases

## 1. Purpose

이 문서는 HTML/Canvas 2D 프로토타입 `RicochetAngles`를 Godot 4 기반의 로폴리 3D 게임으로 이식하는 순서와 각 단계의 완료 기준을 정의한다.

- 이식은 기능을 한 번에 모두 옮기지 않고 의존성 순서에 따라 단계별로 진행한다.
- 각 Phase는 독립적으로 실행 및 검증 가능한 상태를 목표로 한다.
- 사용자가 명시적으로 승인하기 전에는 다음 Phase 구현을 시작하지 않는다.
- Phase 범위 밖의 기능을 선행 구현하지 않는다.
- 기존 HTML의 게임 로직은 참고 기준이지만, 픽셀 좌표, Canvas 렌더링, 단일 파일 구조는 복제하지 않는다.

## 2. Source Baseline

### Godot 대상 저장소

- Repository: `series341000Lunar/ricochetangles`
- Engine: Godot 4.7
- Language: GDScript
- Renderer: Compatibility
- Space: 3D
- Camera: Orthographic Camera3D

### HTML 기준 저장소

- Repository: `series341000Lunar/steel-angle-prototype`
- Baseline commit: `c99ccd2b6628f1560e2340899f2f0715675570d6`
- Commit message: `Add synthesized audio feedback and GAS healing`

### Reference Roles

- HTML 코드: 정확한 로직, 상태, 수치, 예외 규칙
- HTML AGENTS.md: 보존해야 할 계약
- 정상 플레이 영상: 조작감, 속도감, 경고, 연출, UI 가독성
- Godot AGENTS.md: 이식 프로젝트의 개발 계약
- 이 문서: 구현 순서와 완료 기준

## 3. Global Migration Principles

- 3D 렌더링과 3D 물리 공간을 사용한다.
- 초기 게임플레이는 XZ 지상 평면 중심으로 제한할 수 있다.
- Y축은 높이와 향후 공중 유닛에 사용한다.
- 1 Godot unit은 1m로 취급한다.
- 장갑과 관통력은 mm 단위다.
- 전차 이동은 CharacterBody3D 계열의 스크립트 제어를 기본으로 한다.
- 실제 무한궤도 물리를 구현하지 않는다.
- 렌더 메시, 이동용 콜라이더, 장갑 구역 콜라이더를 분리한다.
- 빠른 포탄은 프레임 간 3D sweep 또는 ray/shape query를 사용한다.
- 관통, 비관통, 도탄은 별도 계산 계층에서 처리한다.
- 실제 판정과 불렛타임 예측은 같은 함수를 공유한다.
- 월드 크기, 카메라 각도, 전차 크기, 속도는 Phase 1에서 잠정값을 정하고 조정 가능하게 둔다.
- 각 Phase에서 디버그 가능성을 함께 구현한다.
- 완료하지 않은 기능을 구현 완료로 표시하지 않는다.

## 4. Phase Status Values

- `COMPLETED`: 문서, 코드, 검증, 사용자 확인이 완료됨
- `IN_PROGRESS`: 현재 작업 중
- `PARTIAL`: 일부 구현되었으나 완료 조건 미충족
- `PLANNED`: 아직 시작하지 않음
- `BLOCKED`: 선행 조건 또는 사용자 결정이 필요함
- `UNVERIFIED`: 구현은 있으나 실행 확인이 부족함

## 5. Current Phase Summary

| Phase | Name | Status |
|---|---|---|
| 0 | 이식 계약과 구조 기준 | COMPLETED |
| 1 | 3D 월드·플레이어·카메라·오디오 기반 | PLANNED |
| 2 | 포탄·3D 충돌·장애물 | PLANNED |
| 3 | 장갑·도탄·비관통·관통·APHE/APCR | PLANNED |
| 4 | 보스·궤도·약점·폭주 | PLANNED |
| 5 | HE·폭발·적 곡사포 | PLANNED |
| 6 | 경전차·보병·대전차포·기관총·리스폰 | PLANNED |
| 7 | 아이템·GAS·SCORE·XP | PLANNED |
| 8 | 보스 악용 방지와 고급 대응 | PLANNED |
| 9 | 아군 곡사포 | PLANNED |
| 10 | 불렛타임 | PLANNED |
| 11 | 정합성·성능·내보내기 | PLANNED |

---

# Phase 0 — 이식 계약과 구조 기준

## Status

`COMPLETED`

## Goal

Godot 이식의 기술 방향, 단위, 좌표, 충돌 책임, 시간 체계, 기준 자료, 단계 순서를 확정한다.

## Confirmed Decisions

- 3D 프로젝트 기반
- 로폴리 3D 렌더링
- Compatibility renderer
- GDScript
- 직교 Camera3D
- XZ 지상 이동
- Y축 높이
- 1 unit = 1m
- 장갑과 관통력은 mm
- CharacterBody3D 계열 전차
- 실제 무한궤도 물리 제외
- 렌더 메시와 콜라이더 분리
- 이동용 콜라이더와 장갑 구역 콜라이더 분리
- 빠른 포탄의 3D sweep
- 커스텀 장갑 계산
- 월드 크기와 카메라 수치는 잠정적
- 다중 delta 시간 체계
- HTML 기준 커밋 c99ccd2
- MCP와 외부 플러그인 미사용

## Deliverables

- `AGENTS.md`
- `MIGRATION_PHASES.md`

## Out of Scope

- Godot 게임 코드
- 메인 씬
- 플레이어 이동
- 실제 콜라이더
- 실제 카메라
- 전투 시스템

## Completion Criteria

- 사용자와 GPT의 결정이 문서에 반영됨
- HTML 기준과 Godot 목표의 차이가 명시됨
- Phase 1 이후 순서가 정의됨
- 사용자 승인 완료

---

# Phase 1 — 3D 월드·플레이어·카메라·오디오 기반

## Status

`PLANNED`

## Goal

로폴리 3D 이식의 최소 실행 기반을 만들고 플레이어 전차의 이동 감각, 포탑 조준, 직교 카메라, 기본 사운드 상태를 검증한다.

## In Scope

### Project Foundation

- 메인 3D 씬
- 3D 월드 루트
- 테스트용 평면 지형
- 잠정 월드 경계
- 기본 조명
- 임시 로폴리 또는 primitive 전차 비주얼
- 화면 UI 계층
- R 재시작 기반
- 기본 디버그 표시

### Player Tank

- CharacterBody3D 기반
- 단순 이동용 CollisionShape3D
- 차체 VisualRoot
- 독립 TurretPivot
- W/S 전진 및 후진
- A/D 차체 선회
- 가속
- 자연 감속
- 역방향 제동
- 후진 중 선회 방향
- 충돌 시 속도 감소
- 실제 위치 변화 기반 actual velocity

### Camera

- Orthographic Camera3D
- 기울어진 탑다운 시점
- 플레이어 XZ 추적
- 월드 경계 clamp
- look-ahead 없음
- 화면 마우스에서 지면 조준점 산출
- 포탑이 월드 조준점을 바라봄
- 카메라 이동 중 조준 정합성

### Audio Foundation

- 기본 오디오 버스
- M 음소거
- 음소거 상태의 매치 재시작 독립성
- 임시 이동 또는 UI 사운드
- 향후 3D 위치 음향을 위한 기본 구조

### Initial Tuning Decisions

Phase 1 플레이테스트에서 다음 잠정값을 정한다.

- 플레이어 전차 크기
- 이동 속도
- 가속 및 감속 시간
- 선회 속도
- 초기 월드 크기
- 카메라 pitch
- 카메라 yaw
- orthogonal size
- 카메라 추적 감도

## Out of Scope

- 주포 발사
- 포탄
- 장갑
- 보스
- 일반 적
- 아이템
- 곡사포
- 불렛타임
- 실제 최종 모델
- 실제 궤도 물리
- 공중 유닛

## Required Debug Information

- 플레이어 위치 Vector3
- 차체 yaw
- 포탑 yaw
- 현재 전진 속도
- 실제 속도
- 카메라 위치
- orthogonal size
- 마우스 조준점
- 현재 match state
- 현재 time mode

## Manual Tests

1. W로 전진한다.
2. S로 후진한다.
3. 전진 중 S 입력으로 제동한다.
4. 후진 중 선회 방향이 HTML 감각과 맞는지 확인한다.
5. 입력을 놓으면 관성 후 정지한다.
6. 월드 경계를 통과하지 않는다.
7. 장애물 또는 벽과 충돌했을 때 속도가 감소한다.
8. 차체 회전 중 포탑은 마우스 조준점을 유지한다.
9. 카메라가 움직여도 조준점이 틀어지지 않는다.
10. HUD가 카메라와 함께 이동하지 않는다.
11. M 음소거가 작동한다.
12. R 재시작 후 음소거 상태가 유지된다.
13. 프레임레이트 변화로 이동 속도가 크게 달라지지 않는다.

## Completion Criteria

- 플레이어 전차가 3D 월드에서 정상 이동
- 차체와 포탑 독립
- 직교 카메라와 마우스 조준 정상
- 월드 경계 정상
- 기본 오디오와 M 음소거 정상
- R 재시작 정상
- 반복 Godot 오류 없음
- 사용자 조작감 확인 완료

---

# Phase 2 — 포탄·3D 충돌·장애물

## Status

`PLANNED`

## Goal

빠른 포탄의 연속 충돌, 장애물 차단, 최초 충돌 선택, 발사 및 소멸의 공통 기반을 만든다.

## Dependencies

- Phase 1 완료

## In Scope

### Projectile Foundation

- 플레이어 주포의 임시 발사
- 포탄 ID
- 발사자
- 진영
- 무기 종류
- 탄종 메타데이터
- 포구 위치
- 속도
- 수명
- 이전 위치
- 현재 예정 위치
- 3D ray 또는 small shape sweep
- 최초 충돌 선택
- 월드 경계 이탈
- 발사체 제거

### Obstacles

- 단순 3D 장애물
- 이동 충돌
- 포탄 차단
- HP
- 파괴
- 파괴 후 통과
- 임시 파괴 효과
- 장애물 배치와 월드 경계

### Basic Damage Target

- 장갑이 없는 테스트 표적
- HP
- 피격
- 사망
- 중복 충돌 방지

### Effects and Audio

- 발사 임시 효과
- 충돌 임시 효과
- 장애물 파괴 임시 효과
- 발사 및 충돌 사운드

## Out of Scope

- 장갑 계산
- 도탄
- 비관통
- 탄종 차이
- 보스 약점
- SCORE와 XP
- HE 범위 피해
- 일반 적 AI

## Required Debug Information

- projectile ID
- source ID
- faction
- previous position
- current position
- sweep length
- first hit target
- hit position
- hit normal
- hit distance 또는 fraction
- obstacle HP

## Manual Tests

1. 고속 포탄이 얇은 장애물을 통과하지 않는다.
2. 장애물 뒤의 표적은 피해를 받지 않는다.
3. 복수 충돌 후보 중 가장 가까운 대상만 맞는다.
4. 같은 포탄이 한 프레임에 여러 피해를 주지 않는다.
5. 월드 밖 포탄이 제거된다.
6. 수명이 끝난 포탄이 제거된다.
7. 장애물 HP가 0이 되면 파괴된다.
8. 파괴된 장애물은 이동과 포탄을 더 이상 막지 않는다.
9. R 재시작 후 포탄과 장애물 상태가 초기화된다.

## Completion Criteria

- 3D sweep 기반 최초 충돌 정상
- 장애물 차단과 파괴 정상
- 포탄 생명주기 정상
- 디버그로 충돌 결과 확인 가능
- Phase 1 회귀 없음
- 사용자 확인 완료

---

# Phase 3 — 장갑·도탄·비관통·관통·APHE/APCR

## Status

`PLANNED`

## Goal

3D 충돌 노멀과 명시적인 장갑 구역을 기반으로 관통, 비관통, 자동 도탄과 APHE/APCR 역할을 구현한다.

## Dependencies

- Phase 2 완료

## In Scope

### Armor Zones

- 플레이어 또는 테스트 전차의 전면, 측면, 후면
- 차체와 포탑 구역
- 단순화된 3D 장갑 콜라이더
- zone ID
- armor mm
- hit normal
- debug visualization

### Penetration Calculation

- 포탄 진행 방향
- 표면 노멀
- 입사각
- 0도 수직, 90도 스침
- 75도 자동 도탄
- 유효 장갑
- 현재 관통력
- 거리별 관통력 감소
- 관통
- 비관통
- 도탄
- reason code

### Ricochet

- 속도 반사
- 속도 감소
- 충돌면 바깥 재배치
- 최대 도탄 횟수
- 동일 표면 즉시 재충돌 방지
- 도탄 후 다른 대상 명중 가능

### APHE

- 무한 탄약
- 기본 속도와 관통
- 기존 장갑 규칙

### APCR

- 제한 탄약
- 초기 1발
- 탄속 배율
- 75도 이상 자동 도탄
- 75도 미만 강제 관통
- 발사 성공 후 탄약 감소
- 발사 실패 시 탄약 미감소

### Basic HUD

- 선택 탄종
- 남은 탄약
- 최근 장갑 결과

## Out of Scope

- SCORE
- XP
- 불렛타임
- 보스 약점
- HE
- 일반 적

## Required Debug Information

- armor zone
- armor mm
- impact angle
- effective armor
- current penetration
- result
- reason
- reflected velocity
- ricochet count
- ammo type

## Manual Tests

1. 전면, 측면, 후면 장갑값이 다르게 적용된다.
2. 75도 이상 명중은 자동 도탄한다.
3. 75도 미만 APCR은 강제 관통한다.
4. APHE는 유효 장갑과 관통력 비교를 사용한다.
5. 비관통 시 HP가 감소하지 않는다.
6. 도탄 후 포탄이 반사된다.
7. 도탄 포탄이 같은 표면에 즉시 재충돌하지 않는다.
8. 최대 도탄 횟수가 적용된다.
9. 도탄 후 다른 표적을 맞출 수 있다.
10. APCR 발사 성공 시에만 탄약이 감소한다.
11. 실제 계산과 debug 표시가 일치한다.
12. R 재시작 후 탄약과 포탄 상태가 초기화된다.

## Completion Criteria

- 3D 장갑 구역 정상
- 관통, 비관통, 도탄 정상
- APHE와 APCR 역할 정상
- 계산 함수가 예측에 재사용 가능
- Phase 1~2 회귀 없음
- 사용자 확인 완료

---

# Phase 4 — 보스·궤도·약점·폭주

## Status

`PLANNED`

## Goal

보스의 기본 전투, 좌우 궤도, 비치명 약점, 엔진 노출, HP 감소, 폭주 루프를 구현한다.

## Dependencies

- Phase 3 완료

## In Scope

### Boss Base

- 보스 3D 전차
- 단순 이동 콜라이더
- 장갑 구역
- 차체 및 포탑
- 플레이어 접근
- 포탑 조준
- 주포 경고
- 주포 발사
- 재장전
- 기본 이동과 선회

### Tracks

- 좌우 궤도 별도 모듈
- HP 2
- 파괴
- 이동과 선회 성능 감소
- 양쪽 파괴 상태
- 10초 복구
- 폭주 중 5초 복구
- 시각적 파괴 표시

### Weakpoint Loop

- cupola
- gun port
- vision slit
- engine
- trigger 약점 하나만 활성
- trigger 관통 시 엔진 노출
- HP 감소 없음
- 엔진 노출 최대 10초
- 초기 stagger
- 엔진 관통 시 HP -1
- 제한시간 종료 시 다음 약점
- 같은 프레임 엔진 관통 우선
- 약점 bag 또는 동등한 반복 방지

### Boss HP and Rage

- 보스 HP 10
- HP 5 이하 최초 폭주
- 폭주 1회
- 이동 증가
- 선회 증가
- 재장전 단축
- 궤도 복구 단축
- trigger 약점 자동 변경

### Match End

- 보스 HP 0 승리
- 보스 사망 연출
- 공격 중단
- 재시작

## Out of Scope

- 보스 기관총
- 보스 곡사포
- 연막
- anti-orbit
- 일반 적
- SCORE
- 불렛타임

## Required Debug Information

- boss state
- HP
- rage
- left/right track HP
- repair timer
- active weakpoint
- weakpoint state
- engine timer
- stagger timer
- boss move/turn multiplier
- main gun attack state

## Manual Tests

1. trigger 약점 관통은 HP를 감소시키지 않는다.
2. trigger 약점 관통 후 엔진이 노출된다.
3. 엔진 관통은 HP를 정확히 1 감소시킨다.
4. 엔진 제한시간 종료 후 다음 약점으로 돌아간다.
5. 같은 프레임 관통과 타임아웃이 겹치면 관통이 우선한다.
6. 비활성 약점 관통은 본체 HP를 감소시키지 않는다.
7. 일반 장갑 관통은 본체 HP를 감소시키지 않는다.
8. 좌우 궤도가 별도로 파괴된다.
9. 궤도 파괴 상태에서 이동 및 선회가 감소한다.
10. 궤도가 정상 시간에 복구된다.
11. HP 5에서 폭주가 한 번만 발동한다.
12. HP 0에서 승리하고 신규 공격이 중단된다.
13. R 재시작 후 약점 bag, HP, 폭주, 궤도가 초기화된다.

## Completion Criteria

- 보스 핵심 공략 루프 정상
- 궤도와 복구 정상
- 폭주 전환 정상
- 승리와 재시작 정상
- Phase 1~3 회귀 없음
- 사용자 확인 완료

---

# Phase 5 — HE·폭발·적 곡사포

## Status

`PLANNED`

## Goal

공통 HE 폭발과 지연 착탄 시스템을 만들고 플레이어 HE 및 보스 곡사포를 구현한다.

## Dependencies

- Phase 4 완료

## In Scope

### HE Ammo

- 제한 탄약
- 초기 1발
- 장갑 및 도탄 계산 제외
- 최초 충돌 시 폭발
- 수명 종료 시 폭발
- 월드 경계 처리 시 한 번만 폭발
- he_detonated 중복 방지
- 폭발 반경
- 직접 충돌 대상
- 장애물 피해
- 보병 및 대전차포용 인터페이스

### Boss Interaction

- 궤도 폭발 피해
- 활성 약점 폭발 판정
- 폭발 시작 시 약점 snapshot
- trigger와 engine 연속 처리 방지
- 기본적으로 경전차 본체 피해 제외

### Common Artillery Foundation

- 목표 중심
- 산포점 생성
- 최소 포인트 간격
- 착탄 마커
- 착탄 지연
- 폭발
- owner faction
- source ID
- barrage ID
- 피해 대상 필터

### Boss Artillery

- 기본 5발
- 예측 중심
- 이동 속도 평활값 참고
- 착탄 3초
- 일반 및 폭주 쿨다운
- 플레이어 폭발 거리 감쇠 피해
- 보스 사망 후 중단

## Out of Scope

- 아군 Q 포격
- 일반 적
- 아이템 드롭
- 불렛타임
- anti-orbit
- 근접 연막

## Required Debug Information

- HE explosion ID
- explosion position
- radius
- snapshot weakpoint state
- snapshot weakpoint name
- tracks hit
- active weakpoint hit
- artillery barrage ID
- marker remaining time
- predicted center
- player damage

## Manual Tests

1. HE는 장갑 계산과 도탄을 실행하지 않는다.
2. HE는 한 번만 폭발한다.
3. 최초 충돌에서 폭발한다.
4. 수명 종료 및 경계 처리에서도 중복 폭발하지 않는다.
5. 폭발이 좌우 궤도에 적용된다.
6. trigger 약점 상태 snapshot이 유지된다.
7. 한 폭발이 trigger와 engine을 연속 처리하지 않는다.
8. 곡사포 마커가 지정 시간 후 폭발한다.
9. 플레이어는 반경에 따라 곡사포 피해를 받는다.
10. 보스 사망 후 남은 곡사포 공격이 중단된다.
11. R 재시작 후 HE, 폭발, 마커가 초기화된다.

## Completion Criteria

- HE 공통 폭발 정상
- 약점 snapshot 정상
- 보스 곡사포 정상
- 중복 폭발 없음
- Phase 1~4 회귀 없음
- 사용자 확인 완료

---

# Phase 6 — 경전차·보병·대전차포·기관총·리스폰

## Status

`PLANNED`

## Goal

일반 적의 생성, 탐지, 공격, 사망, 리스폰과 플레이어 기관총 및 제압 시스템을 구현한다.

## Dependencies

- Phase 5 완료

## In Scope

### Common Enemy Foundation

- faction
- ID
- alive/dead state
- HP
- detection
- line of sight
- attack state
- source identity
- friendly fire context
- death context
- spawn slot
- respawn timer
- blocked spawn retry

### Light Tank

- HP 2
- 3D 이동과 회전
- 보스 주변 합류
- 탐지 전 escort
- 탐지 후 지속 추격
- 주포 aim, warning, reload
- 장갑 전면, 측면, 후면
- suppression state
- periodic 최대 1대
- 30초 생성 주기
- 파괴 연출

### Anti-Tank Gun

- 고정 슬롯 4기
- HP 2
- 탐지
- 시야
- 포탑 회전
- aim
- warning
- reload
- 주포 공격
- 파괴 후 30초 리스폰
- spawn blocked 짧은 재시도

### Infantry

- 고정 분대 4개
- 분대당 5명
- 병사 HP
- 탐지
- 시야
- warning
- burst
- 제압
- 분대 전멸
- 30초 리스폰
- spawn blocked 짧은 재시도

### Player Machine Gun

- 우클릭 burst
- 10발
- 주포 최종 산포 공유
- 같은 ray를 시각선과 판정에 사용
- 보병 피해
- 대전차포 피해
- 경전차 3발 이상 실제 명중 시 제압
- cooldown

### Enemy Friendly Fire

- 적 주포와 기관총의 일반 적 및 장애물 최초 충돌
- 보스는 물리적으로 막지만 피해 면역
- 적군 경전차 제압 가능
- 사망 원인 context

### Match End

- 승패 후 AI 공격 중단
- 생성 중단
- 리스폰 중단

## Out of Scope

- 아이템 드롭
- SCORE와 XP
- anti-orbit 생성
- 보스 연막
- 아군 곡사포
- 불렛타임

## Required Debug Information

- enemy ID
- enemy type
- state
- attack state
- distance
- LOS
- HP
- suppression
- slot
- respawn timer
- retry timer
- first hit target
- friendly fire context
- player MG burst hit map

## Manual Tests

1. 경전차가 보스 주변으로 이동한다.
2. 경전차가 탐지 후 플레이어를 계속 추격한다.
3. 경전차가 장애물과 다른 전차를 통과하지 않는다.
4. 대전차포가 LOS가 있을 때만 공격한다.
5. 보병 burst 실제 명중 수로 제압이 적용된다.
6. 보병과 보스 MG는 플레이어 HP를 직접 감소시키지 않는다.
7. 플레이어 기관총이 보병과 대전차포에 피해를 준다.
8. 플레이어 기관총 3발 이상 명중 시 경전차가 제압된다.
9. 적 주포가 장애물 뒤 목표를 맞히지 않는다.
10. 적 주포가 일반 적을 오사할 수 있다.
11. 보스는 적 오사 피해를 받지 않는다.
12. 파괴된 고정 적이 30초 뒤 리스폰한다.
13. 스폰 지점이 막히면 짧게 재시도한다.
14. 승패 후 생성과 공격이 중단된다.
15. R 재시작 후 슬롯과 타이머가 초기화된다.

## Completion Criteria

- 세 일반 적 유형 정상
- AI 상태 정상
- 플레이어 기관총 정상
- 제압 정상
- 오사와 보스 면역 정상
- 리스폰 정상
- Phase 1~5 회귀 없음
- 사용자 확인 완료

---

# Phase 7 — 아이템·GAS·SCORE·XP

## Status

`PLANNED`

## Goal

적 사망과 연결되는 아이템, 탄약, GAS, SCORE, XP, 보상 중복 방지를 구현한다.

## Dependencies

- Phase 6 완료

## In Scope

### Pickups

- APCR
- HE
- GAS
- 월드 좌표
- 단순 3D 시각 표현
- 수집 범위
- 같은 종류 근접 병합
- quantity
- 장애물 내부 위치 보정
- 시간 소멸 없음

### Drops

- 대전차포 APCR 1개
- 보병 분대 HE 1개
- 경전차 50% 드롭
- APCR/HE/GAS 40/40/20 가중치
- 생명주기당 1회 판정

### GAS

- player resource
- `5`, `Digit5`, `Numpad5`
- 1개 소비
- HP 최대 1 회복
- GAS 없음
- HP 최대
- 성공 및 실패 피드백

### SCORE

- 일반 적 유형별 점수
- 보스 점수
- 방어 도탄 SCORE
- bank shot SCORE
- 생명주기당 1회
- 포탄당 1회

### XP

- 비관통 방어
- 도탄 방어
- 적 아군 오사
- SCORE와 분리
- 중복 지급 방지

### HUD and End Screen

- SCORE
- XP
- APCR
- HE
- GAS
- 최종 점수

## Out of Scope

- 영구 저장
- 상점
- 자동 교환
- 스킬 구매
- 스테이지 진행

## Required Debug Information

- pickup ID
- type
- quantity
- source
- drop roll
- merge result
- collect result
- GAS use result
- score event
- XP event
- duplicate reward flags
- death context

## Manual Tests

1. 대전차포가 APCR을 드롭한다.
2. 보병 분대가 HE를 드롭한다.
3. 경전차가 50% 확률로 한 번만 드롭을 판정한다.
4. 같은 pickup이 가까우면 병합된다.
5. 장애물 내부 pickup이 보정된다.
6. 수집 시 탄약 또는 GAS가 증가한다.
7. GAS가 없으면 소비되지 않는다.
8. HP 최대면 GAS가 소비되지 않는다.
9. GAS 성공 시 1개 감소하고 HP가 최대 1 증가한다.
10. 적 파괴 SCORE가 한 번만 지급된다.
11. 적 오사 XP가 한 번만 지급된다.
12. 도탄과 비관통 방어 보상이 중복되지 않는다.
13. bank shot SCORE가 포탄당 한 번만 지급된다.
14. R 재시작 후 매치 자원이 초기화된다.
15. M 음소거 상태는 유지된다.

## Completion Criteria

- pickup과 drop 정상
- GAS 정상
- SCORE와 XP 정상
- 중복 보상 없음
- 영구 저장 없음
- Phase 1~6 회귀 없음
- 사용자 확인 완료

---

# Phase 8 — 보스 악용 방지와 고급 대응

## Status

`PLANNED`

## Goal

플레이어가 보스를 지나치게 쉽게 무력화하는 장거리 정지 저격, 반복 선회, 근접 접근, 화면 이탈을 대응하는 시스템을 구현한다.

## Dependencies

- Phase 7 완료

## In Scope

### Anti-Snipe Pressure

- 플레이어-보스 거리
- 실제 플레이어 속도
- 장거리 비율
- 저속 비율
- 보스 기관총 cooldown drain
- 장거리 정지 상태 dwell
- cooldown clamp
- 거리 및 속도 hysteresis

### Boss Machine Gun

- warning
- burst 10발
- 실제 ray hit
- 플레이어 속도 기반 산포
- 플레이어 HP 직접 피해 없음
- 3발 이상 실제 명중 시 제압
- 적 경전차 오사 제압
- 주포와 발사 간격
- 엔진 노출 cooldown 배율
- 폭주 cooldown 범위

### Smoke Defense

- 근접 거리
- cooldown
- 2초 예고
- cloud
- 범위
- 플레이어 산포 45도 override
- debuff 시간
- 폭주 및 MG와 같은 프레임 우선순위

### Long-Range and Offscreen Artillery

- 장거리 진입 및 해제 거리
- cooldown 단축
- 보스 완전 화면 이탈 판정
- 짧은 confirm 시간
- 카메라와 bounding volume 기준

### Anti-Orbit

- 보스-플레이어 상대속도
- 접선 성분
- 방사 성분
- 누적 각도
- 방향 반전
- idle reset
- 3회전
- 경고
- interceptor 2슬롯
- 독립 5초 리스폰
- spawn retry

## Out of Scope

- 아군 곡사포
- 불렛타임
- 신규 적 유형
- 새로운 보스 무기

## Required Debug Information

- anti-snipe distance
- player speed ratio
- pressure
- MG drain rate
- stationary dwell
- smoke state
- smoke timers
- offscreen state
- orbit angle
- orbit delta
- tangential speed
- radial speed
- accumulated turns
- warning
- interceptor slots

## Manual Tests

1. 장거리 정지 플레이 시 MG 압력이 증가한다.
2. 이동하거나 거리를 좁히면 상태가 정상 해제된다.
3. MG 3발 이상 실제 명중 시 제압된다.
4. MG는 장애물과 일반 적에 차단된다.
5. 보스는 아군 MG에 피해를 받지 않는다.
6. 근접 시 연막이 2초 예고 후 발동한다.
7. 연막 중 최종 산포는 45도 override다.
8. 장거리 모드에서 곡사포 쿨다운이 단축된다.
9. 보스가 완전히 화면 밖일 때 대응 상태가 정확하다.
10. 유효한 반복 선회 3회 후 경고가 뜬다.
11. 경고 후 interceptor 2대가 생성된다.
12. 각 interceptor 슬롯이 독립적으로 리스폰한다.
13. 승패 후 모든 대응 생성이 중단된다.
14. R 재시작 후 anti-orbit 누적값이 초기화된다.

## Completion Criteria

- 장거리, 근거리, 반복 선회 대응 정상
- 보스 공격 우선순위 정상
- interceptor 슬롯 정상
- Phase 1~7 회귀 없음
- 사용자 확인 완료

---

# Phase 9 — 아군 곡사포

## Status

`PLANNED`

## Goal

Phase 5의 공통 곡사포 및 HE 시스템을 재사용해 플레이어의 Q 아군 포격 스킬을 구현한다.

## Dependencies

- Phase 8 완료
- Phase 5 공통 곡사포 기반

## In Scope

### Skill Targeting

- Q 진입
- NORMAL에서만 진입
- 게임 감속 없음
- W/S/A/D 조작 잠금
- 플레이어 신규 발사 잠금
- 기존 관성 자연 감속
- 마우스 월드 목표
- 5초 제한
- 좌클릭 확정
- 우클릭, Esc, Q 취소
- 목표 범위 표시
- 예측 산포점 표시

### Friendly Barrage

- 5발
- 공통 marker
- 공통 착탄 시간
- player faction
- barrage ID
- 플레이어 피해 없음
- 일반 적, 장애물, 보스 상호작용
- barrage당 보스 trigger 1회
- barrage당 보스 HP 피해 1회
- active shell count
- cooldown 60초

### State Integration

- BULLET_TIME과 상호 배타
- 승패 후 취소
- R reset
- 남은 barrage 정리

## Out of Scope

- 스킬 업그레이드
- 포격 탄종 선택
- 영구 스킬 저장
- 신규 아군 전차 AI

## Required Debug Information

- time mode
- skill cooldown
- targeting remaining
- target world position
- preview points
- barrage ID
- trigger applied
- HP damage applied
- active shell count

## Manual Tests

1. Q로 조준 모드에 진입한다.
2. 조준 중 게임이 감속하지 않는다.
3. 조작과 발사가 잠긴다.
4. 기존 관성은 자연 감속한다.
5. 좌클릭으로 확정한다.
6. 우클릭, Esc, Q로 취소한다.
7. 5초가 지나면 취소된다.
8. 5발이 지정된 산포로 착탄한다.
9. 플레이어는 아군 포격 피해를 받지 않는다.
10. 한 barrage가 trigger와 엔진을 여러 번 처리하지 않는다.
11. cooldown이 적용된다.
12. 승패와 R에서 조준 및 barrage 상태가 정리된다.

## Completion Criteria

- Q 조준 모드 정상
- 아군 barrage 정상
- 보스 처리 제한 정상
- 상태 모드 충돌 없음
- Phase 1~8 회귀 없음
- 사용자 확인 완료

---

# Phase 10 — 불렛타임

## Status

`PLANNED`

## Goal

적 주포탄의 실제 위협을 예측하고, 플레이어가 방어 기동으로 도탄을 유도할 수 있는 불렛타임을 구현한다.

## Dependencies

- Phase 9 완료
- 실제 장갑 판정 안정화
- 모든 주요 충돌 대상 안정화
- 다중 delta 시간 구조 존재

## In Scope

### Threat Detection

- 적 main cannon만 대상
- 5개 기동 표본
- current motion
- coast
- brake
- left
- right
- 예측 horizon
- fixed prediction step
- 플레이어 예상 이동
- 포탄 예상 이동
- 장애물
- 플레이어
- 보스
- 일반 적
- 월드 경계
- 최초 충돌
- 장갑 결과
- hit probability
- time to impact

### Prompt

- probability threshold
- 현재 기동 표본이 플레이어를 맞히는 경우
- 최소 및 최대 time to impact
- 짧은 prompt hold
- PRESS Z
- 예상 결과 표시

### Bullet Time Mode

- 실시간 2초
- simulation scale
- player movement scale
- player turn scale
- 포탑 조준 허용
- W/S/A/D 허용
- 플레이어 발사 금지
- Q 진입 금지
- 궤적 표시
- 예상 충돌점
- 도탄 경로 표시

### Tracked Projectile

- projectile ID
- 불렛타임 종료 후에도 실제 최초 충돌 결과 추적
- 실제 플레이어 장갑 자동 도탄 반사만 성공
- 비관통, 관통, miss, 만료, 장애물, 다른 적 충돌은 실패
- 성공 cooldown 5초
- 기타 cooldown 30초
- 예측과 실제 결과 비교

### State and Reset

- SKILL_TARGETING과 상호 배타
- 승패 중단
- R reset
- 추적 ID 정리
- cooldown reason
- 중복 성공 방지

## Out of Scope

- 공격형 불렛타임
- 다중 추적 포탄
- 시간 되감기
- 영구 업그레이드

## Required Debug Information

- real/sim/move/turn delta
- primary threat ID
- probability
- time to impact
- 5개 sample 결과
- first hit type
- armor zone
- predicted angle
- predicted armor
- predicted effective armor
- predicted penetration
- predicted result
- predicted reason
- can reflect
- tracked projectile ID
- tracked outcome
- cooldown reason
- prediction/actual comparison

## Manual Tests

1. 실제로 맞을 가능성이 높은 적 주포탄에만 prompt가 표시된다.
2. 장애물에 먼저 막히는 포탄은 위협으로 표시되지 않는다.
3. 다른 적에 먼저 맞는 포탄은 위협으로 표시되지 않는다.
4. 5개 기동 표본 확률이 정상 계산된다.
5. Z로 불렛타임이 2초간 발동한다.
6. 적과 포탄이 느려진다.
7. 플레이어 이동과 선회가 별도 배율을 사용한다.
8. 포탑 조준이 유지된다.
9. 발사와 Q 진입이 차단된다.
10. current motion 궤적이 표시된다.
11. 실제 자동 도탄 반사만 성공으로 처리된다.
12. 비관통은 성공으로 처리되지 않는다.
13. 성공 cooldown은 5초다.
14. 실패 cooldown은 30초다.
15. 불렛타임 종료 뒤 살아 있는 tracked projectile 결과를 계속 추적한다.
16. 다른 포탄 결과와 혼동하지 않는다.
17. 예측과 실제 장갑 판정이 같은 함수를 사용한다.
18. 승패와 R에서 모든 상태가 정리된다.

## Completion Criteria

- 위협 탐지 정상
- 다중 delta 감속 정상
- 추적 포탄 결과 정상
- 성공 및 실패 cooldown 정상
- 예측과 실제 정합성 정상
- Phase 1~9 회귀 없음
- 사용자 확인 완료

---

# Phase 11 — 정합성·성능·내보내기

## Status

`PLANNED`

## Goal

Godot 버전이 기준 HTML의 핵심 게임성을 유지하는지 검증하고 Windows 및 Web 내보내기, 성능, 장시간 안정성을 확인한다.

## Dependencies

- Phase 10 완료

## In Scope

### Gameplay Parity

- 기준 플레이 영상 비교
- 플레이어 이동 감각
- 전차와 보스 상대 크기
- 카메라 시야
- 주포 경고
- 도탄 가독성
- 약점 루프
- 보스 폭주
- 곡사포 경고
- 적 역할
- 불렛타임 체감
- 승패 및 재시작

### Regression Matrix

- 이동
- 카메라
- 조준
- 포탄
- 최초 충돌
- 장애물
- 장갑
- 탄종
- 약점
- 궤도
- 일반 적
- 오사
- 아이템
- SCORE
- XP
- 곡사포
- anti-orbit
- 불렛타임
- 리셋
- 음소거

### Performance

- 60fps 목표 환경
- 낮은 프레임레이트
- delta clamp
- 포탄 다수
- 파티클 다수
- 적 리스폰 반복
- 장시간 실행
- 메모리 및 노드 누수
- 오디오 voice 누적

### Export

- Windows Desktop
- Web
- Compatibility renderer 확인
- 입력
- 해상도
- 화면비
- 직교 카메라
- 사운드
- 저장 경로
- Web 제한 사항 보고

### Cleanup

- 반복 오류 제거
- 누락 리소스 제거
- 임시 테스트 파일 정리
- debug 표시 on/off
- 문서 상태 갱신
- 알려진 한계 정리

## Out of Scope

- 신규 콘텐츠
- 그래픽 전면 교체
- 상점과 영구 저장
- 온라인 기능
- 엔진 전환
- 대규모 리팩터링

## Manual Tests

1. Windows 빌드가 실행된다.
2. Web 빌드가 실행된다.
3. 입력이 동일하게 작동한다.
4. 카메라와 마우스 조준이 해상도 변화에도 유지된다.
5. 장시간 플레이에서 반복 오류가 없다.
6. R 재시작을 반복해도 상태가 누적되지 않는다.
7. 승패 후 공격과 생성이 남지 않는다.
8. 포탄 및 파티클 노드가 누수되지 않는다.
9. 오디오가 과도하게 중첩되지 않는다.
10. 저프레임에서 포탄 터널링이 발생하지 않는다.
11. HTML 기준 영상과 핵심 게임 감각을 비교한다.
12. 미검증 차이를 문서에 기록한다.

## Completion Criteria

- 핵심 게임성 정합성 확인
- Windows 내보내기 확인
- Web 내보내기 확인 또는 제한 사유 문서화
- 장시간 반복 오류 없음
- 치명적 누수 없음
- 회귀 매트릭스 완료
- 문서와 실제 구현 상태 일치
- 사용자 최종 확인 완료

---

# 6. Phase Transition Rules

각 Phase 종료 시 다음 형식으로 보고한다.

## Implemented

- 실제 구현된 기능

## Preserved

- 이전 Phase에서 유지된 기능

## Files and Scenes

- 수정한 파일과 씬
- 새로 추가한 책임

## Validation

- 실행한 자동 또는 명령행 검사
- 수행한 수동 테스트
- 통과 결과

## Unverified

- 실행하지 못한 검사
- 사용자 확인이 필요한 항목

## Known Issues

- 남은 오류
- 다음 Phase로 넘긴 항목

## Git Status

- commit 여부
- push 여부
- 작업 트리 상태

사용자가 결과를 확인하고 다음 Phase를 승인한 후에만 진행한다.

# 7. Change Control

- Phase 순서는 의존성 문제가 확인되면 사용자 승인 후 수정할 수 있다.
- 기능을 삭제하거나 다른 Phase로 이동할 때 이유를 기록한다.
- HTML 기준 구현이 변경되면 새 기준 commit을 기록한다.
- Godot에서 더 적합한 구조가 있더라도 게임 규칙 변경은 별도 승인한다.
- 게임성 변경과 엔진 이식 변경을 한 작업에서 섞지 않는다.
- 큰 리팩터링은 현재 Phase 완료 후 별도 작업으로 분리한다.
