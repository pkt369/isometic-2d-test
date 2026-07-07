---
id: convention-structure-ownership
title: "Structure, Ownership"
aliases: ["Structure, Ownership"]
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
    note: "모듈 구조, ownership 컨벤션 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "전반적으로 쉬운 표현으로 다듬음, 폴더 트리 repository/ → repositories/ 통일"
tags: [nestjs, convention, architecture, module, ownership]
stack: nestjs
scope: structure-ownership
relations:
  - id: convention-naming-convention
    label: related
  - id: convention-code-review
    label: related
---

# Structure, Ownership

## 한 줄 요약

모듈을 어떻게 나누고, 각 레이어가 어떤 책임을 가질지 정하는 기준이다. **새 기능을 만들거나, 모듈 구조를 바꾸거나, 공통 코드를 옮길 때** 읽는다. 계층별 상세는 [Repository와 Prisma](repository-prisma.md), [Service, Rule, Policy](service-rule-policy.md)를 참고한다. 목차: [목차](../index.md)

## 목적

이 문서는 코드가 어느 모듈과 레이어에 있어야 하는지, 그리고 다른 모듈을 어떻게 참조해야 하는지에 대한 기준을 정리한다.

## 원칙

- 모듈은 기술 계층이 아니라 **기능(도메인) 단위**로 나눈다(feature-based).
- 기존 코드가 이 기준과 다르다고 해서 한꺼번에 다 바꾸지 않는다.
- 새 기능, 큰 수정부터 이 기준을 적용하고, 기존 코드는 손대는 김에 조금씩 맞춰 간다.
- 공유 코드로 옮길지는 "재사용할 수 있나"가 아니라 **"누가 소유하고 바꿀 책임이 명확한가"**로 판단한다.

## 목표 구조

한 모듈은 대체로 이렇게 구성한다.

```text
apps/<app>/src/<module>/
  <module>.module.ts
  controllers/
    *.controller.ts
  dto/
    *.request.dto.ts
    *.response.dto.ts
    *.dto.ts
  services/
    *.service.ts
    *.rule.ts
    *.policy.ts
    *.type.ts
  repositories/
    *.repository.ts
  clients/
    *.client.ts
  jobs/
  test/
    *.spec.ts
    *.integration.spec.ts
    *.e2e.spec.ts
```

## 폴더로 언제 나누나

- controller, service, repository가 각각 1개 정도이고 책임이 단순하면 모듈 루트에 바로 둬도 된다.
- 같은 역할의 파일이 3개 이상이 되거나 유스케이스별로 책임이 나뉘면 `controllers/`, `services/`, `repositories/`처럼 역할별 폴더로 묶는다.
- 단, repository는 파일 수와 무관하게 Prisma 접근이 여러 service에서 반복되거나 transaction 참여가 필요하면 분리한다([Repository와 Prisma](repository-prisma.md)).
- 외부 API/SDK 호출이 생기면 `clients/`나 `libs/infra`로 분리한다.

## 다른 모듈, 라이브러리 참조

- `apps/*`끼리 서로 직접 import하지 않는다.
- 앱 간에 공유가 필요하면 코드를 `libs/*`로 옮기고, 책임에 따라 위치를 고른다.
  - `libs/common` — enum, decorator, pipe, guard, interceptor, exception, pagination DTO 같은 범용 유틸.
  - `libs/domain` — 특정 앱의 auth/API 계약을 몰라도 설명되는 도메인 규칙, 유스케이스.
  - `libs/infra` — Redis, Kafka, S3/CloudFront, LLM, 결제 provider 같은 외부 기술 어댑터.

### 경로 별칭 — `@libs`

라이브러리는 `@app`이 아니라 **`@libs`** 별칭으로 만들고 import한다.

- NestJS CLI 기본 prefix는 `@app`이다. `nest g library <name>`을 실행하면 prefix를 묻는데(`What prefix would you like to use for the library (default: @app)?`), 여기서 **`@libs`로 답한다.**
- 별칭 매핑은 루트 `tsconfig.json`의 `paths`에 `@libs/<name>` → `libs/<name>/src`로 생긴다. import는 `import { FooModule } from '@libs/foo';`.
- 이미 `@app`으로 만들어졌다면 `tsconfig.json`의 `paths` 키와 소스의 import 문을 `@libs`로 바꾼다.

## Controller 경계

Controller는 **얇게** 유지한다. HTTP 입출력만 다루고, 판단, 처리는 service로 넘긴다.

해도 되는 것:

- param/query/body DTO 받기
- pipe로 primitive 값 변환
- header, cache, 파일 다운로드 같은 HTTP 메타데이터 설정
- service 호출 후 response DTO 반환

하면 안 되는 것:

- Prisma 직접 호출
- 외부 API/SDK 직접 호출
- transaction 시작
- 비즈니스 규칙 분기([Service, Rule, Policy](service-rule-policy.md))
- permission, audience, status를 문자열로 직접 판단

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(구조, 소유권)로 통합했다.

## 관련 문서

- [Repository와 Prisma](repository-prisma.md)
- [Service, Rule, Policy](service-rule-policy.md)
- [네이밍 컨벤션](naming-convention.md)
- [코드 리뷰](code-review.md)
