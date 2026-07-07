---
id: convention-naming-convention
title: 네이밍 컨벤션
aliases: [네이밍 컨벤션]
type: convention
status: active
created_at: 2026-06-19
created_by: 이상협
updated_at: 2026-07-01
updated_by: 이상협
last_verified_at: 2026-07-01
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-06-19
    by: 이상협
    commit: ""
  - action: updated
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "NestJS 표준으로 전면 재작성, frontmatter 스키마 v2"
tags: [nestjs, convention, naming]
stack: nestjs
---

# 네이밍 컨벤션

파일, 디렉토리, 식별자 명명 규칙. NestJS 기준. 목차: [목차](../index.md)

## 1. 파일, 디렉토리 — kebab-case + 역할 접미사

NestJS는 파일 역할을 `.` 접미사로 드러낸다. 여러 단어는 kebab-case로 잇고, `nest g`가 만드는 이름을 기준으로 삼는다.
```
✅ users.controller.ts   users.service.ts   create-user.dto.ts   jwt-auth.guard.ts
❌ UsersController.ts     users_service.ts   createUserDto.ts     JwtAuthGuard.ts
```

| 역할 | 접미사 | 예 |
|---|---|---|
| 컨트롤러 | `.controller.ts` | `users.controller.ts` |
| 서비스, 프로바이더 | `.service.ts` | `users.service.ts` |
| 모듈 | `.module.ts` | `users.module.ts` |
| DTO | `.dto.ts` | `create-user.dto.ts`, `update-user.dto.ts` |
| 가드 | `.guard.ts` | `jwt-auth.guard.ts`, `roles.guard.ts` |
| 인터셉터 | `.interceptor.ts` | `logging.interceptor.ts` |
| 예외 필터 | `.filter.ts` | `http-exception.filter.ts` |
| 파이프 | `.pipe.ts` | `parse-object-id.pipe.ts` |
| 데코레이터 | `.decorator.ts` | `current-user.decorator.ts` |
| 미들웨어 | `.middleware.ts` | `logger.middleware.ts` |

- 디렉토리는 도메인, 모듈 단위 kebab-case: `users/`, `auth/`, `orders/`.
- 영속 모델은 Prisma가 `prisma/schema.prisma` 한 곳에서 관리한다. 모델명은 PascalCase(`User`, `Order`)이고, 별도 `.entity.ts` 파일은 두지 않는다(생성된 `@prisma/client` 타입을 그대로 쓴다).
- 설정 파일 예외(도구 강제): `nest-cli.json`, `tsconfig.json`, `.eslintrc.js` 등.

## 2. 내부 식별자

| 종류 | 규칙 | 예 |
|---|---|---|
| 클래스 (역할 접미사) | PascalCase | `UsersController`, `UsersService`, `UsersModule` |
| DTO 클래스 | PascalCase + `Dto` | `CreateUserDto`, `UpdateUserDto` |
| 메서드 | camelCase | `findAll`, `findOne`, `create`, `remove` |
| 함수 | camelCase | `hashPassword`, `formatDate` |
| 변수 | camelCase | `currentUser`, `isActive` |
| 상수 | UPPER_SNAKE_CASE | `DEFAULT_PAGE_SIZE` |
| 타입/인터페이스 | PascalCase | `JwtPayload`, `PaginatedResult` |
| 제네릭 | PascalCase, 한 글자 또는 `T`접두 | `T`, `TPayload` |
| enum 멤버 | PascalCase | `UserRole.Admin` |
| 주입 토큰(injection token) | UPPER_SNAKE_CASE | `'USER_REPOSITORY'`, `CACHE_MANAGER` |
| 환경변수 | UPPER_SNAKE_CASE | `DATABASE_URL`, `JWT_SECRET` |
| boolean | `is/has/should/can` | `isActive`, `hasRole` |

## 3. 파일 ↔ export 매핑
파일은 kebab-case + 역할 접미사, export 클래스는 PascalCase + 같은 역할 접미사.
```ts
// users.controller.ts   → export class UsersController {}
// users.service.ts      → export class UsersService {}
// create-user.dto.ts    → export class CreateUserDto {}
// jwt-auth.guard.ts      → export class JwtAuthGuard {}
```
한 파일에 프로바이더 하나가 기본. 여러 개면 역할이 같은 것만 묶는다.

## 4. 약어 처리
약어도 PascalCase. 전부 대문자 금지 (경계 모호 방지).
```
✅ JwtService   HttpModule   DtoValidator   UuidPipe
❌ JWTService   HTTPModule   DTOValidator   UUIDPipe
```
NestJS 내장 클래스(`HttpService`, `JwtService`)가 이미 이 규칙을 따른다.

## 5. 테스트, 환경 파일
```
users.service.spec.ts     # 유닛 (Jest 기본)
users.e2e-spec.ts         # E2E (test/ 디렉토리)
config.schema.ts          # 환경변수 스키마
main.ts                   # 부트스트랩 진입점
```

## 6. 자동 검증 (ESLint 예)
NestJS 기본 스캐폴딩은 ESLint + Prettier. 식별자 규칙은 `@typescript-eslint/naming-convention`으로 강제한다.
```jsonc
{
  "@typescript-eslint/naming-convention": [
    "error",
    { "selector": "class", "format": ["PascalCase"] },
    { "selector": "variable", "format": ["camelCase", "UPPER_CASE"] },
    { "selector": "typeLike", "format": ["PascalCase"] },
    { "selector": "enumMember", "format": ["PascalCase"] }
  ]
}
```
파일명 규칙(kebab-case + 역할 접미사)은 `nest g <schematic>` 스캐폴딩을 기준으로 유지한다.

## 관련
[목차](../index.md)
