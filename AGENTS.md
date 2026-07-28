---
project: RicochetAngles
document_type: repository_contract
repository_role: godot_feasibility_spike_addendum
status: ACTIVE
phase_id: PHASE-V0.1
updated: 2026-07-28
engine_candidate: Godot
fallback_candidate: Unreal Engine 5
---

# RicochetAngles Godot Repository Instructions

## 1. Repository Purpose

이 저장소의 현재 목적은 RicochetAngles 전체를 Godot으로 포팅하는 것이 아니다.

> Godot에서 RicochetAngles의 핵심 전차 조작, 마우스 조준, 카메라와 분리된 2D 장갑 판정, 도탄 반사, 탑다운·사선 직교 카메라, Windows/Web export가 합리적인 구조와 생산성으로 성립하는지 빠르게 검증한다.

기존 `Phase V0 — Godot Core Feasibility Spike`는 사용자 직접 검증을 거쳐 `PASS`로 판정되었다.

현재 저장소의 활성 작업은 사용자 승인에 따른 일회성 추가 검증인 `Phase V0.1 — Moving Target Combat Spike`다.

V0의 성공은 더 많은 기능을 구현하는 것이 아니라 다음 불확실성을 제거하는 것이다.

- 차체와 포탑을 안정적으로 분리할 수 있는가
- 탑다운과 사선 직교 카메라에서 마우스 지면 조준이 정확한가
- 3D 시각 표현과 독립된 2D 장갑 판정을 유지할 수 있는가
- 전면·측면·후면, 입사각, 유효 장갑, 도탄·비관통·관통을 명확히 디버그할 수 있는가
- 논리적 도탄 반사 방향과 화면상 반사가 일치하는가
- Windows export가 정상인가
- 가능하면 Web export가 정상인가
- 소규모 기능 구현과 디버깅의 생산성이 합리적인가

V0.1은 V0 결과를 뒤집거나 전체 포팅을 재개하기 위한 단계가 아니다.

움직이는 표적을 조준하고 3회의 관통으로 격파하는 최소 전투 연결성만 확인한 뒤 Godot 작업을 중단하고 HTML Pilot의 다음 Phase로 복귀한다.

## 2. Current Product Direction

현재 제품 개발 우선순위는 다음과 같다.

1. Godot V0 결과 `PASS` 보존
2. V0.1에서 움직이는 표적 1대와 관통 누적 격파만 확인
3. V0.1 결과 기록
4. Godot 작업 즉시 중단
5. HTML Pilot `H5B — 방향 계약·장갑 체감 진단`으로 복귀
6. HTML Pilot에서 구간 진행, 체크포인트, 5~10분 완주 Stage, 외부 플레이테스트를 완료
7. HTML Pilot 규칙과 대표 플레이 기준판이 확정된 뒤에만 별도 `G0R`에서 본격 엔진 포팅 계획을 다시 작성

이 저장소의 과거 `Phase 1~11` 전체 포팅 계획은 현재 실행 계획이 아니다.

- 상태: `SUSPENDED`
- 자동 재개: 금지
- V0.1 완료 후 재개: 금지
- 재개 조건: HTML Pilot 기준판 확정 후 사용자 승인
- 재개 방식: 기존 문서의 단순 연장이 아니라 `G0R`에서 전면 재기준화

## 3. Authority and Source of Truth

충돌 시 우선순위는 다음과 같다.

1. 사용자의 현재 명시적 지시
2. 이 `AGENTS.md`
3. `PHASE_V0_GODOT_FEASIBILITY_SPEC.md`
4. `CODEX_TASK_PHASE_V0_GODOT.md`
5. `MIGRATION_PHASES.md`
6. `PROJECT_CONTEXT.md`
7. `PHASE5_STAGE2_CLOSEOUT.md`
8. 현재 Godot 코드와 실행 결과
9. 과거 Godot 전체 포팅 문서와 대화

역할:

- 사용자 지시: 현재 범위와 중단 여부의 최종 권한
- `AGENTS.md`: 코딩, 검증, Git, 범위, 중단 계약
- `PHASE_V0_GODOT_FEASIBILITY_SPEC.md`: V0 기술 사양과 합격 기준
- `CODEX_TASK_PHASE_V0_GODOT.md`: Codex 실행 절차와 완료 보고 형식
- `MIGRATION_PHASES.md`: V0 내부 단계, 사용자 검증, 판정, 종료 후 복귀 순서
- `PROJECT_CONTEXT.md`: 전체 제품 방향과 HTML 우선 로드맵
- 현재 코드와 실행 결과: 구현 사실의 Source of Truth

