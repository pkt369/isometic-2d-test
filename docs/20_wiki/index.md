---
id: index-index
title: 목차
aliases: [목차]
type: index
status: active
version: "0.24.1"
created_at: 2026-06-19
created_by: 정회석
updated_at: 2026-07-07
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
    note: "relations 단방향 정리"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "context7 필수 단계 추가, 10_raw·fsd 제거"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "필수 작업 순서를 문서 최상단으로 재배치, 상세는 operations 문서 링크로 위임"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "AGENTS 슬림화 버전 반영"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "시작 전 필수에서 에이전트 전용 확인 명령 제거 — 에이전트 중립 지침으로"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "context7 가이드 오타 정정 반영 — version 0.21.6"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "im-not-ai 윤문 sweep·wiki-versioning 번호 정정 — version 0.21.7"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "agent-instruction-guide 도구 활용 절·@AGENTS.md 포인터 반영 — version 0.21.8"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "루트 CLAUDE.md를 @AGENTS.md 한 줄 포인터로 교체 — version 0.21.9"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "commit-convention·mr-pr-guide에 AI attribution 문구 금지 추가 — version 0.21.10"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "AGENTS 템플릿에 작업 기록·MR/PR 필수 절 신설, worklog 온디맨드를 작업 완료 시 기재로 개정 — version 0.22.0"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "branch-strategy 신설 — 인프라 main 단일·사내 제품 prod/dev 트랙 이원화, 목차 등록"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "package-manager 신설 — 사내 표준 pnpm, npm·yarn 확인 규칙, 목차 등록 — version 0.23.0"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "node-version 신설 — 권장 Node 24 LTS·.nvmrc 고정, 목차 등록 — version 0.24.0"
  - action: updated
    at: 2026-07-07
    by: 정회석
    note: "package-manager·node-version em dash 표기 정리 — version 0.24.1"
tags: [wiki, index]
stack: common
scope: wiki-index
relations: []
---

# frontend-wiki

유일한 진입점. 모든 작업·질문 전에 아래 필수 작업을 **순서대로** 끝낸 뒤 목차로 넘어간다.

## 시작 전 필수 (순서대로)

1. **원격 동기화** — [[wiki-sync]]를 따라 GitLab Release 최신 tag와 이 문서 `version` 일치를 확인한다.
2. **context7 설치 확인** — 각 에이전트가 자기 환경에 맞는 방법으로 연결을 확인하고, 미설치면 [[context7-instruction-guide]] 설치 절차를 따른다. 라이브러리·프레임워크 문서는 위키가 아니라 context7으로 조회한다.
3. **superpowers 설치 확인** — 미설치면 [[superpowers-instruction-guide]] 설치 절차를 따른다. 이미 있으면 그대로 둔다. 실행은 개별 프로젝트에서만 한다.
4. **Conventions·Operations 선행 학습** — 아래 목차의 Conventions·Operations 문서를 직접 열어 읽는다. 모든 작업·커밋·문서 변경의 전제.

저장소 운영 규칙 SSOT는 루트 `AGENTS.md`.

## 목차

### 구조

```
00_context/   개인 정적 기준 (글쓰기·사고방식)
10_raw/       원본 보관소 (라이브러리 문서 금지 — context7로 조회)
20_wiki/      LLM 정리본
  ├ principles/   원칙·기준 — 아키텍처·기술 선택 이유
  ├ conventions/  개발 전용 컨벤션 — 네이밍·코드 리뷰
  ├ operations/   운영 규약·가이드 — 개발 외에서도 쓰는 규칙 (커밋·MR·위키·에이전트)
  ├ index.md      이 목차 (유일한 진입점)
  └ log.md        작업 이력 (최신순)
```

> **범위** — 버저닝이 있는 라이브러리·프레임워크 문서는 위키에 두지 않는다. 최신 문서는 **context7**으로 조회한다. 위키엔 시간이 지나도 유효한 **원칙·기준·선택 이유**만 남긴다.

### Principles (원칙 · 기준)

- [[expo-sdk-54-pinning]] `[앱]` — 왜 Expo SDK 54.0.35로 고정하는가

### Conventions (개발 전용 컨벤션)

> 개발에만 국한된 규칙. 모두 `[공통]`.

- [[naming-convention]] — 변수·함수·파일 네이밍 규칙
- [[package-manager]] — 사내 표준 pnpm 최신 버전, npm·yarn 시도 시 실행 직전 확인
- [[node-version]] — 권장 Node 24 LTS, `.nvmrc`·`engines` 고정, 타 버전 시도 시 실행 직전 확인
- [[code-review]] — 리뷰 요청 시 code-review-graph 필수 사용(미설치 시 설치)·코드 품질 4기준(가독성·예측 가능성·응집도·결합도)·접근성·디버깅

### Operations (운영 규약·가이드)

> 개발 외에서도 쓰이는 규약·가이드. 커밋·MR·위키 작성·버전·동기화·에이전트 연동. 모두 `[공통]`.

- [[commit-convention]] — `type(scope): subject` 커밋 메시지 규칙 (코드·위키 공용)
- [[mr-pr-guide]] — GitLab MR / GitHub PR 작성 절차 (위키 MR 템플릿 포함)
- [[branch-strategy]] — 프로젝트 유형별 브랜치 전략 (인프라 main 단일 트랙 · 사내 제품 prod/dev 트랙)

- [[context7-instruction-guide]] `context7 사용 가이드` — 라이브러리·프레임워크 문서는 위키 저장 대신 context7(MCP) 조회
- [[wiki-authoring-guide]] `위키 작성 가이드` — 파일명(영문 kebab-case)·frontmatter(id·status·audit_log·relations 등)·경로 표기 표준
- [[log-writing-guide]] `로그 작성 규칙` — log·worklog 작성·압축 표준 (일자 기준·간결·괄호 금지·주간→월간 압축)
- [[wiki-versioning]] — `version` 올리는 기준·절차
- [[wiki-sync]] — 로컬↔원격(`origin/main`) 동기화
- [[project-wiki-guide]] — 개별 프로젝트는 `docs/raw/`(선택)·`docs/worklog.md`(필수)만
- [[agent-instruction-guide]] — 프로젝트 `AGENTS.md` 작성·위키 부트스트랩
- [[superpowers-instruction-guide]] `superpowers 사용 가이드` — 개별 프로젝트 전용 프로세스 스킬 플러그인, 설치·gitignore·우선 호출 규칙
