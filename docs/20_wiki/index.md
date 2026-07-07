---
id: index
title: 목차
type: index
status: active
version: "0.2.2"
tags: [wiki, index]
created_at: 2026-06-19
created_by: 이상협
updated_at: 2026-07-06
updated_by: 이상협
---

# 목차

backend-wiki 전체 목차. 모든 작업, 질문 전 먼저 읽는다.

## 시작 전 필수 (순서대로)  

1. **도구 설치 (권장)** — 위키가 쓰는 도구(context7, superpowers, code-review-graph, mise/Node/Python/Docker)를 저장소 루트 `install.sh`로 설치한다. ① (선택) `./install.sh --dry-run`으로 계획 미리보기 → ② **반드시 `./install.sh`로 실제 설치.** dry-run만으로는 설치되지 않으니 거기서 멈추지 않는다. 설치 후 **각 도구가 실제로 설치되고 연결됐는지 확인하고 넘어간다**(특히 에이전트가 세션에서 직접 실행하는 context7, superpowers는 실행 후 반드시 확인). 확인 실패나 미설치면 아래 각 지침(3, 4번)으로 개별 설치, 재확인한다. 자세히는 [설치 가이드 (install.sh)](operations/install-guide.md).
2. **원격 동기화** — [위키 동기화](operations/wiki-sync.md)를 따라 GitLab Release 최신 tag와 이 문서 `version` 일치를 확인한다.
3. **context7 설치 확인** — 보통 1번에서 설정된다. 미설치, 미연결이면 `claude mcp list`로 연결을 확인하고 `npx ctx7 setup`을 실행한다. 절차는 [context7 사용 가이드](operations/context7-instruction-guide.md). 라이브러리, 프레임워크 문서는 위키가 아니라 context7으로 조회한다.
4. **superpowers 설치 확인** — 미설치면 [superpowers 사용 가이드](operations/superpowers-instruction-guide.md) 설치 절차를 따른다. 이미 있으면 그대로 둔다. 실행은 개별 프로젝트에서만 한다.
5. **Conventions, Operations 선행 학습** — 아래 목차의 Conventions, Operations 문서를 직접 열어 읽는다. 모든 작업, 커밋, 문서 변경의 전제.


## 구조

```
00_context/   개인 정적 기준 (글쓰기, 사고방식)
10_raw/       원본 (읽기 전용)
20_wiki/      LLM 정리본
  ├ principles/   원칙, 기준 — 아키텍처, 기술 선택 이유
  ├ conventions/  개발 컨벤션 — 네이밍, 커밋, MR, 코드 리뷰
  ├ operations/   운영 규약, 가이드 — 개발 외 전반 (현재 위키, 에이전트)
  ├ index.md      이 목차 (유일한 진입점)
  └ log.md        작업 이력 (최신순)
```

폴더는 `principles`, `conventions`, `operations` 3개인 저장통이고, **분류의 진실은 이 목차**다. 문서 간 링크는 현재 파일 기준 상대경로 마크다운 링크로 건다. 상대경로라 심볼릭 링크로 하위 프로젝트에 걸어도 유효하다.

> **범위** — 버저닝이 있는 라이브러리, 프레임워크 문서는 위키에 두지 않는다. 최신 문서는 [context7 사용 가이드](operations/context7-instruction-guide.md)로 조회한다. 위키엔 시간이 지나도 유효한 원칙, 기준, 선택 이유만 남긴다.
>
> **스택 표기** — `[공통]` 모든 백엔드 공통 / `[nestjs]` NestJS 전용

## Principles (원칙, 기준)

> 아직 정리된 문서 없음. 아키텍처, 기술 선택 이유가 생기면 여기에 추가한다.

## Conventions (개발 컨벤션)

> 코딩하며 지키는 규약. 별도 표기 없으면 `[공통]`.