문서와 코드가 충돌하면 임의로 맞추지 않는다. 작업 전에 차이를 보고하고 V0 범위 안에서만 해결한다.

## 4. Status Vocabulary

- `READY`: 구현 시작 조건이 갖춰짐
- `IN_PROGRESS`: 현재 작업 중
- `IMPLEMENTED`: 코드와 씬에 연결됨
- `PARTIAL`: 일부 구현되었으나 핵심 조건이 남음
- `UNVERIFIED`: 구현은 있으나 실행 또는 사용자 검증이 부족함
- `PASS`: V0 핵심 기술과 생산성이 합리적으로 성립
- `PASS_WITH_RISK`: 기술은 성립하지만 관리 가능한 위험 존재
- `FAIL_TECHNICAL`: 구조적 기술 부적합
- `FAIL_PRODUCTIVITY`: 구현 가능하나 생산성 비용이 비합리적
- `INCONCLUSIVE`: 제한된 추가 검증 없이는 결론 불가
- `SUSPENDED`: 현재 실행하지 않는 과거 또는 미래 계획
- `DEFERRED`: V0 범위 밖으로 미룸
- `STOPPED`: V0 결과 기록 뒤 Godot 작업을 종료함

실행하지 않은 검사를 `PASS`로 기록하지 않는다.

Codex 자체 검증만으로 최종 엔진 판정을 확정하지 않는다.

최종 `PASS / PASS_WITH_RISK / FAIL`은 사용자 직접 조작·판정 검증 후 확정한다.

## 5. Current Technology Contract

- Godot 4.7 일반 버전
- GDScript
- Compatibility renderer
- 3D 시각 공간
- XZ 지상 논리 평면
- Y축은 시각 높이
- 직교 `Camera3D`
- primitive mesh
- 단순 material
- 단순 collider
- 실제 무한궤도 물리 제외
- 실제 서스펜션 제외
- 외부 Godot plugin 제외
- MCP 제외
- C# 제외
- 외부 라이브러리 제외
- 서버와 네트워크 제외

V0의 기술 선택은 장기 확장성을 완성하기 위한 것이 아니라 핵심 위험을 빠르게 판단하기 위한 것이다.

## 6. Absolute Scope Boundary

### 6.1 Allowed

- 단색 평면 테스트장
- 격자 또는 원점 표시
- 플레이어 primitive 전차 1대
- 고정 표적 최대 2대
- 움직이는 표적 전차 정확히 1대
- 움직이는 표적의 단순 순찰 또는 왕복 이동
- 움직이는 표적 HP 3
- 관통 시 HP 1 감소
- 비관통·도탄 시 HP 변화 없음
- HP 0에서 이동·피격·충돌을 중단하는 파괴 상태
- R 입력 시 움직이는 표적의 위치·HP·파괴 상태 초기화
- W/S 전진·후진
- A/D 차체 선회
- 간단한 delta 기반 가속·감속
- 차체와 포탑 독립 회전
- 마우스 ray-plane 지면 조준
- 탑다운 직교 카메라
- 사선 직교 카메라
- C 키 카메라 전환
- APHE 1종
- 단순 직선 포탄
- 안정적인 ray 또는 sweep 충돌
- 충돌점과 3D 물리 노멀 표시
- 카메라·mesh와 독립된 2D 장갑 판정
- 전면·측면·후면
- 입사각
- 기본 장갑
- 유효 장갑
- 관통력
- 도탄
- 비관통
- 관통
- 도탄 반사 방향
- 디버그 오버레이
- R 테스트장 초기화
- F1 디버그 표시 전환
- Windows export
- 가능하면 Web export
- `README_V0.md`
- `V0_VALIDATION_RESULTS.md`
- 실행 캡처 또는 짧은 영상
- export preset

### 6.2 Forbidden

