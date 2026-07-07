---
id: convention-eslint-prettier-mise
title: "ESLint, Prettier, mise 설정"
aliases: ["ESLint, Prettier, mise 설정"]
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
    note: "ESLint, Prettier, mise 기본 설정 문서 신설"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "base를 recommendedTypeChecked로, 비동기 안전, 코드 위생, unsafe 계열 등 베스트 프랙티스 규칙 추가. no-floating-promises error 통일"
tags: [nestjs, convention, eslint, prettier, mise, setup]
stack: nestjs
scope: eslint-prettier-mise
relations:
  - id: convention-typescript-style
    label: related
  - id: convention-code-review
    label: related
---

# ESLint, Prettier, mise 설정

## 한 줄 요약

프로젝트 셋업 시 그대로 가져가는 lint, format, Node 버전 기본 설정. **새 프로젝트를 세팅하거나 lint/format/Node 버전 기준을 맞출 때** 읽는다. 코드 스타일 판단 기준은 [TypeScript Style](typescript-style.md). 목차: [목차](../index.md)

## 목적

ESLint, Prettier, mise(Node 버전) 기본 설정을 한곳에 모아, 프로젝트마다 같은 설정으로 시작하게 한다.

## Node, pnpm, Python 버전 — mise

- Node, 패키지 매니저(pnpm), Python을 `mise`로 함께 고정해 팀, CI가 같은 버전을 쓴다. `.mise.toml`을 저장소에 커밋한다.
- Node는 **24**로 고정한다. pnpm도 mise로 관리하므로 corepack은 쓰지 않는다.
- Python은 **3.12**로 고정한다(code-review-graph 같은 도구 실행에 필요, [코드 리뷰](code-review.md)).

```toml
# .mise.toml
[tools]
node = "24"
pnpm = "latest"   # 팀에서 쓰는 버전으로 고정 권장(예: "10")
python = "3.12"
```

- `mise install`로 Node, pnpm, Python을 설치하고, `.mise.toml`이 있으면 디렉터리 진입 시 자동 적용된다.

## Prettier

`.prettierrc`(또는 `.prettierrc.json`):

```json
{
  "singleQuote": true,
  "trailingComma": "all",
  "tabWidth": 2,
  "printWidth": 120
}
```

## ESLint

ESLint는 flat config(`eslint.config.mjs`)를 쓴다. **베스트 프랙티스의 핵심은 base로 무엇을 extend하냐**다. 타입 인지(type-aware) 규칙까지 켜는 `typescript-eslint`의 `recommendedTypeChecked`를 base로 두고, 그 위에 아래 규칙을 얹는다.

```js
// eslint.config.mjs (요지)
import tseslint from 'typescript-eslint';
import eslintConfigPrettier from 'eslint-config-prettier';

export default tseslint.config(
  ...tseslint.configs.recommendedTypeChecked, // 타입 인지 규칙 base
  eslintConfigPrettier,                        // 포맷 관련 규칙 off
  {
    languageOptions: {
      parserOptions: { projectService: true }, // 타입 인지 규칙에 필요
    },
    rules: {
      // 프로젝트 기존 결정
      '@typescript-eslint/no-explicit-any': 'off',
      '@typescript-eslint/no-floating-promises': 'error',
      'prettier/prettier': ['error', { endOfLine: 'auto' }],

      // 비동기 안전 (floating-promises와 한 쌍)
      '@typescript-eslint/no-misused-promises': 'error',
      '@typescript-eslint/await-thenable': 'error',
      '@typescript-eslint/return-await': ['error', 'in-try-catch'],

      // 코드 위생
      'prefer-const': 'error',
      'no-var': 'error',
      eqeqeq: ['error', 'smart'],
      'no-console': 'warn', // 백엔드는 Logger 사용
      '@typescript-eslint/no-unused-vars': ['warn', { argsIgnorePattern: '^_', varsIgnorePattern: '^_' }],
      '@typescript-eslint/consistent-type-imports': 'error',

      // any를 off로 둔 만큼 unsafe 계열은 error가 아니라 warn으로 (소음 억제)
      '@typescript-eslint/no-unsafe-argument': 'warn',
      '@typescript-eslint/no-unsafe-assignment': 'warn',
      '@typescript-eslint/no-unsafe-member-access': 'warn',
      '@typescript-eslint/no-unsafe-call': 'warn',
      '@typescript-eslint/no-unsafe-return': 'warn',
    },
  },
);
```

규칙 의도:

- **base** — `recommendedTypeChecked`가 타입 정보를 활용한 정확한 검사(비동기, 타입 오용 등)를 켠다. 이게 실질적 베스트 프랙티스의 뼈대다.
- **비동기 안전** — `no-misused-promises`(async를 잘못 쓴 자리 탐지)는 `no-floating-promises`와 짝으로 백엔드 버그를 크게 줄인다. `await-thenable`, `return-await`도 같은 맥락.
- **코드 위생** — `prefer-const`, `no-var`, `eqeqeq`, `no-console`(Logger 사용), `no-unused-vars`(`_` 접두 무시), `consistent-type-imports`(타입은 `import type`).
- **unsafe 계열** — `any`를 `off`로 두면 `recommendedTypeChecked`의 `no-unsafe-*`가 error로 쏟아지므로 `warn`으로 낮춰 소음을 줄인다. `any`는 리뷰로 통제([TypeScript Style](typescript-style.md)).

- `prettier/prettier`는 `eslint-plugin-prettier`, 포맷 충돌 제거는 `eslint-config-prettier`가 필요하다.
- 위 규칙 이름, 기본 severity는 typescript-eslint 버전에 따라 다를 수 있으니 [context7 사용 가이드](../operations/context7-instruction-guide.md)로 확인한다.

## 버전 관리

- 패키지(eslint, typescript-eslint, prettier, eslint-plugin-prettier, eslint-config-prettier)는 **서로 호환되는 릴리즈 버전**으로 맞춘다.
- 정확한 버전은 위키에 박지 않는다. 설치 시점 최신 릴리즈와 호환 매트릭스는 [context7 사용 가이드](../operations/context7-instruction-guide.md)나 공식 문서로 확인한다([목차](../index.md) 범위 규칙).
- 현재 세대 기준: ESLint 9(flat config), typescript-eslint 8, Prettier 3. `[검증 필요]`

## 셋업 절차

1. `mise`로 Node(24), pnpm, Python(3.12) 버전을 고정하고 `.mise.toml`을 커밋한다.
2. lint/format 패키지를 설치 시점 최신 호환 버전으로 설치한다.
3. `.prettierrc`, `eslint.config.mjs`를 위 기본값으로 생성한다.
4. `package.json`에 `lint`, `format` script를 추가한다.

## 관련 문서

- [TypeScript Style](typescript-style.md)
- [코드 리뷰](code-review.md)