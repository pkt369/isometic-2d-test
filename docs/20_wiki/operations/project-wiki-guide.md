---
id: operation-project-wiki-guide
title: 개별 프로젝트 위키 생성 및 작성 가이드
aliases: [개별 프로젝트 위키 생성 및 작성 가이드]
type: operation
status: active
created_at: 2026-06-24
created_by: 이상협
updated_at: 2026-07-01
updated_by: 이상협
last_verified_at: 2026-07-01
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-06-24
    by: 이상협
    commit: ""
  - action: updated
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "frontmatter 스키마 v2"
tags: [common, convention, wiki, documentation, agent]
stack: common
scope: project-wiki-authoring
relations:
  - id: operation-log-writing-guide
    label: related
  - id: operation-commit-convention
    label: related
  - id: operation-mr-pr-guide
    label: related
  - id: operation-agent-instruction-guide
    label: related
---

# 개별 프로젝트 위키 생성 및 작성 가이드

다른 프로젝트에서 에이전트에게 **맥락 파악용** 위키를 만들게 할 때 따르는 규칙.

> 이 위키(Obsidian) 내부 규칙이 아니라, **소비 프로젝트**에 적용하는 규칙이다.
> 전체 문서화(API 명세, 코드 구조)가 아니라 **코드만 봐서는 모르는 맥락**만 남긴다. 목적은 새 세션의 에이전트가 프로젝트를 빠르게 따라잡는 것.

## 실행 흐름

```mermaid
flowchart TD
    A[작업 시작] --> B{"docs/worklog.md 있나?"}
    B -- 없음 --> C["'개별 위키 만들까요?' 묻기"]
    C --> D{동의?}
    D -- 아니오 --> Z[만들지 않음]
    D -- 예 --> E["worklog.md 생성<br/>(원문 필요 시 raw/)"]
    B -- 있음 --> F[worklog 최신순 읽기]
    E --> G[작업 진행]
    F --> H{맥락 충분?}
    H -- 아니오 --> I[raw 원문 확인]
    H -- 예 --> G
    I --> G
    G --> J{"기록 명령 있음?"}
    J -- 아니오 --> K[기록 안 함]
    J -- 예 --> L["worklog에 한두 줄 추가<br/>(결정은 '왜'까지)"]
```


**핵심 규칙**

- **쓰기는 명령이 있을 때만.** 읽기는 맥락 파악을 위해 자유롭게.
- **자동 생성, 갱신 금지.** 단 위키가 없으면 말없이 넘기지 말고 "만들까요?"라고 **반드시 묻는다.** 공통 위키 연동 직후([에이전트 지침 파일 작성 가이드](agent-instruction-guide.md) 부트스트랩 경우 3)에도 이어서 물어본다.
- 사용자가 거절하면 아무것도 만들거나 고치지 않는다.

## 구조 — raw와 worklog 둘뿐

```
docs/
├── raw/             # (선택) 원문 보관소 — 회의록, 메모, 평면 구조
│   └── 2026-06-24-결제-정책-회의.md
└── worklog.md       # (필수) 누적 작업 로그
```

## worklog.md (필수)

무엇을 했고 **왜 그랬는지**를 시간순으로 누적한다. 프로젝트 위키의 본체다.

- **온디맨드** — 사용자가 요청할 때만 추가. 매 작업 자동 기록 금지.
- 작성, 압축 형식은 [로그 작성 규칙](log-writing-guide.md)를 따른다. backend-wiki의 [작업 이력](../log.md)과 같은 규칙.

## raw/ (선택)

회의록, 메모, 긴 대화 로그처럼 나중에 다시 검증할 원문만 보관한다.

- 수정하지 않는다. 거칠어도 원문성 유지.
- **평면 구조**, 파일명 `YYYY-MM-DD-주제.md`.
- 보안 정보, 토큰, 개인정보 금지. 필요하면 마스킹.

## 관련
[커밋 컨벤션](commit-convention.md), [MR PR 작성 가이드](mr-pr-guide.md)
