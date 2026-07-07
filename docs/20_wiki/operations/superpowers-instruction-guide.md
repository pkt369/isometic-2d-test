---
id: operation-superpowers-instruction-guide
title: superpowers 사용 가이드
aliases: [superpowers 사용 가이드]
type: operation
status: active
created_at: 2026-07-02
created_by: 정회석
updated_at: 2026-07-02
updated_by: 정회석
audit_log:
  - action: created
    at: 2026-07-02
    by: 정회석
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "설치, 확인 절차 확정, 개별 프로젝트 전용 실행 범위와 gitignore 규칙 신설"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "설치 확인을 에이전트 중립 지침으로 변경 — claude 전용 명령 제거"
tags: [common, operation, superpowers, agent, skill]
stack: common
scope: superpowers-instruction
source: "https://github.com/obra/superpowers"
relations:
  - id: operation-agent-instruction-guide
    label: related
  - id: operation-context7-instruction-guide
    label: related
  - id: operation-project-wiki-guide
    label: related
---

# superpowers-instruction-guide

## 한 줄 요약

**superpowers**는 에이전트에게 작업 프로세스 스킬(브레인스토밍, 계획, 디버깅, TDD 등)을 제공하는 플러그인이다. 작업 성격에 맞는 스킬이 있으면 응답 전에 먼저 호출한다.

## 실행 범위 (중요)

- **개별 프로젝트에서만 실행한다.** backend-wiki 저장소에서는 실행하지 않는다.
- 프로젝트 셋팅 시 [에이전트 지침 파일 작성 가이드](agent-instruction-guide.md) 부트스트랩과 함께 설치, gitignore를 확인한다.

## 설치 (개별 프로젝트 셋팅 시)

### 1. 설치 확인

**각 에이전트가 자기 환경에 맞는 방법으로 superpowers 플러그인(스킬) 설치 여부를 확인한다.** 에이전트마다 플러그인, 스킬 확인 방법이 다르므로 특정 명령을 정하지 않는다.

- 설치돼 있으면 **그대로 사용하고 재설치, 재설정하지 않는다.**
- 없으면 아래 설치.

### 2. 설치

설치 방법은 context7 https://context7.com/obra/superpowers 에서 **사용 중인 에이전트(하니스) 기준으로 조회**해 따른다. 하니스마다 별도 설치가 필요하다(Claude Code, Codex CLI, Gemini CLI, OpenCode, Cursor, Copilot CLI 등 지원).

### 3. gitignore 등록 (필수)

superpowers는 프로젝트에 산출물 폴더를 만든다. **git에 올리지 않는다** — 프로젝트 `.gitignore`에 추가:

```gitignore
docs/superpowers/
.superpowers/
```

- `docs/superpowers/` — brainstorming 등이 만드는 설계 스펙 산출물.
- `.superpowers/` — 플러그인 작업 상태 폴더.
- 프로젝트 `docs/`는 [개별 프로젝트 위키 생성 및 작성 가이드](project-wiki-guide.md) 구조(`raw/`, `worklog.md`)를 따르므로, superpowers 산출물이 그 구조에 섞여 커밋되지 않게 여기서 막는다.

## 왜 쓰나

- 에이전트가 무계획하게 코드부터 만지는 것을 막는다. 설계 합의 → 계획 → 구현 → 검증 순서를 스킬이 강제한다.
- 디버깅, 리뷰, 완료 검증 같은 반복 작업의 품질을 프로세스로 균일화한다.

## 핵심 규칙

- **스킬 우선 호출** — 작업에 해당하는 스킬이 있으면 응답, 탐색 전에 먼저 호출한다.
- **프로세스 스킬 → 구현 스킬 순서** — "만들자"는 brainstorming부터, "버그다"는 systematic-debugging부터. 구현 스킬은 그 뒤.
- **설계 승인 전 구현 금지** — brainstorming은 설계 제시, 사용자 승인 전까지 코드 작성을 막는다
- 사용자 지시, 프로젝트 규칙(`AGENTS.md`)이 스킬과 충돌하면 **프로젝트 규칙이 우선**한다.

## 주요 스킬

| 상황 | 스킬 |
|---|---|
| 기능, 문서 등 새로 만들 때 | brainstorming |
| 스펙을 계획으로 만들 때 | writing-plans → executing-plans |
| 버그, 테스트 실패 | systematic-debugging |
| 기능, 버그픽스 구현 | test-driven-development |
| 격리 작업 공간 필요 | using-git-worktrees |
| 완료 선언 전 | verification-before-completion |
| 리뷰 요청, 수신 | requesting-code-review, receiving-code-review |

## 관련 문서

- [에이전트 지침 파일 작성 가이드](agent-instruction-guide.md)
- [context7 사용 가이드](context7-instruction-guide.md)
- [개별 프로젝트 위키 생성 및 작성 가이드](project-wiki-guide.md)

## 출처

- https://github.com/obra/superpowers
- context7: https://context7.com/obra/superpowers
