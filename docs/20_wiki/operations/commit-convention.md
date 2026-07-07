---
id: operation-commit-convention
title: 커밋 컨벤션
aliases: [커밋 컨벤션]
type: operation
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
    note: "백엔드 예시로 전환, frontmatter 스키마 v2"
tags: [common, convention, git]
stack: common
---

# 커밋 컨벤션

`type(scope): subject` 형식. Udacity Nanodegree 커밋 컨벤션 참고. 백엔드 공통. 목차: [목차](../index.md)

## 구조
```
type(scope): subject

[본문(Body): 선택 — '왜' 변경했는지]
[꼬리말(Footer): 선택]
```

## Type

| type | 용도 | 예 |
|---|---|---|
| **feat** | 새 기능 | `feat(auth): 리프레시 토큰 재발급 엔드포인트 추가` |
| **fix** | 버그 수정 | `fix(user): 이메일 중복 검사 누락 수정` |
| **docs** | 문서, 주석 | `docs(readme): 로컬 실행, 환경변수 세팅 추가` |
| **style** | 포맷/스타일 (로직 변경 없음) | `style(lint): import 정렬` |
| **refactor** | 리팩토링, 리네이밍 (기능 변화 없음) | `refactor(constants): defaultDirection → DEFAULT_DIRECTION` |
| **test** | 테스트 (production 로직 변경 없음) | `test(auth): 로그인 E2E 추가` |
| **chore** | 도구/빌드/패키지 (production 로직 변경 없음) | `chore(build): 빌드 옵션 조정, 의존성 업데이트` |

## 작성 가이드

### Subject
- **반드시 한국어**로 작성. 영어 subject는 이 프로젝트 컨벤션 위반.
- **명사형 어미** 필수: `~추가`, `~수정`, `~제거`, `~개선`, `~변경`
- 동사형(`add`, `fix`, `추가했음`, `수정합니다`) 금지.
- 50자 이내. 마침표 없음.

### Scope
- 변경 도메인, 모듈: `auth`, `user`, `order`, `config`, `payment` 등.
- 생략 가능. 생략 시 `type: subject` 형식.

### Body
- 복잡한 변경일 때만 작성. 한 줄 띄우고 시작.
- **'무엇'보다 '왜'** 변경했는지 설명.

## ❌ / ✅ 예제

### Subject 언어

❌ 영어 subject:
```
feat(auth): add refresh token endpoint
docs: add AGENTS.md with wiki baseline
fix(user): remove duplicate import
```

✅ 한국어 subject:
```
feat(auth): 리프레시 토큰 재발급 엔드포인트 추가
docs: AGENTS.md 추가
fix(user): 중복 import 제거
```

### 어미 형태

❌ 동사형, 서술형:
```
feat(auth): 로그인 API를 만들었습니다
feat(auth): 로그인 API 만들기
feat(auth): add login endpoint
```

✅ 명사형 어미:
```
feat(auth): 로그인 API 추가
feat(auth): 로그인 엔드포인트 제작
```

### Body 작성

❌ '무엇'만 설명:
```
feat(auth): 리프레시 토큰 추가

RefreshTokenService와 JwtAuthGuard를 추가했음.
```

✅ '왜'를 설명:
```
feat(auth): 리프레시 토큰 추가

액세스 토큰 만료 시 재로그인 없이 세션을 유지하기 위함.
```

## 흔한 실수

| 실수 | 올바른 방법 |
|---|---|
| 영어로 subject 작성 | 한국어로 작성 |
| `add`, `update`, `fix` 등 동사형 어미 | `추가`, `수정`, `제거` 명사형 어미 |
| scope에 파일명 전체 기입 | 도메인/모듈명만 (`auth`, `user`) |
| 제목에 마침표 | 마침표 없음 |
| body 없이 복잡한 변경 커밋 | body에 '왜' 변경했는지 작성 |

## 관련
[MR PR 작성 가이드](mr-pr-guide.md), [네이밍 컨벤션](../conventions/naming-convention.md)
