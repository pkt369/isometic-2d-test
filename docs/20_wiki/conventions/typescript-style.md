---
id: convention-typescript-style
title: TypeScript Style
aliases: [TypeScript Style]
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
    note: "TypeScript 타입, lint/style 컨벤션 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "strict를 처음부터 적용으로 변경(이전 세션), 기준 설정 리드인 문구 정리"
tags: [nestjs, convention, typescript, eslint, prettier]
stack: nestjs
scope: typescript-style
relations:
  - id: convention-naming-convention
    label: related
  - id: convention-code-review
    label: related
---

# TypeScript Style

## 한 줄 요약

TypeScript 타입 선언, interface/type 분리, lint/style 적용 기준. **strict를 적용**한다. **타입을 추가하거나 함수 signature를 바꾸거나 lint/style 기준을 검토할 때** 읽는다. 목차: [목차](../index.md)

## 목적

이 문서는 TypeScript 타입 선언, interface/type 분리, lint/style 적용 기준을 정리한다.

## 원칙

- **strict를 적용한다.** 아래 컴파일러 옵션을 기준 설정으로 둔다.
- implicit any를 만들지 않는다.
- `any`는 쓰지 않는다. 불가피하면 리뷰에서 사유를 남기고 최소 범위로 격리한다.
- Prettier 설정은 팀 합의 없이 바꾸지 않는다.

## 기준 설정 (strict)

`tsconfig`에 아래 옵션을 기본으로 둔다.

```jsonc
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
  },
}
```

## 규칙

- 외부 payload는 `unknown`, `Record<string, unknown>`, domain type 중 하나로 감싼다.
- trivial type은 inference를 허용한다.
- public 함수, repository 함수, 복잡한 async 결과는 반환 타입을 명시한다.
- optional field는 `field?: T`를 우선한다.
- null/undefined는 발생 지점 가까이에서 처리한다.
- 과도한 interface/type 선언을 만들지 않는다.
- parameter나 반환 타입에 inline object type으로 충분히 명시할 수 있으면 별도 type/interface를 만들지 않는다.
- 같은 구조가 여러 함수에서 반복되거나 도메인 개념으로 이름이 필요할 때만 type/interface를 분리한다.
- 분리한 type/interface 이름은 데이터 모양이 아니라 역할을 설명해야 한다([네이밍 컨벤션](naming-convention.md)).
- `no-floating-promises`는 `error`로 강제한다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(타입)로 통합했다.

## 관련 문서

- [네이밍 컨벤션](naming-convention.md)
- [코드 리뷰](code-review.md)