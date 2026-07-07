---
id: convention-service-rule-policy
title: "Service, Rule, Policy"
aliases: ["Service, Rule, Policy"]
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
    note: "service, rule, policy 컨벤션 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "strategy/factory 설명 구체화, private method 규칙에서 '읽는 사람' 모호성 제거, 과한 분리 문제 명시"
tags: [nestjs, convention, service, architecture, use-case]
stack: nestjs
scope: service-rule-policy
relations:
  - id: convention-structure-ownership
    label: related
  - id: convention-repository-prisma
    label: related
  - id: convention-naming-convention
    label: related
  - id: convention-code-review
    label: related
---

# Service, Rule, Policy

## 한 줄 요약

service, rule, policy, strategy가 유스케이스 흐름과 비즈니스 판단을 나눠 갖는 기준. **유스케이스 흐름이나 비즈니스 판단을 구현할 때** 읽는다. DB 경계는 [Repository와 Prisma](repository-prisma.md). 목차: [목차](../index.md)

## 목적

이 문서는 service, rule, policy가 유스케이스 흐름과 비즈니스 판단을 나눠 갖는 기준을 정리한다.

## 원칙

- service는 유스케이스의 실행 순서를 담당한다.
- 비즈니스 규칙과 권한/상태/노출 판단은 필요할 때 이름 있는 rule/policy로 분리한다.
- 로직이 길어진다는 이유만으로 과도하게 함수화하지 않는다.
- 객체에서 처음 호출되는 public 함수는 유스케이스의 전체 흐름이 보이게 작성한다.

## 규칙

- 비즈니스 규칙이 길어지면 `*.rule.ts`로 분리한다.
- 권한/상태/노출 가능 여부 같은 판단은 `*.policy.ts`로 분리한다.
- 같은 인터페이스를 공유하는 여러 구현체 중 실행 시점에 하나를 선택해야 하면, Strategy 패턴으로 구현체를 `strategy/`에 분리하고 선택 로직은 factory에서 관리한다.
- service public 함수는 반환 타입을 명시한다.
- 외부 SDK, S3, Kafka, LLM은 infra/client를 거쳐 호출한다.
- private method는 남용하지 않는다. 과하게 쪼개면 호출을 계속 타고 들어가야 해서 유스케이스 흐름을 따라가기 어렵다. public 흐름을 단순하게 유지하는 데 도움이 될 때만 분리한다.
- public 함수가 모든 세부 구현을 품고 비대해지는 것도 피한다.
- 목표는 숨기기가 아니라, 유스케이스 흐름과 이름 있는 하위 개념이 함께 보이는 구조다.
- 단순히 줄 수를 줄이기 위한 helper 추출, 한 번만 호출되는 의미 없는 wrapper, 이름만 바꾼 pass-through 함수는 피한다.
- 함수명에는 함수 내부에서 수행하는 핵심 작업이 드러나야 한다(네이밍은 [네이밍 컨벤션](naming-convention.md)).
- 함수명이 추상적이라 내부를 열어봐야 무엇을 하는지 알 수 있다면 이름을 더 구체화한다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(service, rule, policy)로 통합했다.

## 관련 문서

- [Structure, Ownership](structure-ownership.md)
- [Repository와 Prisma](repository-prisma.md)
- [Transaction](transaction.md)
- [네이밍 컨벤션](naming-convention.md)
- [코드 리뷰](code-review.md)