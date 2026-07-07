---
id: convention-transaction
title: Transaction
aliases: [Transaction]
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
    note: "transaction 경계, tx client 규칙 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "선택 기준을 표로 풀어 쓰고, tx 이름 규칙 중복 병합"
tags: [nestjs, convention, transaction, prisma, database]
stack: nestjs
scope: transaction
relations:
  - id: convention-service-rule-policy
    label: related
  - id: convention-repository-prisma
    label: related
  - id: convention-code-review
    label: related
---

# Transaction

## 한 줄 요약

transaction 경계와 transaction client 전달 규칙. **여러 DB 작업이 함께 성공/실패해야 하거나 transaction client를 넘길 때** 읽는다. transaction은 [service](service-rule-policy.md)가 소유하고 [repository](repository-prisma.md)는 참여만 한다. 목차: [목차](../index.md)

## 목적

이 문서는 transaction 경계와 transaction client 전달 규칙을 정리한다.

## 원칙

- transaction은 service/유스케이스 계층이 소유한다([Service, Rule, Policy](service-rule-policy.md)).
- repository 함수는 transaction에 참여할 수 있어야 하지만 transaction을 직접 열지 않는다([Repository와 Prisma](repository-prisma.md)).
- transaction 안에는 DB 작업만 짧게 둔다.

## 어떤 방법을 쓰나

| 상황 | 방법 |
|---|---|
| 단일 모델에 단순 write 하나 | 일반 repository 함수 (transaction 불필요) |
| 서로 독립인 write 여러 개가 모두 성공해야 함 | `$transaction([...])` (배열) |
| 앞선 조회 결과로 다음 write를 결정해야 함 | interactive transaction (`$transaction(async (tx) => ...)`) |
| 부모와 자식 relation을 함께 만드는 단순 케이스 | nested write 검토 |

## 규칙

- 외부 API, S3, Kafka, LLM 호출을 DB transaction 안에 넣지 않는다.
- nested transaction을 만들지 않는다.
- repository 함수는 tx client를 받을 수 있게 한다.
- transaction client를 넘기거나 받는 parameter 이름은 `tx`로 통일한다. 기본 client와 tx를 모두 받는 함수도 이름은 `tx`를 쓴다.
- transaction 안에서 호출되는 repository 함수도 자체적으로 transaction을 새로 열지 않는다.
- 결제/지갑/ledger는 transaction, idempotency, audit trail을 함께 리뷰한다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(transaction)로 통합했다.

## 관련 문서

- [Service, Rule, Policy](service-rule-policy.md)
- [Repository와 Prisma](repository-prisma.md)
- [코드 리뷰](code-review.md)