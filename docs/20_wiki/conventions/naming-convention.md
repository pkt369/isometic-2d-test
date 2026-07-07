---
id: convention-naming-convention
title: 네이밍 컨벤션
aliases: [네이밍 컨벤션]
type: convention
status: active
created_at: 2026-06-19
created_by: 정회석
updated_at: 2026-07-02
updated_by: 정회석
audit_log:
  - action: created
    at: 2026-06-19
    by: 정회석
  - action: updated
    at: 2026-07-02
    by: 정회석
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "relations 단방향 정리"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "삭제된 fsd 문서 링크 제거"
tags: [common, convention, naming]
stack: common
scope: naming
relations: []
---

# 네이밍 컨벤션

파일·디렉토리·식별자 명명 규칙. 웹·앱 공통.

## 1. 파일·디렉토리 — kebab-case
```
✅ use-auth-store.ts   user-profile/   settings-form.tsx   user-card.test.tsx
❌ UserProfile.tsx   useAuthStore.ts   user_profile/   SettingsForm.tsx
```
예외 (도구·프레임워크 강제):
- Expo/Next Router 동적 라우트: `[id].tsx`, `[...slug].tsx`
- 라우트 그룹: `(tabs)/`, `(auth)/`
- 설정 파일: `tsconfig.json`, `biome.json` 등

## 2. 내부 식별자

| 종류 | 규칙 | 예 |
|---|---|---|
| 컴포넌트 | PascalCase | `UserProfile` |
| 훅 | camelCase + `use` | `useAuthStore`, `useTheme` |
| 함수 | camelCase | `fetchUser`, `formatDate` |
| 변수 | camelCase | `currentUser`, `isLoading` |
| 상수 | UPPER_SNAKE_CASE | `DEFAULT_PAGE_SIZE` |
| 타입/인터페이스 | PascalCase | `ApiResponse`, `UserState` |
| 제네릭 | PascalCase, 한 글자 또는 `T`접두 | `T`, `TPayload` |
| enum 멤버 | PascalCase | `UserRole.Admin` |
| store (zustand) | camelCase + `Store` | `authStore` |
| 이벤트 핸들러 | `handle*` / `on*` | `handleSubmit`, `onPress` |
| boolean | `is/has/should/can` | `isReady`, `hasError` |

## 3. 파일 ↔ export 매핑
파일은 kebab-case, export는 PascalCase/camelCase로 변환.
```ts
// user-profile.tsx     → export function UserProfile()
// use-auth-store.ts    → export function useAuthStore()
// default-page-size.ts → export const DEFAULT_PAGE_SIZE = 20
```

## 4. 약어 처리
약어도 PascalCase. 전부 대문자 금지 (경계 모호 방지).
```
✅ ApiClient   useApiClient   HtmlParser   UuidGenerator
❌ APIClient   useAPIClient   HTMLParser   UUIDGenerator
```

## 5. 테스트·플랫폼 파일
```
user-profile.test.tsx     # 유닛
user-profile.e2e.ts       # E2E
user-profile.stories.tsx  # 스토리북
component.ios.tsx / .android.tsx / .web.tsx   # RN 플랫폼별
config.dev.ts / config.prod.ts                # 환경별
```

## 6. 자동 검증 (Biome 예)
```jsonc
{ "linter": { "rules": { "style": {
  "useFilenamingConvention": { "level": "error",
    "options": { "filenameCases": ["kebab-case"] } },
  "useNamingConvention": "error"
}}}}
```

## 관련
[[code-review]] · [[index]]