- 보스
- 궤도 파괴
- 엔진
- 약점
- 폭주
- APCR
- HE
- GAS
- 경전차
- 대전차포
- 보병
- 플레이어를 공격하는 적 AI
- 추격·회피·경로 탐색·전술 상태를 가진 적 AI
- 생성
- 리스폰
- 곡사포
- Q 아군 포격
- 불렛타임
- SCORE
- XP
- 아이템
- 드롭
- Stage 1
- Stage 2
- Stage Director
- 체크포인트
- 정비 구역
- 맵 에디터
- 저장
- 캠페인
- 정식 HUD
- 정식 사운드
- 정식 전차 모델
- 정식 텍스처
- 정식 VFX
- 게임패드
- Steam 기능
- HTML 전체 데이터 포팅
- 미래 전체 포팅용 추상화
- 움직이는 표적을 2대 이상 추가
- 적의 플레이어 공격
- 웨이브·생성·리스폰
- 과거 Phase 1~11 시작

범위 밖 아이디어는 구현하지 않고 완료 보고의 `Deferred`에만 기록한다.

## 7. Stop Rule

V0는 이미 `PASS`로 종료되었다. 사용자의 명시적 승인으로 V0.1만 일회성 예외로 연다.

다음 중 하나가 충족되면 V0.1 작업을 종료한다.

1. 핵심 합격 기준이 사용자 검증까지 완료됨
2. Godot의 구조적 부적합이 충분히 입증됨
3. 제한된 추가 검증 없이는 결론을 낼 수 없다고 기록됨

V0.1이 완료되면 다음을 하지 않는다.

- 보스 일부 추가
- 다른 탄종 추가
- AI 추가
- Stage 추가
- 정식 모델 적용
- 장기 구조 리팩터링
- 기존 Phase 1 시작
- 새로운 Godot Phase 제안
- Godot판 계속 개발

완료 보고에는 다음 문장을 포함한다.

> Phase V0.1의 검증 범위에서 작업을 종료했으며, 움직이는 표적 1대·HP 3·관통 격파를 넘어 보스·Stage·전체 탄종·전투 AI·정식 아트·전체 포팅으로 확장하지 않았다.

## 8. Test Range Contract

테스트장은 다음만 포함한다.

- 판독 가능한 단색 바닥
- 좌표 격자 또는 원점 표시
- 플레이어 primitive 전차
- 고정 표적 0~2개
- 단순 이동 표적 1개
- 최소 조명
- 탑다운 및 사선 직교 카메라
- 포탄과 충돌 디버그 표시
- 장갑 결과 오버레이

테스트장은 게임 Stage가 아니다.

테스트장 크기, 배치, 색상, 임시 모델 품질은 엔진 적합성 판단에 필요한 수준이면 충분하다.

## 9. Player Movement Contract

필수 동작:

- W: 전진
- S: 후진
- A/D: 차체 선회
- 차체 정면 기준 이동
- 횡이동 없음
- delta 기반
- 간단한 가속
- 간단한 감속
- 차체와 포탑 독립

V0에서는 HTML 이동감을 완벽히 복제할 필요가 없다.

판단 대상은 조작 구조의 안정성, 프레임레이트 독립성, 회전 분리, 디버깅 생산성이다.

임시 이동감 차이를 엔진 구조적 실패로 판정하지 않는다.

## 10. Camera and Aiming Contract

두 카메라를 제공한다.

1. 탑다운 직교 카메라
2. 사선 직교 카메라

C 키로 전환한다.

마우스 조준은 화면 좌표에서 ray를 만들고 XZ 논리 평면과 교차한 월드 지점을 사용한다.

카메라 transform은 장갑 판정 입력이 아니다.

### 10.1 Camera Switch Aim Persistence

카메라 전환 시 같은 화면 픽셀을 유지하는 것이 목적이 아니다.

카메라 투영이 바뀌면 같은 픽셀이 다른 지면 위치를 가리키는 것은 정상이다.

V0-T04 기준:

1. 전환 직전 월드 조준점을 저장한다.
2. C 키로 카메라를 전환한다.
3. 다음 마우스 이동 전까지 저장된 월드 조준점을 유지한다.
4. 마우스가 다시 움직이면 새 카메라 기준 ray-plane 교차점으로 갱신한다.

디버그 오버레이에는 mouse screen position, current world aim point, stored world aim point, active camera mode, camera switch state를 표시한다.

## 11. Projectile Contract

