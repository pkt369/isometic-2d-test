---
id: convention-code-review
title: 코드 리뷰
aliases: [코드 리뷰]
type: convention
status: draft
created_at: 2026-06-19
created_by: 정회석
updated_at: 2026-07-02
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
    note: "raw 포인터를 context7 조회로 전면 교체, fsd 문서 참조 제거"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "im-not-ai 윤문으로 명사 종결 문장 1곳 자연화"
tags: [frontend, code-review, code-quality, readability, predictability, cohesion, coupling, a11y, debug, principles, code-review-graph]
stack: common
scope: code-review
source:
  - https://context7.com/toss/frontend-fundamentals
  - https://context7.com/tirth8205/code-review-graph
relations:
  - id: convention-naming-convention
    label: depends-on
  - id: operation-commit-convention
    label: depends-on
  - id: operation-mr-pr-guide
    label: depends-on
---

# 코드 리뷰

> 리뷰 **실행 절차**(code-review-graph)와 **판단 기준**(코드 품질 4기준·접근성·디버깅)을 한 문서로 묶은 컨벤션. 각 판단 기준은 요약 + context7 포인터다. 세부 예제·코드는 context7 https://context7.com/toss/frontend-fundamentals 에서 조회한다([[context7-instruction-guide]]). 관련: [[mr-pr-guide]]

리뷰는 변경을 머지 전에 거른다. 균일하게 다 보지 않고 **영향 범위(blast radius)와 위험도 순**으로 본다. 실행은 `code-review-graph`로 영향 범위를 계산해 읽을 파일만 좁히고, 판단은 아래 코드 품질 4기준·접근성으로 객관화한다.

## 리뷰 실행 (필수)

**사용자가 코드 리뷰를 요청하면 `code-review-graph`를 사용한다.** 변경+영향 노드만 컨텍스트에 올려 읽을 최소 파일 집합만 계산하므로, 전체 파일을 반복해 읽는 낭비를 막는다.

### 절차

```
코드 리뷰 요청
   │
   ├─ code-review-graph 설치됨?
   │      │
   │      ├─ 아니오 → 설치 (아래 "설치") → 그래프 빌드
   │      │
   │      └─ 예 → 계속
   │
   ├─ 그래프 최신? (없거나 오래됨 → build/update)
   │
   ├─ 워크플로 선택 (아래 표)
   │
   └─ 영향 범위·위험 점수로 읽을 파일 좁힘 → 판단 기준으로 리뷰
```

### 설치

미설치면 설치부터 시킨다. Python 3.10+ 필요.

```bash
pip install code-review-graph      # 또는: pipx install code-review-graph
code-review-graph install          # AI 코딩 도구 자동 감지·MCP 설정 주입
code-review-graph build            # 코드베이스 파싱 (500파일 ≈ 10초)
```

- `install` 후 에디터/도구를 **재시작**한다.
- Claude Code만 설정: `code-review-graph install --platform claude-code`
- 빌드 후 그래프가 있으면 AI가 MCP 도구(`get_minimal_context` → `get_impact_radius` → `detect_changes` 등)를 자동으로 쓴다.

### 워크플로 선택

| 상황 | 워크플로 / 슬래시 명령 | 범위 | 특징 |
|---|---|---|---|
| 마지막 커밋 이후만 | `review-delta` · `/code-review-graph:review-delta` | 마지막 커밋 + 2-hop | 토큰 5~10배↓ |
| PR 전체 | `review-pr` · `/code-review-graph:review-pr` | `git diff main...branch` | 영향 범위 분석 포함 |
| 변경 위험도 그룹핑 | `review-changes` | diff → 위험 점수 | High 그룹부터 |

→ 슬래시 명령·MCP 도구 30종과 워크플로 상세는 context7 https://context7.com/tirth8205/code-review-graph 에서 조회한다.

### 무엇을 보나

- **컨벤션 준수 (필수)** — `/20_wiki/conventions/`·`/20_wiki/operations/`의 규칙을 지켰는지 먼저 확인한다. 위반은 리뷰 지적 사항이다.
  - [[naming-convention]] — 변수·함수·파일 네이밍
  - [[commit-convention]] — `type(scope): subject` 커밋 메시지
  - [[mr-pr-guide]] — MR/PR 작성 절차
  - 프로젝트에 자체 규칙이 있으면 **프로젝트 규칙이 우선**한다([[index]] 범위 참고).

---

## 판단 기준

### 코드 품질 4기준

좋은 프론트엔드 코드 = **변경하기 쉬운 코드**. 변경 용이성을 4기준으로 판단한다.

| 기준 | 정의 | 핵심 질문 |
|---|---|---|
| 가독성 | 읽기 쉬운 정도 | 한 번에 고려할 맥락이 적은가? |
| 예측 가능성 | 동작을 예측 가능한 정도 | 이름·시그니처만 보고 동작을 아는가? |
| 응집도 | 함께 수정될 코드가 같이 수정되는가 | 한 곳 고치면 빠뜨릴 데가 없는가? |
| 결합도 | 수정 시 영향 범위 | 고쳤을 때 파급이 작은가? |

