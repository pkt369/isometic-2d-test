---
id: convention-testing
title: Testing
aliases: [Testing]
type: convention
status: active
created_at: 2026-07-01
created_by: 이상협
updated_at: 2026-07-02
updated_by: 이상협
last_verified_at: 2026-07-02
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "테스트 컨벤션 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "인프라 규칙 중복 정리, 모호한 표현(bespoke) 제거"
tags: [nestjs, convention, testing, tdd, jest]
stack: nestjs
scope: testing
relations:
  - id: convention-structure-ownership
    label: related
  - id: convention-repository-prisma
    label: related
  - id: convention-service-rule-policy
    label: related
  - id: convention-naming-convention
    label: related
  - id: convention-code-review
    label: related
---

# Testing

## 한 줄 요약

테스트 종류(unit/integration/e2e), 테스트 인프라 사용, TDD, 커버리지, Jest 설정 기준. **기능 추가, 버그 수정, DB 상태 전이, 테스트 인프라를 수정할 때** 읽는다. 목차: [목차](../index.md)

## 목적

이 문서는 테스트 종류, 테스트 인프라 사용, integration/e2e 판단 기준을 정리한다.

## 원칙

- 새 기능과 버그 수정은 가능한 한 TDD로 진행한다: 실패하는 테스트로 기대 동작을 먼저 잠그고 최소 구현으로 통과시킨 뒤 필요한 만큼 정리한다.
- API/DB 상태 전이가 있는 기능은 integration/e2e 테스트를 우선 검토한다.
- pure rule/policy는 unit test로 빠르게 잠근다([Service, Rule, Policy](service-rule-policy.md)).
- 외부 서비스는 helper override mock을 사용한다.
- 테스트 파일마다 infra bootstrap을 새로 만들지 않는다.
- 테스트 커버리지는 변경 범위 기준 90% 이상을 목표로 하고 실현 가능하면 100%에 가깝게 올린다.
- 커버리지만 올리려는 테스트는 금지한다. 테스트는 실제 동작, 계약, 회귀 위험을 증명해야 한다.

## 규칙

- repository 단독 테스트는 query 조건이 중요하거나 regression 위험이 있을 때 작성한다([Repository와 Prisma](repository-prisma.md)).
- 외부 LLM/TTS/S3/Kafka는 헬퍼 override mock을 사용한다.
- 테스트 인프라는 testcontainers, 공용 setup helper를 재사용한다. 테스트 파일마다 별도 bootstrap을 새로 만들지 않는다.
- unit test 파일은 `*.spec.ts`를 사용한다.
- integration test 파일은 `*.integration.spec.ts`를 사용한다.
- e2e test 파일은 `*.e2e.spec.ts`를 사용한다(파일명은 [네이밍 컨벤션](naming-convention.md)).
- unit과 integration/e2e config를 분리한다.
- integration/e2e는 `maxWorkers: 1`을 유지한다.
- `collectCoverageFrom` include/exclude 순서를 의도적으로 관리한다.

## TDD와 커버리지

- 작업 시작 시 변경하려는 동작을 먼저 테스트 관점으로 정의한다.
- 이미 보호된 동작은 기존 테스트를 갱신하거나 좁은 regression test를 추가한다.
- 새 동작은 실패하는 테스트를 먼저 추가하고, 테스트 실패 이유가 기대한 미구현 동작인지 확인한 뒤 구현한다.
- 커버리지 목표는 변경한 production code와 영향 모듈을 기준으로 판단한다.
- 전체 레포의 기존 낮은 커버리지는 현재 작업 실패로 간주하지 않되 현재 변경 범위의 커버리지를 낮추지 않는다.
- 의미 없는 branch 강제 실행, private 구현 세부사항 노출, 단순 getter/setter 호출, snapshot 남발, 불가능한 상태 조작처럼 커버리지만 올리는 테스트는 작성하지 않는다.
- 테스트하기 어려운 코드는 테스트 전용 우회로를 만들기보다 의존성 분리, pure rule 추출, helper 재사용처럼 실제 코드 구조를 개선해 검증 가능하게 만든다.
- 90% 미만으로 남길 수밖에 없으면 외부 시스템, legacy 구조, 시간 제약 같은 이유와 보완 계획을 작업 보고에 남긴다.

## 테스트 파일 생성 범위

- 테스트 파일은 대상 production code와 같은 앱 또는 같은 라이브러리 경계 안에 둔다([Structure, Ownership](structure-ownership.md)).
- 앱 기능의 unit test는 대상 모듈 내부의 기존 배치를 따른다. 모듈에 `test/` 디렉터리가 있으면 그 안에 두고 이미 소스 옆 `*.spec.ts` 패턴이 있는 작은 모듈은 같은 패턴을 유지한다.
- 앱 integration test는 해당 앱의 `src/<module>/test/` 아래에 둔다.
- 앱 e2e test는 앱 경계를 검증할 때만 작성하고, 기존 앱 e2e 위치나 해당 모듈 `test/` 위치를 따른다.
- 라이브러리 테스트는 해당 `libs/<name>/` 하위에 둔다. 공통 domain rule은 기존 `libs/domain/test/` 패턴을 따른다.
- 여러 앱이 공유하는 test helper나 global setup은 앱별 `apps/<app>/test/` 또는 루트 `test/`의 기존 helper를 확장한다.
- 다른 앱의 테스트 디렉터리에 현재 앱 기능 테스트를 만들지 않는다.
- 테스트만을 위해 production source tree 밖에 임시 fixture 계층을 새로 만들지 않는다. 필요한 fixture는 가장 좁은 테스트 경계 안에 둔다.

## 변경 유형별 확인

- API, DTO, guard, interceptor 변경은 영향 앱 integration 테스트를 추가하거나 갱신한다.
- 인증 실패, 권한 실패, validation 실패 케이스를 필요한 범위에서 포함한다.
- application/business rule 변경 중 pure rule은 unit test로 확인한다.
- DB, Redis, 외부 연동이 있는 유스케이스 변경은 integration/e2e 테스트를 검토한다.
- 새 유스케이스는 happy path와 rule violation을 함께 검토한다.
- repository/Prisma 변경은 영향 유스케이스 테스트에서 soft delete, join, 정렬, pagination 회귀를 확인한다.
- scheduler/job 변경은 scheduler spec과 integration spec에서 대상 선택 조건과 idempotency를 확인한다.
- infrastructure adapter 변경은 adapter unit test와 호출 유스케이스 또는 앱 경계 테스트를 함께 검토한다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(테스트)로 통합했다.

## 관련 문서

- [Structure, Ownership](structure-ownership.md)
- [Repository와 Prisma](repository-prisma.md)
- [Service, Rule, Policy](service-rule-policy.md)
- [네이밍 컨벤션](naming-convention.md)
- [코드 리뷰](code-review.md)