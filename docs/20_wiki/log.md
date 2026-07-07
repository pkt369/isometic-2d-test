---
id: log
title: 작업 이력
aliases: [작업 이력]
type: log
status: active
created_at: 2026-07-01
created_by: 이상협
updated_at: 2026-07-06
updated_by: 이상협
tags: [wiki, log]
---

# 작업 이력

- 2026-07-06 (이상협) — 문서 간 참조를 Obsidian 위키링크에서 상대경로 마크다운 링크로 전면 전환(218개). 텍스트는 각 문서 제목, 경로는 현재 파일 기준 상대경로라 심볼릭 링크로 하위 프로젝트에 걸어도 유효하다. 기존 루트 기준, 절대 경로 마크다운 링크(43개)도 상대경로로 정규화하고, 제목 표기로 생긴 조사를 교정. 링크 규칙 자체를 AGENTS, wiki-authoring-guide, index에서 마크다운 링크 기준으로 재작성. agent-instruction-guide의 소비 경로 백틱을 마크다운 링크로 전환. version 0.2.1 → 0.2.2.

- 2026-07-03 (이상협) — 컨벤션 보강. 라이브러리 경로 별칭을 `@app`이 아니라 `@libs`로 쓰도록 규칙 신설(structure-ownership, NestJS CLI prefix 프롬프트에서 @libs 선택). mise로 Node 24, pnpm, Python 3.12를 함께 고정하도록 변경(eslint-prettier-mise, install.sh, corepack 대신 pnpm은 mise 관리). 각 컨벤션에 흩어져 있던 "AI 리뷰 체크 포인트"를 code-review의 "도메인별 리뷰 체크 포인트"로 통합하고 원 문서는 포인터만 남김.
- 2026-07-03 (이상협) — install.sh 설치 지침 개선. 에이전트가 dry-run만 읽고 실제 설치를 안 하는 문제, 위임한 도구(context7, superpowers 등)를 설치 후 확인 없이 넘어가는 문제 수정. dry-run은 선택 미리보기, 실제 설치는 필수인 2단계로 명확화하고 설치 확인(필수) 게이트 추가. install.sh에 dry-run 미리보기 안내와 다음 단계 항목 확인 문구 추가, index, AGENTS, install-guide 반영. 도구를 프로젝트 안에 설치하는 경향 방지 — 전역(~/) 설치 원칙 명시(install-guide), im-not-ai 클론 경로를 $HOME/.tools로, code-review-graph를 pipx 전역 격리 우선으로 수정. install-guide 새 산문 윤문. version 0.2.0 → 0.2.1.
- 2026-07-03 (이상협) — 위키가 소개하는 도구를 한 번에 설치하는 루트 install.sh 신설(OS/에이전트/대화형 감지, 프로젝트 셋업 도구, AI 도구 두 그룹, code-review-graph, Python 포함, 멱등). 안전장치로 `--dry-run`, 원격 실행 회피용 `--no-remote`, `--help`, curl|sh 보안 주석과 버전 핀(env) 안내 추가. 설치 가이드 문서(install-guide) 신설, index 시작 전 필수와 AGENTS 시작 전 필수에 install.sh 설치 단계, 실패 시 개별 지침 폴백 반영.
- 2026-07-02 (정회석, 이상협) — context7, superpowers 사용 가이드 신설, index 시작 절차에 도구 설치 확인 추가, repository-prisma 피드백 반영(식별자 UUID v7 통일, soft delete 조회 전제, enum 규칙 정리), code-review-graph를 MCP 서버, context7 조회로 정리, 컨벤션 피드백 반영, 본문 다듬기, 가운뎃점을 쉼표로 통일, 표기 규칙 신설, ESLint/Prettier/mise 설정, 로컬 인프라 docker-compose, env 파일, Swagger/OpenAPI(OAG 연동), Husky git hooks 컨벤션, Humanize KR(im-not-ai) 사용 가이드 문서 신설. 개발 셋업, API 계약 컨벤션 확장으로 version 0.1.0 → 0.2.0.
- 2026-07-01 (이상협) — 위키를 백엔드 NestJS 기준으로 전환. frontmatter 스키마 v2, 문서 링크 규칙, 일 단위 로그 규칙 도입, conventions를 conventions(개발 규약)/operations(운영 규약)로 분리하며 type operation 신설, Context7 채택, repository, Prisma, service/rule/policy, structure/ownership, testing, transaction, typescript-style 컨벤션 신설, concepts 폐지(context7을 operations로 이동, type concept 제거), principles 폴더 신설(빈 폴더, type principle 추가), 범위를 context7 조회 기준으로 갱신. version 0.1.0 기준선.
