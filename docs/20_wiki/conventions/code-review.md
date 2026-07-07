---
id: convention-code-review
title: 코드 리뷰
aliases: [코드 리뷰]
type: convention
status: draft
created_at: 2026-06-19
created_by: 이상협
updated_at: 2026-07-02
updated_by: 이상협
last_verified_at: 2026-07-02
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-06-19
    by: 이상협
    commit: ""
  - action: updated
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "백엔드 기준 재작성, frontmatter 스키마 v2"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "응집도 정의를 '관련 코드가 한곳에 모인 정도'로 풀어 쓰고 예시 추가"
tags: [backend, nestjs, code-review, code-quality, readability, predictability, cohesion, coupling, security, debug, principles, code-review-graph]
stack: common
source:
  - https://github.com/tirth8205/code-review-graph
relations:
  - id: operation-mr-pr-guide
    label: related
  - id: convention-naming-convention
    label: related
  - id: operation-commit-convention
    label: related
---

# 코드 리뷰

> 리뷰 **실행 절차**(code-review-graph)와 **판단 기준**(코드 품질 4기준, 백엔드 관심사, 디버깅)을 한 문서로 묶은 컨벤션. 실행 도구는 pip로 설치하는 MCP 서버로, 슬래시 명령, MCP 도구, 스킬을 제공한다(최신 문서는 [context7 사용 가이드](../operations/context7-instruction-guide.md)로 조회). 목차: [목차](../index.md), 관련: [MR PR 작성 가이드](../operations/mr-pr-guide.md)

리뷰는 변경을 머지 전에 거른다. 균일하게 다 보지 않고 **영향 범위(blast radius)와 위험도 순**으로 본다. 실행은 `code-review-graph`로 영향 범위를 계산해 읽을 파일만 좁히고, 판단은 아래 코드 품질 4기준, 백엔드 관심사로 객관화한다.

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
   └─ 영향 범위, 위험 점수로 읽을 파일 좁힘 → 판단 기준으로 리뷰
```

### 설치

미설치면 설치부터 시킨다. Python 3.10+ 필요. **설치는 사용자 전역으로 한다. 프로젝트 venv 안에 넣지 않는다**(`pipx`가 전역 격리라 권장, 없으면 `pip install --user`).

```bash
pipx install code-review-graph     # 전역 격리 설치(권장). 없으면: pip install --user code-review-graph
code-review-graph install          # AI 코딩 도구 자동 감지, MCP 설정 주입 (전역)
code-review-graph build            # 리뷰 대상 프로젝트 루트에서 실행 — 코드베이스 파싱 (500파일 ≈ 10초)
```

- `install` 후 에디터/도구를 **재시작**한다.
- Claude Code만 설정: `code-review-graph install --platform claude-code`
- 빌드 후 그래프가 있으면 AI가 MCP 도구(`get_minimal_context` → `get_impact_radius` → `detect_changes` 등)를 자동으로 쓴다.
- TypeScript를 포함해 폭넓은 언어를 지원하므로 NestJS 코드베이스에 그대로 쓴다.

### 워크플로 선택

| 상황 | 워크플로 / 슬래시 명령 | 범위 | 특징 |
|---|---|---|---|
| 마지막 커밋 이후만 | `review-delta`, `/code-review-graph:review-delta` | 마지막 커밋 + 2-hop | 토큰 5~10배↓ |
| PR 전체 | `review-pr`, `/code-review-graph:review-pr` | `git diff main...branch` | 영향 범위 분석 포함 |
| 변경 위험도 그룹핑 | `review-changes` | diff → 위험 점수 | High 그룹부터 |

→ 설치하면 위 워크플로가 슬래시 명령, 스킬로 제공된다(본체는 MCP 서버). 명령, MCP 도구 전체 목록, 워크플로 상세는 버전 따라 바뀌므로 [context7 사용 가이드](../operations/context7-instruction-guide.md)로 최신 문서를 조회한다(원본 저장소 https://github.com/tirth8205/code-review-graph).

### 무엇을 보나

- **컨벤션 준수 (필수)** — 위키 `conventions/`, `operations/`에 모아둔 규칙을 지켰는지 먼저 확인한다. 위반은 리뷰 지적 사항이다.
  - [네이밍 컨벤션](naming-convention.md) — 파일, 클래스, 식별자 네이밍(NestJS 역할 접미사 포함)
  - [커밋 컨벤션](../operations/commit-convention.md) — `type(scope): subject` 커밋 메시지
  - [MR PR 작성 가이드](../operations/mr-pr-guide.md) — MR/PR 작성 절차
  - 프로젝트에 자체 규칙이 있으면 **프로젝트 규칙이 우선**한다([목차](../index.md) 범위 참고).

---

## 판단 기준

### 코드 품질 4기준

좋은 백엔드 코드 = **변경하기 쉬운 코드**. 변경 용이성을 4기준으로 판단한다.

| 기준 | 정의 | 핵심 질문 |
|---|---|---|
| 가독성 | 읽기 쉬운 정도 | 한 번에 고려할 맥락이 적은가? |
| 예측 가능성 | 동작을 예측 가능한 정도 | 이름, 시그니처만 보고 동작을 아는가? |
| 응집도 | 관련 코드가 한곳에 모여 있는 정도 | 하나 고칠 때 같이 고칠 걸 빠뜨리지 않는가? |
| 결합도 | 수정 시 영향 범위 | 고쳤을 때 파급이 작은가? |

**트레이드오프** — 4기준을 동시에 다 못 채운다.

```
        응집도 (공통화)  ◄──────────►  가독성 (중복 허용)
   함께 안 고치면 버그 → 공통화      위험 낮음 → 중복 허용
