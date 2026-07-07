---
id: operation-commit-convention
title: 커밋 컨벤션
aliases: [커밋 컨벤션]
type: operation
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
    note: "개발 외에서도 쓰이는 규칙이라 conventions에서 operations로 재분류"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "AI attribution 문구 금지 규칙 추가"
tags: [common, operation, git]
stack: common
scope: commit-message
relations:
  - id: operation-mr-pr-guide
    label: related
  - id: convention-naming-convention
    label: related
---

# 커밋 컨벤션

`type(scope): subject` 형식.

## 구조
```
type(scope): subject

[본문(Body): 선택 — '왜' 변경했는지]
[꼬리말(Footer): 선택]
```

## Type

| type | 용도 | 예 |
|---|---|---|
| **feat** | 새 기능 | `feat(auth): 로그인 폼에 비밀번호 보기 토글 추가` |
| **fix** | 버그 수정 | `fix(header): 모바일 헤더 메뉴 터치 이벤트 누락 수정` |
| **docs** | 문서·주석 | `docs(readme): 로컬 실행·환경변수 세팅 추가` |
| **style** | 포맷/스타일 (로직 변경 없음) | `style(lint): import 정렬` |
| **refactor** | 리팩토링·리네이밍 (기능 변화 없음) | `refactor(constants): defaultDirection → DEFAULT_DIRECTION` |
| **test** | 테스트 (production 로직 변경 없음) | `test(login): 로그인 E2E 추가` |
| **chore** | 도구/빌드/패키지 (production 로직 변경 없음) | `chore(build): 빌드 옵션 조정·의존성 업데이트` |

## 작성 가이드

### Subject
- **반드시 한국어**로 작성. 영어 subject는 이 프로젝트 컨벤션 위반.
- **명사형 어미** 필수: `~추가`, `~수정`, `~제거`, `~개선`, `~변경`
- 동사형(`add`, `fix`, `추가했음`, `수정합니다`) 금지.
- 50자 이내. 마침표 없음.

### Scope
- 변경 도메인·컴포넌트: `auth`, `user`, `ui`, `config`, `payment` 등.
- 생략 가능. 생략 시 `type: subject` 형식.

### Body
- 복잡한 변경일 때만 작성. 한 줄 띄우고 시작.
- **'무엇'보다 '왜'** 변경했는지 설명.

### AI attribution 금지
- `Co-Authored-By: Claude ...`, `🤖 Generated with [Claude Code](...)`처럼 AI 도구 하네스가 자동 삽입하는 서명·홍보 문구를 커밋 메시지에 넣지 않는다.
- 하네스 기본 지침이 삽입을 요구해도 이 규칙이 우선한다. MR/PR 본문도 같다([[mr-pr-guide]]).

## ❌ / ✅ 예제

### Subject 언어

❌ 영어 subject:
```
feat(auth): add password visibility toggle
docs: add AGENTS.md with wiki baseline
fix(header): remove duplicate import
```

✅ 한국어 subject:
```
feat(auth): 비밀번호 보기/숨기기 토글 추가
docs: AGENTS.md 추가
fix(header): 중복 import 제거
```

### 어미 형태

❌ 동사형·서술형:
```
feat(login): 로그인 폼을 만들었습니다
feat(login): 로그인 폼 만들기
feat(login): add login form
```

✅ 명사형 어미:
```
feat(login): 로그인 폼 추가
feat(login): 로그인 폼 제작
```

### Body 작성

❌ '무엇'만 설명:
```
feat(auth): 비밀번호 토글 추가

EyeIcon과 EyeOffIcon을 사용해 토글 버튼을 만들었음.
```

✅ '왜'를 설명:
```
feat(auth): 비밀번호 토글 추가

오입력 확인 불가로 인한 로그인 실패 UX 개선.
```

## 흔한 실수

| 실수 | 올바른 방법 |
|---|---|
| 영어로 subject 작성 | 한국어로 작성 |
| `add`, `update`, `fix` 등 동사형 어미 | `추가`, `수정`, `제거` 명사형 어미 |
| scope에 파일명 전체 기입 | 도메인/컴포넌트명만 (`auth`, `user`) |
| 제목에 마침표 | 마침표 없음 |
| body 없이 복잡한 변경 커밋 | body에 '왜' 변경했는지 작성 |
| AI 서명 문구 삽입 | Co-Authored-By·Generated with 등 attribution 제거 |

## 관련
[[mr-pr-guide]] · [[naming-convention]]