- APHE 1종만 사용
- 좌클릭 발사
- 포구 위치에서 직선 이동
- 이전 위치와 현재 예정 위치 사이 ray 또는 작은 sweep
- 가장 가까운 최초 충돌 하나만 처리
- 충돌 위치와 3D 물리 노멀 기록
- 한 포탄이 한 프레임에 여러 표적 처리 금지
- 도탄 시 논리 반사 방향으로 계속 비행
- 동일 표면 즉시 재충돌 방지용 separation offset
- R 초기화 시 모든 포탄 제거

V0에서는 탄약, 재장전, bloom, 사운드, 탄종 전환을 구현하지 않는다.

## 12. Logical Armor Contract

장갑 판정은 2D XZ 평면의 독립 모듈이어야 한다.

권장 파일명은 `armor_logic_2d.gd`이지만 기존 구조에 적합한 동등한 이름을 사용할 수 있다.

### 12.1 Inputs

- target position 2D
- target yaw
- projectile direction 2D
- hit point 또는 target-local hit direction
- front armor
- side armor
- rear armor
- penetration
- auto-ricochet threshold

### 12.2 Outputs

- armor zone
- logical armor normal 2D
- incidence angle
- base armor
- effective armor
- penetration
- result
- reason
- reflected direction when ricochet

### 12.3 Results

- `RICOCHET`
- `NON_PENETRATION`
- `PENETRATION`

### 12.4 Independence Rule

장갑 판정은 다음에 종속되지 않는다.

- Camera3D transform
- camera mode
- camera yaw
- camera pitch
- screen position
- mesh triangle
- mesh normal
- material name
- shader
- primitive mesh 크기
- 렌더링 순서

카메라 또는 mesh를 바꿔도 같은 논리 입력이면 같은 결과가 나와야 한다.

## 13. Normal Separation Contract

### 13.1 `physics_hit_normal_3d`

- Godot 3D 충돌 쿼리가 반환한 노멀
- 충돌 위치와 시각적 진단용
- collider 면 확인용
- 장갑 결과의 최종 권위값이 아님

### 13.2 `logical_armor_normal_2d`

- 표적 yaw와 전면·측면·후면 논리 구역에서 계산
- 입사각 계산의 권위값
- 유효 장갑 계산의 권위값
- 도탄 반사 계산의 권위값

두 값을 하나의 `normal` 변수로 합치지 않는다.

디버그 오버레이에 두 값을 각각 표시한다.

V0 핵심 검증:

> 카메라와 primitive mesh 형태를 바꿔도 `logical_armor_normal_2d`와 최종 장갑 결과가 변하지 않는가.

## 14. Armor Zone Contract

V0에서는 다음 세 구역만 사용한다.

- `FRONT`
- `SIDE`
- `REAR`

좌우 측면은 같은 `SIDE` 장갑값을 사용해도 된다.

면 판정은 표적 yaw와 논리적 로컬 방향을 기준으로 한다.

경계에서 프레임마다 흔들리지 않도록 일관된 규칙을 사용하고 README에 기록한다.

약점, 궤도, 포탑 장갑, 복합 collider는 구현하지 않는다.

## 15. Incidence and Effective Armor Contract

입사각 기준:

- 0도: 장갑면에 수직
- 90도: 장갑면과 평행

유효 장갑 계산은 cosine이 0에 가까울 때 수치 폭주가 발생하지 않도록 안정화한다.

계산식과 clamp 규칙을 README 또는 코드 주석에 명시한다.

자동 도탄 threshold는 튜닝 상수로 둔다.

판정 순서:

1. 면 구분
2. logical armor normal 계산
3. 입사각 계산
4. 자동 도탄 여부
5. 유효 장갑 계산
6. 관통력 비교
7. 결과 반환
8. 도탄 시 반사 방향 반환

## 16. Debug Overlay Contract

F1로 표시를 전환한다.

명중마다 다음을 표시한다.

- active camera
- target ID
- target position 2D
- target yaw
- projectile direction 2D
- physics hit point 3D
- physics hit normal 3D
- logical armor normal 2D
- armor zone
- incidence angle
- base armor
- effective armor
- penetration
- result
- reason
- reflected direction
- projectile ID

월드 시각화:

- 마우스 월드 조준점
- 충돌점
- physics normal
- logical normal
- incoming direction
- reflected direction