**트레이드오프** — 4기준을 동시에 다 못 채운다.

```
        응집도 (공통화)  ◄──────────►  가독성 (중복 허용)
   함께 안 고치면 버그 → 공통화      위험 낮음 → 중복 허용
```

정답 없음. **"장기적으로 수정하기 쉬운가"**로 판단한다. FSD(Feature-Sliced Design)는 응집·결합을 폴더 구조로 강제하는 한 방법 — context7 https://context7.com/feature-sliced/documentation 참조.
→ context7: https://context7.com/toss/frontend-fundamentals — code-quality 개요

#### 가독성

읽는 사람이 **한 번에 고려할 맥락이 적고** 위→아래로 자연스럽게 읽히는 코드.

- 같이 실행 안 되는 코드 분리(분기별 컴포넌트) / 구현 상세 추상화 / 로직 종류로 함수 쪼개기.
- 복잡한 조건·매직 넘버에 이름 붙이기(`canPurchase`, `PAGE_SIZE`).
- 시점 이동 줄이기 / 중첩 삼항 → `if`·early return.
- 주의: 과한 추상화는 가독성↓(응집도와 트레이드오프). 위험 낮으면 가독성 우선.

→ context7: https://context7.com/toss/frontend-fundamentals — readability 토픽, 예제는 submit-button·condition-name·magic-number-readability·ternary-operator 등

#### 예측 가능성

**이름·파라미터·반환값만 보고** 동작을 알 수 있고 일관된 규칙을 따르는 코드.

- 이름 겹치지 않게(라이브러리 동명 래퍼 금지: `http` → `httpService`).
- 같은 종류 함수는 반환 타입 통일(Discriminated Union `{ ok: true } | { ok: false; reason }`).
- 숨은 부수효과 드러내기 — 시그니처에 없는 side effect를 함수 안에 숨기지 않고 호출부에서 명시.

→ context7: https://context7.com/toss/frontend-fundamentals — predictability 토픽, 예제는 http·use-user·hidden-logic

#### 응집도

**수정돼야 할 코드가 항상 같이 수정되는지.** 높으면 한 곳 고칠 때 다른 곳 누락이 안 난다.

- 함께 수정되는 파일을 같은 디렉토리에(도메인별 배치, FSD slice 원리).
- 같은 의미의 매직 넘버·상수를 한 곳에서 관리.
- 중복이 나은 경우: 두 기능이 다르게 발전할 가능성 높음 / 공유 코드 5줄 미만.

→ context7: https://context7.com/toss/frontend-fundamentals — cohesion 토픽, 예제는 code-directory·magic-number-cohesion·form-fields

#### 결합도

**코드 수정 시 영향 범위.** 파급이 작아 예측 가능한 코드가 수정하기 쉽다.

- 책임을 하나씩(여러 책임 훅 분리) / 섣부른 공통화 대신 중복 허용으로 영향 격리.
- Props Drilling 제거 — 깊은 prop 전달은 Composition(children)·Context로. Context는 진짜 전역 관심사만(테마·로케일·인증).

→ context7: https://context7.com/toss/frontend-fundamentals — coupling 토픽, 예제는 use-page-state-coupling·use-bottom-sheet·item-edit-modal

### 접근성

모든 사용자(장애인·키보드·일반)가 쓸 수 있게 하는 기본. 프론트가 HTML 구조·인터랙션을 만드니 여기서 출발한다.

- **스크린리더 3요소**: 역할(Role) → 레이블(Label) → 상태(State) 순으로 읽음.
- **4원칙**
  1. 올바른 구조 — 버튼 안 버튼 금지
  2. 의미 전달 — 인터랙티브 요소에 이름
  3. 예측 가능 인터랙션 — 가짜 버튼(`<div onclick>`) 금지 → 진짜 `<button>`, 입력은 `<form>`
  4. 시각 정보에만 의존 금지 — `alt`·텍스트 보완
- 실무: 클릭 가능 = `<button>`/`<a>`, eslint로 위반 사전 탐지, 테스트는 `getByRole`.

→ context7: https://context7.com/toss/frontend-fundamentals — a11y 토픽, structure·semantic·predictability·alt-text·eslint

### 디버깅

**감이 아니라 체계적으로** — 진단 → 수정 → 예방 루프.

- **진단** — 에러 메시지로 검색하기 전에 원인을 좁힌다(호출·의존 맵으로 범위 특정).
- **수정** — 증상 아닌 **근본 원인**(임시방편은 재발). 데드코드 제거(디버깅 방해), 비즈니스 로직을 순수 함수로 분리(독립 테스트).
- **예방** — 에러 로그 상세화(버전·기기·재현 조건), 버그 리포트 기록·팀 공유로 재발 방지.

→ context7: https://context7.com/toss/frontend-fundamentals — debug 토픽, diagnose·fix·prevent

## 출처
- 토스 Frontend Fundamentals — context7 https://context7.com/toss/frontend-fundamentals, 원 사이트 https://frontend-fundamentals.com
- code-review-graph — context7 https://context7.com/tirth8205/code-review-graph, https://github.com/tirth8205/code-review-graph (MIT)