```

정답 없음. **"장기적으로 수정하기 쉬운가"**로 판단한다. NestJS의 모듈 단위(도메인별 `*.module.ts`)는 응집, 결합을 구조로 강제하는 한 방법이다.

#### 가독성

읽는 사람이 **한 번에 고려할 맥락이 적고** 위→아래로 자연스럽게 읽히는 코드.

- 같이 실행 안 되는 코드 분리 / 구현 상세 추상화 / 로직 종류로 함수, 프로바이더 쪼개기.
- 복잡한 조건, 매직 넘버에 이름 붙이기(`canRefund`, `MAX_RETRY`).
- 중첩 조건 → early return, 가드절. 컨트롤러는 얇게, 비즈니스 로직은 서비스로.
- 주의: 과한 추상화는 가독성↓(응집도와 트레이드오프). 위험 낮으면 가독성 우선.

#### 예측 가능성

**이름, 파라미터, 반환값만 보고** 동작을 알 수 있고 일관된 규칙을 따르는 코드.

- 이름 겹치지 않게(라이브러리 동명 래퍼 금지: 자체 `http` → `httpService`).
- 같은 종류 함수는 반환 타입 통일(`Result<T>` 또는 도메인 예외로 실패 표현을 일관되게).
- 숨은 부수효과 드러내기 — 시그니처에 없는 side effect(외부 API 호출, DB 쓰기, 이벤트 발행)를 함수 안에 숨기지 않고 호출부에서 명시.

#### 응집도

**한 가지를 바꿀 때 함께 고쳐야 할 코드가 한곳에 모여 있는 정도.** 응집도가 높으면 관련 코드가 가까이 있어, 하나를 고칠 때 같이 고쳐야 할 것을 빠뜨리지 않는다. 낮으면 여기저기 흩어진 코드를 찾아 고쳐야 해서 누락이 생긴다. 예: 주문 상태 값과 그 전이, 검증 로직이 같은 모듈에 있으면, 상태를 하나 추가할 때 그 한곳만 손대면 된다.

- 함께 수정되는 파일을 같은 모듈 디렉토리에(도메인별 배치: `orders/` 안에 controller, service, dto).
- 같은 의미의 매직 넘버, 상수를 한 곳에서 관리(`config`, 상수 파일).
- 중복이 나은 경우: 두 기능이 다르게 발전할 가능성 높음 / 공유 코드 5줄 미만.

#### 결합도

**코드 수정 시 영향 범위.** 파급이 작아 예측 가능한 코드가 수정하기 쉽다.

- 책임을 하나씩(여러 책임 서비스 분리) / 섣부른 공통화 대신 중복 허용으로 영향 격리.
- 의존은 DI로 주입하고 구체 구현이 아니라 인터페이스, 토큰에 의존 → 교체, 테스트 쉬움.
- 모듈 경계를 넘는 직접 참조 대신 `exports`/`imports`로 명시. 순환 의존 경계.

### 백엔드 관심사

백엔드는 **경계, 데이터 안전성**을 본다. 요청이 들어오는 지점과 데이터가 나가는 지점이 출발점.

- **입력 검증** — 컨트롤러 경계에서 DTO + `class-validator`, `ValidationPipe`로 검증. 신뢰 안 되는 입력을 서비스로 흘리지 않는다.
- **보안** — 인증, 인가(Guard) 적용 여부, 민감정보 로깅 금지, SQL/쿼리 인젝션(Prisma 파라미터 바인딩 유지), 비밀값은 환경변수로.
- **트랜잭션, 일관성** — 여러 쓰기를 하나의 단위로 묶어야 하는데 흩어져 있지 않은지(`prisma.$transaction`), 실패 시 롤백 경로.
- **에러 처리** — 예외를 삼키지 않기, 도메인 예외 ↔ HTTP 상태 매핑(예외 필터), N+1, 불필요 쿼리 여부.

### 디버깅

**감이 아니라 체계적으로** — 진단 → 수정 → 예방 루프.

- **진단** — 에러 메시지로 검색하기 전에 원인을 좁힌다(호출, 의존 맵으로 범위 특정).
- **수정** — 증상 아닌 **근본 원인**(임시방편은 재발). 데드코드 제거(디버깅 방해), 비즈니스 로직을 순수 함수, 서비스로 분리(독립 테스트).

## 도메인별 리뷰 체크 포인트

각 컨벤션의 리뷰 확인 항목을 여기 모은다. 위 판단 기준과 함께, 해당 도메인을 건드린 변경이면 확인한다.

### 타입 ([TypeScript Style](typescript-style.md))

- 신규 코드에 implicit any 또는 불필요한 explicit any가 생겼는가?
- inline type으로 충분한 곳에 과도한 type/interface를 만들었는가?
- public 함수와 repository 함수의 반환 타입이 명시됐는가?
- type/interface 이름이 역할을 설명하는가?
- null/undefined 처리가 호출 지점에서 멀리 떨어져 있지 않은가?

### 구조, 소유권 ([Structure, Ownership](structure-ownership.md))

- 앱끼리 직접 import가 새로 생기지 않았는가?
- controller나 job이 Prisma, 외부 API를 직접 호출하지 않는가?
- 새 모듈이 기능 단위가 아니라 기술 계층 단위로 흩어지지 않았는가?
- 공유 코드로 옮긴 것의 소유, 책임이 분명한가?

### service, rule, policy ([Service, Rule, Policy](service-rule-policy.md))

- public 함수에서 유스케이스 흐름이 보이는가?
- 줄 수를 줄이기 위한 과도한 helper/wrapper가 생기지 않았는가?
- 함수명이 내부 작업을 충분히 설명하는가?
- repository나 controller에 비즈니스 규칙이 들어가지 않았는가?
- 외부 SDK/S3/Kafka/LLM 호출이 infra/client 경계를 거치는가?

### repository, Prisma ([Repository와 Prisma](repository-prisma.md))

- repository 함수 하나가 여러 DB 작업을 조합하지 않는가?
- soft delete 조회에 `isDeleted: false`가 빠지지 않았는가?
- audit field가 채워지는가?
- select/include 범위가 API에 필요한 만큼으로 제한됐는가?
- status 전이에 현재 상태 조건이 포함됐는가?
- AI가 Prisma CLI 또는 Prisma 관련 package script를 실행하지 않았는가?
- 필요한 migration/generate/seed 작업을 사용자 handoff로 남겼는가?
- Prisma schema 규칙과 migration/generated client handoff가 함께 반영됐는가?

### transaction ([Transaction](transaction.md))

- 여러 write가 필요한 상태 전이에 transaction이 있는가?
- transaction 안에 외부 네트워크 호출이 들어가지 않았는가?
- transaction client parameter가 `tx`로 관리되는가?
- repository 함수가 자체 transaction을 열지 않는가?
- 결제/지갑/ledger 흐름에서 idempotency와 audit trail을 함께 봤는가?

### Swagger, OpenAPI ([Swagger / OpenAPI (프론트 OAG 연동)](swagger-openapi.md))

- 요청/응답에 명시적 DTO가 있는가? inline object로 빠진 곳은 없는가?
- 컨트롤러 메서드에 응답 타입(`@ApiOkResponse`/`type`)이 명시됐는가?
- 운용 중 API의 DTO 클래스명, operationId를 바꾸지 않았는가?
- 필드 제거, 타입 변경, required 승격 같은 breaking이 없는가? 있으면 계약 변경으로 다뤘는가?
- `@ApiProperty`의 enum, nullable, required가 실제 동작과 일치하는가?

### 테스트 ([Testing](testing.md))

- 새 성공/실패 경로가 테스트되는가?
- DB/Redis/HTTP 흐름 변경에 integration/e2e가 있는가?
- pure rule/policy는 빠른 unit test로 잠겼는가?
- 외부 서비스 mock이 안정적인가?
- testcontainers/global infra helper를 재사용했는가?
- Jest/coverage 설정이 테스트 범위를 줄이지 않았는가?
- broad check 실패가 기존 레포 이슈라면 현재 작업 실패와 분리해 기록했는가?

### git hooks ([Husky (git hooks)](husky-git-hooks.md))

- pre-commit이 staged 파일만 대상으로 빠르게 도는가(전체 검사를 넣지 않았는가)?
- 무거운 검사를 hook 대신 CI/pre-push에 뒀는가?
- hook이 [ESLint, Prettier, mise 설정](eslint-prettier-mise.md) 설정과 같은 규칙을 실행하는가?
- **예방** — 에러 로그 상세화(요청 ID, 입력, 재현 조건), 버그 리포트 기록, 팀 공유로 재발 방지.