디버그 정보는 실제 판정 결과 객체를 사용한다.

UI용 장갑 계산을 별도 재구현하지 않는다.

## 17. Reset Contract

R 입력은 테스트장을 초기화한다.

초기화 대상:

- 플레이어 위치
- 플레이어 차체 yaw
- 포탑 yaw
- 카메라 모드
- 저장된 월드 조준점
- 포탄
- 최근 충돌점
- 최근 노멀
- 최근 장갑 결과
- 디버그 일시 상태
- 표적 yaw와 위치
- 일시적인 시각선

반복 R 테스트에서 상태 누수가 없어야 한다.


## 17.1 V0.1 Moving Target Contract

V0.1의 이동 표적은 정식 적 AI가 아니다.

목적은 다음 하나다.

> 움직이는 장갑 표적을 탑다운·사선 카메라에서 조준하고, 기존 APHE와 2D 장갑 판정으로 관통을 누적해 격파할 수 있는가.

필수 조건:

- 움직이는 표적은 정확히 1대
- 기존 `target_tank` 또는 동등한 표적 구조 재사용
- 단순한 두 지점 왕복, 일정 반경 순찰 또는 동등한 결정적 이동
- 경로 탐색 없음
- 장애물 회피 없음
- 플레이어 추격 없음
- 플레이어 공격 없음
- 포탑 AI 없음
- 생성·리스폰 없음
- 속도와 회전은 delta 기반
- 움직이는 동안 기존 전면·측면·후면 장갑 판정 유지
- 탑다운·사선 카메라 모두에서 동일한 논리 결과 유지

정지 구간이나 방향 전환이 필요하면 최소한으로 허용한다.

이동 패턴의 재미, 전술성, 난이도는 평가 대상이 아니다.

## 17.2 V0.1 Damage and Destroy Contract

움직이는 표적의 생명주기는 다음으로 제한한다.

- 최대 HP: `3`
- 초기 HP: `3`
- `PENETRATION`: HP 1 감소
- `NON_PENETRATION`: HP 변화 없음
- `RICOCHET`: HP 변화 없음
- 하나의 포탄은 최대 한 번만 피해 적용
- HP는 0 미만으로 내려가지 않음
- HP 0 도달 시 `DESTROYED`
- `DESTROYED` 상태에서 이동 중단
- `DESTROYED` 상태에서 추가 피해 중단
- 전투용 collider 비활성화 또는 동등한 중복 피격 방지
- 간단한 색상 변경, 기울어짐, 비활성 표시 또는 소멸로 파괴 상태 표현
- 정식 폭발 VFX와 사운드는 구현하지 않음
- R 입력 시 HP, transform, 이동 방향, 파괴 표시, collider 상태 초기화

피해의 권위값은 기존 장갑 결과다.

3D 물리 노멀, 카메라 방향, 렌더 mesh는 피해 여부를 직접 결정하지 않는다.

## 17.3 V0.1 Aim Policy Boundary

V0.1의 목적은 움직이는 표적과 관통 격파 확인이다.

기존 조준 정책은 다음처럼 기록한다.

- 현재 구현: 마우스 motion 이벤트가 있을 때 월드 조준점 갱신
- 마우스 정지 시: 마지막 월드 조준점 유지

다음 두 제품 정책은 V0.1 범위에서 새로 구현하지 않는다.

1. 차체 기준 포탑 상대각 고정
2. 정지한 커서의 화면 좌표를 매 프레임 지면에 재투영

움직이는 표적 검증을 불가능하게 만드는 명백한 결함이 확인된 경우에만 사용자 승인 후 별도 수정한다.

그 외에는 V0.1 결과의 `Risk` 또는 `Deferred Product Decision`으로 기록한다.


## 18. Export Contract

필수:

- Windows export
- Windows 실행 확인

가능하면:

- Web export
- 브라우저 실행 확인

Web export 실패는 자동으로 Godot 실패를 의미하지 않는다.

다음으로 분류한다.

- 프로젝트 코드 문제
- export preset 문제
- export template 문제
- 브라우저 또는 WebGL 문제
- 로컬 호스팅 문제
- 환경 제한

확인하지 못하면 실패 사유와 재현 절차를 기록한다.

## 19. Validation Scenarios