- [네이밍 컨벤션](conventions/naming-convention.md) `[nestjs]` — 파일(역할 접미사), 클래스, 식별자 네이밍 규칙
- [TypeScript Style](conventions/typescript-style.md) `[nestjs]` — 타입 선언, interface/type 분리, strict 기준, ESLint/Prettier
- [ESLint, Prettier, mise 설정](conventions/eslint-prettier-mise.md) `[nestjs]` — 프로젝트 셋업용 ESLint/Prettier 기본 설정, mise로 Node 버전 고정
- [로컬 인프라 (docker-compose)](conventions/docker-compose-infra.md) `[nestjs]` — 로컬 인프라(DB/Redis/Kafka) docker-compose 템플릿, 프로젝트명/서비스 선택
- [환경변수 파일 (.env)](conventions/env-files.md) `[nestjs]` — 루트 공통 + 앱별 env 두 파일 주입, APP_ENV로 local/dev/prod 선택
- [Husky (git hooks)](conventions/husky-git-hooks.md) `[nestjs]` — Husky + lint-staged로 커밋 전 lint/format 검사
- [Structure, Ownership](conventions/structure-ownership.md) `[nestjs]` — feature 모듈 구조, 레이어 책임, import ownership, controller 경계
- [Repository와 Prisma](conventions/repository-prisma.md) `[nestjs]` — repository 책임, Prisma query/schema/migration, generated client 규칙
- [Service, Rule, Policy](conventions/service-rule-policy.md) `[nestjs]` — service 유스케이스 흐름과 rule/policy/strategy 분리 기준
- [Transaction](conventions/transaction.md) `[nestjs]` — transaction 경계(service 소유), tx client 전달, 원자적 상태 전이
- [Swagger / OpenAPI (프론트 OAG 연동)](conventions/swagger-openapi.md) `[nestjs]` — Swagger 스펙=프론트 OAG 계약, DTO/응답 명시, 운용 중 API 이름 변경 금지
- [코드 리뷰](conventions/code-review.md) — 리뷰 요청 시 code-review-graph 필수 사용(미설치 시 설치), 코드 품질 4기준(가독성, 예측 가능성, 응집도, 결합도), 백엔드 관심사(입력검증, 보안, 트랜잭션, 에러처리), 디버깅
- [Testing](conventions/testing.md) `[nestjs]` — unit/integration/e2e, TDD, 커버리지, Jest 설정, 테스트 배치 기준

## Operations (운영 규약)

> 작업, 운영하며 지키는 규약. 모두 `[공통]`.

- [설치 가이드 (install.sh)](operations/install-guide.md) `설치 가이드` — 루트 `install.sh`로 도구 일괄 설치, 플래그(`--dry-run`, `--no-remote`), 개별 지침 폴백
- [위키 작성 가이드](operations/wiki-authoring-guide.md) `위키 작성 가이드` — 파일명, id, frontmatter 스키마 표준, 본문 파일 참조 규칙
- [커밋 컨벤션](operations/commit-convention.md) — `type(scope): subject` 커밋 메시지 규칙
- [MR PR 작성 가이드](operations/mr-pr-guide.md) — GitLab MR / GitHub PR 작성 절차
- [로그 작성 규칙](operations/log-writing-guide.md) `로그 작성 규칙` — 일 단위 로그, 작성자(괄호) 표기, 압축(collapsed) 표준
- [개별 프로젝트 위키 생성 및 작성 가이드](operations/project-wiki-guide.md) — 개별 프로젝트는 `docs/10_raw/`(선택), `docs/worklog.md`(필수)만
- [위키 버전 관리](operations/wiki-versioning.md) — `version` 올리는 기준, 절차
- [위키 동기화](operations/wiki-sync.md) — 로컬↔원격(`origin/main`) 동기화
- [에이전트 지침 파일 작성 가이드](operations/agent-instruction-guide.md) — 프로젝트 `AGENTS.md` 작성, 위키 부트스트랩
- [context7 사용 가이드](operations/context7-instruction-guide.md) `[공통]` — Upstash MCP 서버, 라이브러리 최신 문서 참조 도구(채택)
- [Humanize KR (im-not-ai) 사용 가이드](operations/humanize-korean.md) `[공통]` — 한국어 AI 티 제거 윤문 도구(im-not-ai), Claude/Codex 등 지원
