---
id: convention-repository-prisma
title: Repository와 Prisma
aliases: [Repository와 Prisma]
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
    note: "repository, Prisma 컨벤션 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "피드백 반영: soft delete 조회 전제 명시, 식별자 UUID v7 통일(BigInt 제거), VarChar→String(text) 명확화, status/enum 중복 병합, 앱 enum은 도메인 모듈 우선 후 libs"
tags: [nestjs, convention, prisma, repository, database]
stack: nestjs
scope: repository-prisma
relations:
  - id: convention-structure-ownership
    label: related
  - id: convention-naming-convention
    label: related
  - id: convention-code-review
    label: related
---

# Repository와 Prisma

## 한 줄 요약

repository 책임, Prisma query, Prisma schema, migration, generated client 규칙. **DB 조회/저장 로직, Prisma schema, migration을 수정할 때** 읽는다. 목차: [목차](../index.md)

## 목적

이 문서는 repository 책임, Prisma query, Prisma schema, migration 관련 규칙을 정리한다.

## Repository 원칙

- repository는 Prisma 조회/저장과 DB mapping만 담당한다.
- repository 함수 하나에는 하나의 DB 작업 단위만 둔다.
- 여러 DB 작업을 조합하는 흐름은 service/유스케이스에서 드러낸다.
- DB 작업 여러 개가 원자적 상태 전이를 이뤄야 하면 service/유스케이스에서 transaction을 열고 repository 함수에 `tx`를 넘긴다.

## Repository 규칙

- 하나의 repository 함수 안에서 조회, 조건 판단, 생성, 수정, 삭제, 집계를 여러 단계로 조합하지 않는다.
- 하나의 DB 작업 단위는 하나의 의도를 가진 Prisma 호출을 뜻한다.
- 단일 `createMany`, `updateMany`, `deleteMany`, `aggregate`처럼 bulk API 하나로 표현되는 작업은 하나의 단위로 본다.
- `find*`는 조회만 수행한다.
- `create*`는 생성만 수행한다.
- `update*`는 수정만 수행한다.
- `delete*`/`softDelete*`는 삭제 처리만 수행한다.
- `count*`/`aggregate*`는 집계만 수행한다.
- soft delete를 쓰는 model의 일반 조회는 `isDeleted: false`를 명시한다.
- soft delete는 `isDeleted`, `deletedAt`, `deletedBy`를 함께 다룬다.
- 생성/수정 시 `createdBy`, `updatedBy`를 채운다.
- select/include는 API에 필요한 범위로 제한한다.
- status 전이는 현재 상태 조건을 `where`에 포함해 중복 처리와 race condition을 줄인다.
- schema 변경에는 migration/generated client 갱신 필요 여부를 확인하고, AI가 실행할 수 없는 작업은 사용자 handoff로 남긴다.
- repository 함수명에는 DB 작업과 조건이 드러나야 한다(네이밍은 [네이밍 컨벤션](naming-convention.md)).
- generated client는 수동 수정하지 않는다.

## Prisma 명령어 규칙

- AI는 Prisma 관련 명령어를 실행하지 않는다.
- 금지 범위에는 `prisma`, `npx prisma`, `pnpm prisma` 같은 Prisma CLI와 `pnpm run db:*` 같은 package script가 모두 포함된다.
- migration, generate, seed가 필요하면 AI가 실행하지 않고 사용자에게 필요한 작업으로 넘긴다.
- 문서나 PR 설명에는 Prisma 작업을 AI 실행 항목이 아니라 사용자 handoff 항목으로 분리해서 적는다([MR PR 작성 가이드](../operations/mr-pr-guide.md)).
- 필요한 package script가 없으면 새 직접 명령어를 쓰지 말고 script 추가 여부를 먼저 논의한다.

## Prisma schema 규칙

- model 이름은 PascalCase를 사용한다.
- 모든 `DateTime` field에는 `@db.Timestamptz(3)`를 사용한다.
- `createdAt`은 `@default(now())`, `updatedAt`은 `@default(now()) @updatedAt`을 기본으로 한다.
- 일반 도메인 model의 `updatedAt`은 non-nullable로 둔다.
- history/log 성격의 model은 의도적으로 `updatedAt`을 생략할 수 있다.
- 식별자(PK, FK, `createdBy`, `updatedBy`, `deletedBy`)는 **UUID v7**로 통일한다. `BigInt`는 TypeScript에서 다루기 번거로워 쓰지 않는다. `createdBy`, `updatedBy`는 non-nullable로 둔다.
- soft delete를 사용하는 model은 `isDeleted`, `deletedAt`, `deletedBy`를 함께 둔다.
- `isDeleted`는 non-nullable `Boolean`과 `@default(false)`를 사용한다.
- `deletedAt`, `deletedBy`는 nullable로 둔다.
- DB column mapping은 `@map("snake_case")`를 사용한다.
- `id` field에는 불필요한 `@map("id")`를 붙이지 않는다.
- 배열 field의 DB column mapping은 복수형을 사용한다.
- foreign key field의 `@map` 값은 참조 대상 field 이름과 의미가 정확히 대응해야 한다.
- relation 이름은 양방향 field 의미와 일치해야 한다.
- i18n model의 `value` field는 의미와 맞지 않는 column name으로 mapping하지 않는다.
- `status`, enum 성격 등 값이 제한된 문자열 column은 **길이 제한 `@db.VarChar` 대신 `String`(Postgres `text`)로 둔다.** 값 제약은 DB가 아니라 앱 레이어에서 건다. i18n `locale`처럼 코드성 문자열도 동일하다.
- Prisma schema에 `enum`을 정의하지 않는다. 허용 값의 **source of truth는 앱 레이어 enum**이고, `"ACTIVE"`, `"INACTIVE"`처럼 대문자로 정의, 사용한다.
- 앱 enum은 **해당 도메인 모듈 안에 먼저 정의**하고, 여러 모듈이 공유하게 되면 그때 `libs`로 내려보낸다([Structure, Ownership](structure-ownership.md)).
- enum성 column은 `String` + `@map(...)`으로 두고, schema에 허용 값을 주석으로 남긴다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(repository, Prisma)로 통합했다.

## 관련 문서

- [Structure, Ownership](structure-ownership.md)
- [Service, Rule, Policy](service-rule-policy.md)
- [Transaction](transaction.md)
- [네이밍 컨벤션](naming-convention.md)
- [코드 리뷰](code-review.md)
- [MR PR 작성 가이드](../operations/mr-pr-guide.md)