- V0-T01 기본 이동
- V0-T02 탑다운 조준
- V0-T03 사선 조준
- V0-T04 카메라 전환과 월드 목표 유지
- V0-T05 정면 수직·비스듬한 판정
- V0-T06 측면·후면 판정
- V0-T07 표적 yaw 변경
- V0-T08 도탄 반사 방향
- V0-T09 반복 초기화
- V0-T10 export
- V0.1-T01 움직이는 표적의 반복 가능한 이동
- V0.1-T02 이동 중 전면·측면·후면 판정
- V0.1-T03 관통·비관통·도탄의 HP 적용 구분
- V0.1-T04 3회 관통 격파와 추가 피해 차단
- V0.1-T05 R 초기화와 탑다운·사선 사용자 확인

각 테스트는 결과, 실행 방법, 관찰 근거, 로그 또는 캡처, 위험, 사용자 확인 필요 여부를 기록한다.

## 20. Engine Assessment Contract

Codex 상세 판정:

- `PASS`
- `PASS_WITH_RISK`
- `FAIL_TECHNICAL`
- `FAIL_PRODUCTIVITY`
- `INCONCLUSIVE`

사용자 최종 요약:

- `PASS`
- `PASS_WITH_RISK`
- `FAIL`

`FAIL_TECHNICAL`과 `FAIL_PRODUCTIVITY`는 최종 FAIL의 원인으로 기록한다.

`INCONCLUSIVE`는 추가 검증 필요 상태다.

## 21. User Validation Gate

Codex 검증 후 사용자가 직접 확인한다.

1. 탑다운 조준 감각
2. 사선 조준 감각
3. 차체·포탑 독립 조작
4. 카메라 전환 시 월드 조준점 유지
5. 정면·측면·후면 판정
6. 표적 yaw 변화에 따른 결과 변화
7. 비스듬한 명중의 도탄 변화
8. 도탄 방향의 시각적 설득력
9. Windows 실행 빌드
10. Godot 작업 생산성 체감
11. 움직이는 표적을 두 카메라에서 조준 가능한가
12. 관통할 때만 HP가 감소하는가
13. 3회 관통 후 표적이 확실히 파괴되는가
14. 파괴 후 추가 피해와 이동이 중단되는가

사용자 검증 전 상태는 `PENDING_USER_VALIDATION` 또는 `INCONCLUSIVE`로 기록한다.

## 22. Required Workflow for Every Change

1. `git branch --show-current`
2. `git status --short`
3. 저장소 구조 확인
4. Godot 버전 확인
5. 기존 scene/script 확인
6. 세 계약 문서 확인
7. V0 범위 요약
8. 예상 수정 파일 목록 제시
9. 최소 구현 계획 제시
10. V0 범위만 수정
11. Godot 에디터 로드 검사
12. 명령행 실행 검사
13. 기존 V0 회귀 검사
14. V0.1-T01~T05 검증
15. Windows export
16. 가능하면 Web export
17. 결과 문서 작성
18. 작업 트리 확인
19. Stop confirmation 작성
20. 추가 기능 구현 없이 종료

## 23. Git and File Safety

- 사용자 요청 없이 commit 금지
- 사용자 요청 없이 push 금지
- 사용자 요청 없이 branch 생성·전환 금지
- `reset --hard` 금지
- `clean -fd` 금지
- rebase 금지
- force push 금지
- 기존 uncommitted 변경 덮어쓰기 금지
- 관련 없는 파일 수정 금지
- `.godot/` 추적 금지
- 임시 export 결과 무단 추가 금지
- 로컬 절대 경로 고정 금지
- HTML 저장소 수정 금지
- Stage 1·2 파일 복사 금지

## 24. Plugins and Dependencies

- MCP 금지
- 외부 Godot plugin 금지
- addon 설치 금지
- C# 추가 금지
- native extension 추가 금지
- 외부 package 추가 금지

외부 의존성 없이는 V0를 구현할 수 없다고 판단되면 중단하고 이유를 보고한다.

## 25. Recommended File Responsibilities

권장 예:

