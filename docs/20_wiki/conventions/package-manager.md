---
id: convention-package-manager
title: 패키지 매니저
aliases: [패키지 매니저]
type: convention
status: active
created_at: 2026-07-07
created_by: 정회석
updated_at: 2026-07-07
updated_by: 정회석
audit_log:
  - action: created
    at: 2026-07-07
    by: 정회석
    note: "사내 표준 pnpm 고정, npm·yarn 시도 시 실행 직전 확인 규칙 신설"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "em dash 기호를 쉼표·콜론으로 대체"
tags: [common, convention, package-manager, pnpm]
stack: common
scope: package-manager
relations: []
---

# 패키지 매니저

## 한 줄 요약

사내 JS/TS 프로젝트의 표준 패키지 매니저는 **pnpm 최신 안정 버전** 하나다. npm·yarn 명령은 실행 직전 사용자에게 확인 없이 쓰지 않는다.

## 표준

- 설치·실행·스크립트 전부 pnpm 기준: `pnpm install`·`pnpm add`·`pnpm dlx`.
- 최신 안정 버전을 쓴다 (2026-07-07 기준 11.10.0, 정확한 최신값은 registry로 재확인).
- 신규 프로젝트는 `package.json`의 `packageManager` 필드로 버전을 고정한다 (corepack 연동).
- lockfile은 `pnpm-lock.yaml`만 커밋한다. `package-lock.json`·`yarn.lock`은 커밋 금지.

## 에이전트 지침 (필수)

1. 의존성 설치·추가·스크립트 실행의 기본값은 pnpm. 명령 예시를 보여줄 때도 pnpm 기준으로 쓴다.
2. npm·yarn 명령을 실행해야 하는 상황(사용자 요청 포함)이면 **실행 직전 선택지형으로 확인한다**. 예: `npm으로 진행할까요? [pnpm으로 전환 / npm 그대로 진행]`
3. 기존 프로젝트에서 `package-lock.json`·`yarn.lock`을 발견하면 pnpm 전환 여부를 먼저 묻는다. 임의로 lockfile을 삭제·변환하지 않는다.
4. 프로젝트 `AGENTS.md`가 다른 매니저를 명시하면 그 프로젝트 규칙이 우선한다.

## 명령 대응표

| 용도 | pnpm |
| --- | --- |
| 의존성 설치 | `pnpm install` |
| 패키지 추가 | `pnpm add <pkg>` (`-D` 개발 의존성) |
| 패키지 제거 | `pnpm remove <pkg>` |
| 스크립트 실행 | `pnpm run <script>` 또는 `pnpm <script>` |
| 일회성 실행 (npx 대응) | `pnpm dlx <pkg>` |

## 관련 문서

- [[agent-instruction-guide]]: 프로젝트 `AGENTS.md` 템플릿에 매니저 명시 위치

## 출처

- 팀 결정 (2026-07-07): 사내 전 프로젝트 pnpm 통일
- pnpm 최신 버전: https://registry.npmjs.org/pnpm/latest (2026-07-07 기준 11.10.0)
