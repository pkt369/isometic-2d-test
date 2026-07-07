---
id: operation-log-writing-guide
title: 로그 작성 규칙
aliases: [로그 작성 규칙]
type: operation
status: active
created_at: 2026-07-01
created_by: 정회석
updated_at: 2026-07-02
updated_by: 정회석
last_verified_at: 2026-07-02
last_verified_by: 정회석
audit_log:
  - action: created
    at: 2026-07-01
    by: 정회석
    note: "일 단위 로그 규칙"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "작성자 표기·버전 괄호 형식 도입, 커밋 해시 제거, 압축 기준일 명확화"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "프론트/백엔드 로그 규칙 통일 — 버전 version X.Y.Z 표기, 압축 항목 collapsed 마커 도입"
tags: [common, operation, wiki, log]
stack: common
scope: log-authoring
relations:
  - id: operation-wiki-authoring-guide
    label: related
  - id: operation-wiki-versioning
    label: related
  - id: operation-project-wiki-guide
    label: related
---

# log-writing-guide

## 한 줄 요약

로그의 작성·압축 표준. **하루 단위**로 작업 이력을 쌓고, 날짜 뒤 괄호에 작성자를 남긴다. frontend-wiki의 [20_wiki/log.md](/20_wiki/log.md)와 개별 프로젝트 `docs/worklog.md`([[project-wiki-guide]]) 양쪽에 적용한다. 목차: [[index]]

## 적용 대상

- frontend-wiki의 [20_wiki/log.md](/20_wiki/log.md)
- 개별 프로젝트 `docs/worklog.md`

## 작성 규칙

- **하루 단위로 쌓는다. 한 항목 = 하루.** 최신 날짜가 맨 위.
- **날짜 뒤 괄호에 작성자를 남긴다.** git author 이름 기준, 복수면 쉼표로 나열한다.
- 최대한 간결하게. 무엇을·왜·버전 변화만. 구현 세부는 뺀다.
- 괄호는 작성자에만 쓴다. 그 외 부가설명 괄호는 금지 — 필요하면 쉼표나 마침표로 문장을 잇는다.
- 버전이 바뀌면 항목 끝에 `version X.Y.Z`로 남긴다([[wiki-versioning]]).
- 운영 문서·[20_wiki/index.md](/20_wiki/index.md)가 바뀐 작업은 반드시 남긴다.

형식:

```text
YYYY-MM-DD (작성자1, 작성자2) — 무엇을 왜 했나. version X.Y.Z.
```

예:

```text
2026-07-02 (홍길동) — 경로·링크 표기 표준 신설. version 0.1.1.
```

## 압축 규칙

오래된 항목을 기간 단위로 접어 파일이 길어지지 않게 한다. 압축 기준일은 **오늘**이고, 오늘 항목은 접지 않는다.

- **주간 압축** — 오늘을 제외한 일자 항목이 7일 쌓이면 그 7일을 한 항목으로 접는다.
- **월간 압축** — 같은 논리로, 오늘이 속한 달을 제외한 주간 항목이 한 달치 쌓이면 그 달을 한 항목으로 다시 접는다.
- 접어도 버전 변경과 결정 번복은 남긴다. 나머지는 버린다.
- 접어도 작성자는 전원 표기한다.
- 접은 항목은 `collapsed`로 표시해 원본 일자 항목과 구분한다.

형식:

```text
YYYY.MM.DD ~ YYYY.MM.DD (작성자 전원) · collapsed — 압축 요약. version 범위.
```

## 관련 문서

- [[wiki-authoring-guide]]
- [[wiki-versioning]]
- [[project-wiki-guide]]