```text
project.godot
scenes/
  test_range.tscn
  player_tank.tscn
  target_tank.tscn
  projectile.tscn
scripts/
  player_tank.gd
  turret_aim.gd
  camera_controller.gd
  projectile.gd
  armor_logic_2d.gd
  target_tank.gd
  moving_target_controller.gd
  debug_overlay.gd
tests_or_validation/
  V0_VALIDATION_RESULTS.md
  V01_VALIDATION_RESULTS.md
README_V0.md
```

기존 구조가 있으면 기존 구조를 존중한다.

파일명을 맞추기 위한 불필요한 이동이나 리팩터링을 하지 않는다.

## 26. Completion Report Format

### Summary
- 구현된 V0 기능
- Godot 버전
- 실행 방법

### Repository Audit
- 시작 branch
- 시작 status
- 기존 파일
- 기존 충돌 또는 위험

### Changed Files
- 파일 목록
- 각 책임

### Validation Results

| Test | Result | Evidence | Notes |
|---|---|---|---|
| V0-T01 | PASS/FAIL/UNVERIFIED | | |
| V0-T02 | PASS/FAIL/UNVERIFIED | | |
| V0-T03 | PASS/FAIL/UNVERIFIED | | |
| V0-T04 | PASS/FAIL/UNVERIFIED | | |
| V0-T05 | PASS/FAIL/UNVERIFIED | | |
| V0-T06 | PASS/FAIL/UNVERIFIED | | |
| V0-T07 | PASS/FAIL/UNVERIFIED | | |
| V0-T08 | PASS/FAIL/UNVERIFIED | | |
| V0-T09 | PASS/FAIL/UNVERIFIED | | |
| V0-T10 | PASS/FAIL/UNVERIFIED | | |

### V0.1 Validation Results

| Test | Result | Evidence | Notes |
|---|---|---|---|
| V0.1-T01 | PASS/FAIL/UNVERIFIED | | |
| V0.1-T02 | PASS/FAIL/UNVERIFIED | | |
| V0.1-T03 | PASS/FAIL/UNVERIFIED | | |
| V0.1-T04 | PASS/FAIL/UNVERIFIED | | |
| V0.1-T05 | PASS/FAIL/UNVERIFIED | | |

### Engine Assessment
- Codex 사전 판정
- 사용자 검증 대기 여부
- 근거

### Risks
- 조준
- 논리 판정 분리
- 경계각
- 도탄 반사
- 생산성
- Windows export
- Web export

### Deferred
V0 범위 밖이라 구현하지 않은 항목.

### Git Status
- 종료 branch
- 종료 status
- commit 여부
- push 여부

### Stop Confirmation

> Phase V0.1의 검증 범위에서 작업을 종료했으며, 움직이는 표적 1대·HP 3·관통 격파를 넘어 보스·Stage·전체 탄종·전투 AI·정식 아트·전체 포팅으로 확장하지 않았다.

## 27. Current Repository Status

- Repository role: Godot V0.1 moving target combat spike
- V0 Result: `PASS`
- Active Phase: `V0.1`
- Whole Godot port: `SUSPENDED`
- Old Phase 1~11: `SUSPENDED`
- Main game implementation: not started
- Required next action: moving target 1대·HP 3·관통 격파만 구현
- Required action after V0.1: stop Godot work and return to HTML H5B
- Future full port: only after HTML Pilot baseline and separate G0R approval

## 28. Definition of Done

- 저장소 감사 완료
- V0 범위만 구현
- W/S/A/D 이동 정상
- 차체·포탑 독립 정상
- 탑다운 조준 정상
- 사선 조준 정상
- 카메라 전환 월드 목표 유지 정상
- APHE 1종 발사 정상
- 전면·측면·후면 판정 정상
- 입사각과 유효 장갑 정상
- 도탄·비관통·관통 정상
- 논리 반사와 시각 반사 일치
- R 반복 초기화 상태 누수 없음
- Windows export 정상
- Web export 결과 또는 실패 사유 기록
- 디버그 오버레이 정상
- V0-T01~T10 결과 기록
- 사용자 직접 검증 완료
- V0 `PASS` 기록 유지
- 움직이는 표적 정확히 1대
- 관통 시에만 HP 1 감소
- 3회 관통 후 파괴
- 파괴 후 이동·추가 피해 중단
- V0.1-T01~T05 결과 기록
- 범위 밖 기능 미구현
- Stop confirmation 작성
- Godot 작업 종료
- HTML H5B 복귀
