---
id: operation-wiki-sync
title: 위키 동기화
aliases: [위키 동기화]
type: operation
status: active
created_at: 2026-06-30
created_by: 이상협
updated_at: 2026-07-01
updated_by: 이상협
last_verified_at: 2026-07-01
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-06-30
    by: 이상협
    commit: ""
  - action: updated
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "frontmatter 스키마 v2"
tags: [common, convention, wiki, sync]
stack: common
scope: wiki-sync
---

# 위키 동기화

로컬 위키와 원격(`origin/main`)을 최신 상태로 맞추는 기준. 버전 올리는 기준, 절차는 [위키 버전 관리](wiki-versioning.md).

## 원격 버전 동기화

위키를 읽거나 버전 작업을 하기 전, GitLab Release 최신 tag와 [목차](../index.md)의 `version`이 같은지 확인한다. tag는 `vX.Y.Z`, version은 `X.Y.Z`이므로 `v${version}`으로 맞춰 본다.

불일치 시 먼저 원격을 최신화한다.

```sh
git fetch origin main --tags
```

`origin/main`의 [목차](../index.md)가 더 최신이면 작업 전 갱신한다.

```sh
git pull --ff-only origin main
```

로컬 변경이 있거나 fast-forward가 안 되면 **임의로 reset/rebase하지 않는다.** 현재 `index.version`, GitLab Release tag, `origin/main`의 `index.version`을 확인해 동기화 필요 상태를 사용자에게 먼저 보고한다.

## 관련 문서

- [목차](../index.md)
- [위키 버전 관리](wiki-versioning.md)
