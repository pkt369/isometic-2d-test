---
id: convention-husky-git-hooks
title: "Husky (git hooks)"
aliases: ["Husky (git hooks)", husky-git-hooks]
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
    note: "Husky git hooks 셋업 컨벤션 신설"
tags: [nestjs, convention, husky, git, lint, setup]
stack: nestjs
scope: husky-git-hooks
relations:
  - id: convention-eslint-prettier-mise
    label: related
  - id: operation-commit-convention
    label: related
  - id: convention-code-review
    label: related
---

# Husky (git hooks)

## 한 줄 요약

커밋, 푸시 전에 lint, format, 커밋 메시지 검사를 git hook으로 자동 실행해 문제를 미리 거른다. Husky + lint-staged 조합. **프로젝트에 pre-commit 검사를 세팅할 때** 읽는다. 목차: [목차](../index.md)

## 목적

git에 올리기 전에 lint/format을 강제해 규칙 위반이 저장소에 들어오는 걸 1차로 막는다.

## 도구 조합

- **husky** — git hooks 관리.
- **lint-staged** — staged 파일만 골라 lint/format(전체 대신 변경분만 검사해 빠르다).
- (선택) **commitlint** — commit-msg 형식 검사.

## 셋업

```bash
npm i -D husky lint-staged
npx husky init   # .husky/ 생성, pre-commit 훅 스캐폴딩 (husky 9+ 기준)
```

pre-commit 훅(`.husky/pre-commit`):

```sh
npx lint-staged
```

lint-staged 설정(`package.json` 또는 `.lintstagedrc`):

```json
{
  "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
  "*.{json,md,yml,yaml}": ["prettier --write"]
}
```

- husky 버전에 따라 셋업 방식(예: `husky init`, 훅 파일 형식)이 다르니 [context7 사용 가이드](../operations/context7-instruction-guide.md)나 공식 문서로 확인한다.

## 원칙

- **pre-commit은 빠르게** — staged 파일만(lint-staged) 검사한다. 전체 테스트, 타입체크 같은 무거운 검사는 넣지 않는다.
- 무거운 검사(전체 test, `tsc --noEmit`)는 **pre-push**나 **CI**에 둔다.
- hook은 `--no-verify`로 우회할 수 있으므로 **최종 방어선은 CI**다. hook은 빠른 1차 거름망일 뿐이다.
- hook이 실행하는 규칙은 [ESLint, Prettier, mise 설정](eslint-prettier-mise.md)(lint/format)를 따르고, 커밋 메시지는 [커밋 컨벤션](../operations/commit-convention.md)을 따른다.

## commit-msg (선택)

- commitlint로 `type(scope): subject` 구조를 검사할 수 있다.
- 단 이 프로젝트의 한국어, 명사형 어미 규칙([커밋 컨벤션](../operations/commit-convention.md))은 commitlint 기본 규칙으로 다 잡히지 않는다. 구조만 강제하고 나머지는 리뷰로 본다.

## AI 리뷰 체크 포인트

이 컨벤션의 리뷰 확인 항목은 [코드 리뷰](code-review.md)의 "도메인별 리뷰 체크 포인트"(git hooks)로 통합했다.

## 관련 문서

- [ESLint, Prettier, mise 설정](eslint-prettier-mise.md)
- [커밋 컨벤션](../operations/commit-convention.md)
- [코드 리뷰](code-review.md)

## 출처

- Husky, lint-staged 공식 문서, 기준일 2026-07-02
