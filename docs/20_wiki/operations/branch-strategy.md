---
id: operation-branch-strategy
title: 브랜치 전략
aliases: [브랜치 전략]
type: operation
status: active
created_at: 2026-07-07
created_by: 정회석
updated_at: 2026-07-07
updated_by: 정회석
audit_log:
  - action: created
    at: 2026-07-07
    by: 정회석
    note: "프로젝트 유형별 브랜치 전략 이원화 — 인프라 main 단일 트랙, 사내 제품 prod/dev 트랙. dionz-frontend 이슈 #2 ingest"
  - action: modified
    at: 2026-07-07
    by: 정회석
    note: "병합 방식 Squash 후 FF로 통일, 브랜치 보호 표·Rebase 규칙 삭제 등 문서 단순화"
tags: [common, operation, git, branch]
stack: common
scope: branch-strategy
source:
  - https://gitlab.infra.cnai.ai/platform/dionz/frontend/dionz-frontend/-/issues/2 (2026-07-07 기준)
relations:
  - id: operation-commit-convention
    label: related
  - id: operation-mr-pr-guide
    label: related
---

# 브랜치 전략

## 한 줄 요약

프로젝트 유형별 git 브랜치 운영 기준. 인프라·위키 저장소는 **main 단일 트랙**, 사내 제품 프로젝트는 **prod/dev 트랙**을 쓴다. 커밋 메시지·MR 제목은 [[commit-convention]], MR 본문·절차는 [[mr-pr-guide]]를 따른다.

## 트랙 판별

작업 전 저장소가 어느 트랙인지 확인한다.

1. 프로젝트 `AGENTS.md`에 트랙이 명시돼 있으면 그것을 따른다.
2. 없으면 브랜치 목록으로 판별한다 — `prod`·`dev`가 있으면 제품 트랙, `main`만 있으면 단일 트랙.
3. 둘 다 불명확하면 사용자에게 확인한다. 추측으로 진행하지 않는다.

## 단일 트랙 — main (인프라·위키·도구)

frontend-wiki를 포함한 인프라성 저장소의 방식.

- 주요 브랜치는 `main` 하나. protected, 직접 커밋·push 금지.
- 변경은 작업 브랜치 → MR → **squash merge**.
- 릴리즈가 필요한 저장소는 tag로 관리한다 (frontend-wiki는 [[wiki-versioning]]).

## 제품 트랙 — prod/dev (사내 제품 프로젝트)

### 브랜치 구성

| 브랜치      | 용도                                            |
| ----------- | ----------------------------------------------- |
| `prod`      | production 릴리즈 브랜치. 릴리즈 시 version tag |
| `dev`       | 개발 통합 브랜치. **default 브랜치**            |
| `feature/*` | 개별 작업 브랜치. dev에서 분기, dev로 병합      |
| `hotfix/*`  | production 긴급 수정. prod에서 분기, prod로 병합 |

```
feature/* → dev → prod        (기본 흐름)
hotfix/*  → prod              (긴급 수정, dev 미경유)
```

- 기능 추가뿐 아니라 dev 대상 모든 작업에 `feature/*`를 쓴다. 작업 성격은 브랜치명이 아니라 MR 제목의 type으로 구분한다.

### 병합 원칙

모든 병합은 MR 경유. GitLab Merge method는 **Fast-forward merge**(merge commit 없음, 선형 히스토리), 모든 경로를 **Squash 후 Fast-forward**로 통일한다.

| 병합 경로               | 방식                    |
| ------------------- | --------------------- |
| `feature/*` → `dev` | Squash 후 Fast-forward |
| `dev` → `prod`      | Squash 후 Fast-forward |
| `hotfix/*` → `prod` | Squash 후 Fast-forward |

### 릴리즈

1. production 배포 후 prod에 version tag 생성·push.
2. version tag 생성은 실행 직전 사용자에게 반드시 확인한다.

### Hotfix

1. `prod`에서 `hotfix/*` 분기 → 수정·테스트 → `prod`로 MR(squash). MR type은 별도 타입 없이 `fix`.
2. 배포 후 patch tag(`vX.Y.Z+1`).
3. **dev 동기화** — dev를 prod 기준으로 rebase 후 `--force-with-lease` push. 공유 브랜치 히스토리가 바뀌는 유일한 예외라 담당자가 팀 공지 후 수행한다.
4. merge(prod→dev)·cherry-pick으로 대체 금지 — merge commit은 FF 정책을 깨고, cherry-pick은 다른 커밋이 생겨 다음 릴리즈 FF를 막는다.

## 관련 문서

- [[commit-convention]]
- [[mr-pr-guide]]
- [[wiki-versioning]]

## 출처

- dionz-frontend 이슈 #2 「프론트엔드 브랜치 전략(GitLab용)」 — https://gitlab.infra.cnai.ai/platform/dionz/frontend/dionz-frontend/-/issues/2 (2026-07-07 기준)
