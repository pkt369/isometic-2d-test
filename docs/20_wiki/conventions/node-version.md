---
id: convention-node-version
title: Node 버전
aliases: [Node 버전]
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
    note: "사내 권장 Node 24 LTS 고정, .nvmrc 설정 규칙 신설"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "em dash 기호를 마침표·콜론으로 대체"
tags: [common, convention, node]
stack: common
scope: node-version
relations:
  - id: convention-package-manager
    label: related
    note: "런타임·패키지 매니저 버전 고정은 한 쌍으로 움직인다"
---

# Node 버전

## 한 줄 요약

사내 JS/TS 프로젝트의 권장 Node 버전은 **24 (Active LTS)** 다. 프로젝트마다 `.nvmrc`로 고정하고, 다른 버전이 필요하면 실행 전 사용자에게 확인한다.

## 표준

- 권장 버전은 **Node 24**. Active LTS(Krypton), 2026-07-07 기준 최신 24.18.0.
- 비LTS(홀수·최신 짝수 Current 포함, 예: 25·26)는 기본 사용 금지. 필요하면 사유를 문서로 남긴다.
- 프로젝트 루트에 `.nvmrc`를 두고 메이저만 기재한다:

  ```
  24
  ```

  마이너·패치까지 고정하면 보안 패치 추적이 번거로워지므로 메이저 고정이 기본. 재현성이 중요한 프로젝트만 정확한 버전(예: `24.18.0`)을 기재한다.
- `package.json`의 `engines` 필드를 함께 선언한다:

  ```json
  { "engines": { "node": ">=24" } }
  ```

- 패키지 매니저 버전 고정은 [[package-manager]]의 `packageManager` 필드를 따른다. 런타임과 매니저를 한 쌍으로 고정한다.

## 에이전트 지침 (필수)

1. 새 프로젝트 셋업 시 `.nvmrc`(내용 `24`)와 `engines` 필드를 함께 생성한다.
2. Node 24 외 버전을 설치·사용해야 하는 상황이면 **실행 직전 선택지형으로 확인한다**. 예: `Node 22가 필요합니다. 진행할까요? [24 유지 / 22로 진행]`
3. 기존 프로젝트에 `.nvmrc`·`engines`가 이미 있으면 그 값을 존중한다. 임의로 상향하지 않는다.
4. 프로젝트 `AGENTS.md`가 다른 버전을 명시하면 그 프로젝트 규칙이 우선한다.

## 관련 문서

- [[package-manager]]: pnpm 표준·`packageManager` 필드 고정

## 출처

- Node.js 릴리즈 인덱스: https://nodejs.org/dist/index.json (2026-07-07 기준 24.18.0 / LTS Krypton, 26은 비LTS Current)
- 팀 결정 (2026-07-07): 사내 권장 Node 24 통일
