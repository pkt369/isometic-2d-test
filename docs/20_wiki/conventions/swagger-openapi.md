---
id: convention-swagger-openapi
title: "Swagger / OpenAPI (프론트 OAG 연동)"
aliases: ["Swagger / OpenAPI (프론트 OAG 연동)", swagger-openapi]
type: convention
status: active
created_at: 2026-07-02
created_by: 이상협
updated_at: 2026-07-02
updated_by: 이상협
last_verified_at: 2026-07-02
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "Swagger/OpenAPI(OAG 연동) 컨벤션 신설"
tags: [nestjs, convention, swagger, openapi, api, dto]
stack: nestjs
scope: swagger-openapi
relations:
  - id: convention-structure-ownership
    label: related
  - id: convention-naming-convention
    label: related
  - id: convention-code-review
    label: related
---

# Swagger / OpenAPI (프론트 OAG 연동)

## 한 줄 요약

프론트는 OpenAPI Generator(OAG)로 백엔드 Swagger 스펙에서 API 클라이언트를 생성한다. 즉 **Swagger 스펙이 곧 프론트와의 계약**이므로, DTO와 응답 타입을 명시하고 운용 중 API의 이름은 함부로 바꾸지 않는다. **API를 추가하거나 DTO를 바꿀 때** 읽는다. 목차: [목차](../index.md)

## 목적

백엔드 OpenAPI 스펙이 정확하고 안정적이어야 프론트 OAG 생성 코드가 깨지지 않는다. 그 기준을 정리한다.

## 왜 "계약"인가

- 프론트는 백엔드 OpenAPI 스펙을 OAG로 돌려 **모델 타입과 API 호출 함수를 생성**해 쓴다.
- 생성물의 이름은 **DTO 클래스명**(→ 모델 타입명, 생성 파일명)과 **operationId**(→ API 함수명, 보통 컨트롤러 메서드명 기반)에서 나온다.
- 따라서 스펙이 바뀌면 프론트는 재생성해야 하고, **이름이 바뀌면 프론트 생성 코드가 깨진다.**

## 원칙

- 모든 요청/응답은 **명시적 DTO 클래스**로 표현한다. inline object 타입을 스펙에 노출하지 않는다.
- 컨트롤러 메서드는 **응답 타입을 명시**한다.
- **운용 중 API는 DTO 클래스명과 operationId(메서드명)를 바꾸지 않는다.** 필드 추가(optional)는 안전하고, 제거/이름 변경/타입 변경은 breaking이다.

## 규칙

- request는 body/query/param마다 DTO 클래스를 둔다. `class-validator` + `@ApiProperty`로 필드, 타입, 필수 여부를 명시한다(컨트롤러 경계는 [Structure, Ownership](structure-ownership.md)).
- response는 `@ApiOkResponse({ type: XxxResponseDto })`(또는 반환 타입 + swagger plugin)로 명시한다. 배열은 `type: [Dto]` 또는 `isArray: true`.
- `@ApiProperty`에 `enum`, `nullable`, `required`, `example`을 실제와 맞게 단다. OAG가 정확한 타입을 생성하도록.
- optional 필드는 `@ApiPropertyOptional`(또는 `required: false`) + `field?: T`로 표현한다.
- `@ApiTags`로 컨트롤러를 그룹핑한다(OAG의 API 클래스 분리에 영향).
- operationId가 흔들리지 않게 컨트롤러 메서드명을 안정적으로 유지한다. 필요하면 `@ApiOperation({ operationId })`로 고정한다.
- 에러 응답도 필요한 범위에서 `@ApiResponse`로 명시한다(프론트 에러 처리).
- DTO 클래스명은 명확하고 안정적으로 짓는다([네이밍 컨벤션](naming-convention.md)). 한번 나간 이름은 계약으로 본다.

## 운용 중 API 변경 — 호환성

| 변경 | 호환성 |
|---|---|
| optional 필드 추가 | 안전 (additive) |
| 새 엔드포인트 추가 | 안전 |
| 필드 제거 | breaking |
| 필드 타입 변경 | breaking |
| optional → required 승격 | breaking |
| DTO 클래스명 변경 | breaking (프론트 모델 타입, 파일명 변경) |
| 컨트롤러 메서드명 / operationId 변경 | breaking (프론트 API 함수명 변경) |
| enum 값 추가 | 프론트 대응 필요 (대체로 안전) |
| enum 값 제거 / 변경 | breaking |

- breaking이 불가피하면 기존 것을 유지(deprecate)한 채 새 필드/엔드포인트로 추가하거나 API 버저닝으로 처리한다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(Swagger, OpenAPI)로 통합했다.

## 관련 문서

- [Structure, Ownership](structure-ownership.md)
- [네이밍 컨벤션](naming-convention.md)
- [코드 리뷰](code-review.md)