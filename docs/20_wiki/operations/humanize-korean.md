---
id: operation-humanize-korean
title: "Humanize KR (im-not-ai) 사용 가이드"
aliases: ["Humanize KR (im-not-ai) 사용 가이드", humanize-korean, im-not-ai]
type: operation
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
    note: "Humanize KR(im-not-ai) 크로스-AI 사용 가이드 신설"
tags: [common, operation, humanize, writing, tool]
stack: common
scope: humanize-korean
relations:
  - id: context-writing-style
    label: related
  - id: context-thinking-principles
    label: related
---

# Humanize KR (im-not-ai) 사용 가이드

## 한 줄 요약

한국어 글에서 **AI 티(번역투, 기계적 병렬, AI 상투어, 과한 수동태 등)를 걷어내는 윤문 도구**. Claude Code, Codex 등에서 스킬이나 명령으로 쓴다. **AI가 쓴 한국어 글을 사람 글답게 다듬을 때** 쓴다. 목차: [목차](../index.md)

## 무엇인가

- 내용은 그대로 두고 한국어 AI 흔적만 골라 고쳐 쓰는 도구(10여 개 범주, 40여 개 세부 패턴, 심각도 S1/S2/S3).
- 형태: Claude Code Skill + Plugin, Codex CLI 지원, 커뮤니티 웹 포트.
- **미지원**: 일반 ChatGPT, web Claude.ai. (코딩 에이전트 CLI 계열에서만 동작)
- 에이전트 구성이나 모드별 처리량 같은 세부는 버전마다 바뀌므로 원본 저장소를 본다: https://github.com/epoko77-ai/im-not-ai

## 설치

도구를 자동으로 감지하는 `install.sh`가 기본이고, 도구별 방식도 따로 있다.

### 공통 — 자동 감지

**프로젝트 안이 아니라 사용자 전역(`$HOME`)에 클론한다**(install.sh의 `TOOLS_DIR`과 동일). 스킬은 `~/.claude` 등 전역에 설치되므로 저장소를 프로젝트 안에 두지 않는다.

```bash
git clone https://github.com/epoko77-ai/im-not-ai.git "$HOME/.tools/im-not-ai"
cd "$HOME/.tools/im-not-ai"
./install.sh          # Claude / Codex 를 감지해 설정
```

### Claude Code — 마켓플레이스 (권장)

```text
/plugin marketplace add epoko77-ai/im-not-ai
/plugin install humanize-korean@im-not-ai
```

### Codex CLI

```bash
./install.sh --codex-only
```

- 설치한 뒤 에디터나 세션을 다시 시작한다.
- 설치 확인: 해당 도구에서 아래 "사용법"의 명령(스킬)이 뜨는지 본다. 안 뜨면 재시작 후 다시 확인하고, 그래도 안 되면 원본 저장소의 설치 안내를 본다.

## 사용법

호출 방식은 도구마다 다르다.

| 도구 | 호출 |
|---|---|
| Claude Code | `/humanize [텍스트 또는 파일경로]`, 또는 자연어("이 AI 글 자연스럽게 윤문해줘") |
| Codex CLI | `$humanize-korean` |
| 미지원 | 일반 ChatGPT, web Claude.ai |

- 기본은 빠른 모드(짧은 글)이고, 긴 글이나 `--strict`는 더 꼼꼼한 다단계 처리로 간다. 정확한 임계값과 동작은 저장소 README를 본다.

## 언제 쓰나

- 사용자를 대신한 글쓰기, 문서 윤문, 회고나 기여 정리처럼 **한국어 산출물의 AI 티를 걷어낼 때**.
- 이 도구는 [글쓰기 스타일](../../00_context/writing-style.md)의 "피할 AI 상투어"와 [원칙과 사고방식](../../00_context/thinking-principles.md)의 "AI 티/날조 지양"을 **실제로 실행하는 수단**이다. 판단 기준은 그 두 문서에 있고, 실행이 이 도구다.
- 다만 도구가 자동으로 윤문한 결과도 [글쓰기 스타일](../../00_context/writing-style.md) 기준(내 목소리 유지, 근거 없는 포장 금지)으로 마지막에 확인한다.

## 관련 문서

- [글쓰기 스타일](../../00_context/writing-style.md)
- [원칙과 사고방식](../../00_context/thinking-principles.md)

## 출처

- im-not-ai (Humanize KR), https://github.com/epoko77-ai/im-not-ai (MIT)
- 기준일 2026-07-02
