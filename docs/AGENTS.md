# AGENTS.md

모든 AI 에이전트가 따르는 표준 운영 규칙. 이 파일이 단일 기준(SSOT)이다.
`CLAUDE.md`는 Claude 전용 진입 파일일 뿐, 상세 규칙은 여기를 따른다.

## 시작 전 필수 (모든 작업 공통)

작업 종류와 무관하게 순서대로 먼저 한다.

1. **도구 설치.** 위키가 쓰는 도구(context7, superpowers, code-review-graph, mise/Node/Python/Docker)를 저장소 루트 `install.sh`로 설치한다. ① (선택) `./install.sh --dry-run`으로 미리보기 → ② **반드시 `./install.sh`로 실제 설치**(dry-run만으로는 설치되지 않으니 거기서 멈추지 않는다). 설치 후 **각 도구가 실제로 설치되고 연결됐는지 확인하고 넘어간다**(에이전트가 세션에서 직접 실행하는 context7, superpowers는 실행 후 반드시 확인). 확인 실패, 미설치면 각 지침으로 개별 설치 후 재확인한다. 자세히는 [설치 가이드 (install.sh)](20_wiki/operations/install-guide.md).
2. **원격 동기화 체크포인트.** [목차](20_wiki/index.md)를 읽기 전에 [위키 동기화](20_wiki/operations/wiki-sync.md)로 GitLab Release 최신 tag와 `index.md`의 `version` 일치를 확인, 동기화한다. 인덱스 워크플로의 **필수 선행 단계**다.
3. **[목차](20_wiki/index.md)를 읽는다.** 질문, 정리, 커밋 전부 이 단계 다음이다.
4. **git 작업(커밋, push, 태그, 릴리즈)이면 §Branch, MR과 §Versioning을 먼저 읽고 따른다.** 사용자가 짧게 "커밋해줘"라고 해도, 브랜치가 안 적혀 있어도, 브랜치부터 만든다.

## 목적

백엔드 개발 지식을 Markdown 위키로 관리한다. 특정 프로젝트 규칙 저장소가 아니라 여러 프로젝트 `docs/` 품질을 높이는 공통 지식 베이스다.

- 사람은 `10_raw/`에 원본을 넣는다.
- 에이전트는 `10_raw/`를 읽고 `20_wiki/`에 정리 문서를 만든다.
- `00_context/`는 잘 안 바뀌는 개인 기준을 보관한다.

## 프로젝트 연동

위키 실체는 **`~/backend-wiki` 한 곳**에만 둔다.
다른 프로젝트는 복제 대신 루트에 `backend-wiki` **심볼릭링크**를 만들어 `./backend-wiki/...`로 참조한다.

- 메인 위키 `~/backend-wiki`는 정상 커밋, push한다.
- 소비 프로젝트의 심볼릭링크는 머신마다 깨지므로 **절대 커밋하지 않는다**.

연동, 부트스트랩, `.gitignore`, `AGENTS.md` 템플릿은 [에이전트 지침 파일 작성 가이드](20_wiki/operations/agent-instruction-guide.md)가 SSOT다. 여기서 반복하지 않는다.

**위치 점검 (필수)** — 작업 전 메인 위키가 `$HOME/backend-wiki`인지 확인한다. 다른 경로면 링크가 깨지고 상대경로가 어긋나므로 `$HOME`으로 옮기라고 권유한다. 사용자가 거부하면 현재 경로로 진행하되 표준이 아님을 인지한다.

## 기본 원칙

- `10_raw/` 원본은 수정하지 않는다. source of truth다.
- 기본적으로 `20_wiki/` 문서만 만들거나 수정한다. `00_context/`는 사용자가 개인 기준 정리를 요청할 때만.
- 답변, 문서는 기본 한국어.
- 중요한 개념은 상대경로 마크다운 링크(`[제목](상대경로.md)`)로 연결한다.
- 라이브러리 최신 API, 사용법은 [context7 사용 가이드](20_wiki/operations/context7-instruction-guide.md)(MCP)로 참조한다. 위키엔 API 사용법을 문서화하지 않는다.
- 출처를 남기고 사실과 추론을 구분한다. 불확실은 `[검증 필요]`, 추론은 `[추론]`으로 표시한다.
- 새 자료를 처리하면 [목차](20_wiki/index.md)와 [작업 이력](20_wiki/log.md)을 갱신한다([로그 작성 규칙](20_wiki/operations/log-writing-guide.md)).
- `20_wiki/` 또는 운영 규칙을 수정하면 [위키 버전 관리](20_wiki/operations/wiki-versioning.md)에 따라 `index.md`의 `version`을 갱신한다.
- 공통 지식이 기준이지만, 프로젝트별 실제 규칙은 각 프로젝트가 우선한다(§Obsidian과 프로젝트 docs 역할 분리).

## 폴더 역할

```
00_context/   개인 정적 기준
10_raw/       원본 (읽기 전용)
20_wiki/      LLM 정리본
  ├ principles/   원칙, 기준 — 아키텍처, 기술 선택 이유
  ├ conventions/  개발 컨벤션 — 네이밍, 커밋, MR, code-review
  ├ operations/   운영 규약, 가이드 — 개발 외 전반(위키, 에이전트)
  ├ index.md      목차 (유일한 진입점)
  └ log.md        작업 이력
```

- **`10_raw/`** — 원본 보관소. 읽기만 한다. 파일명, frontmatter 표준 예외(현행 유지).
- **`20_wiki/`** — 폴더는 `principles`, `conventions`, `operations` **3개**인 저장통이고, **분류의 진실은 `index.md` 목차**다. 꼭 필요하지 않으면 폴더를 늘리지 않고 index 제목으로 묶는다. 문서 간 링크는 현재 파일 기준 상대경로 마크다운 링크로 건다.
  - `principles/` — 원칙, 기준. 아키텍처, 기술 선택 이유. (아직 비어 있음)
  - `conventions/` — 개발 컨벤션. 네이밍, 커밋, MR, [코드 리뷰](20_wiki/conventions/code-review.md).
  - `operations/` — 운영 규약, 가이드. 개발 외 전반(위키, 에이전트).
  - `index.md` 진입점, `log.md` 일 단위 이력([로그 작성 규칙](20_wiki/operations/log-writing-guide.md) 규칙).
- **`00_context/`** — 잘 안 바뀌는 개인 기준. 응답, 글쓰기 톤 참고용.
  - `writing-style.md` 글쓰기 기준, `thinking-principles.md` 사실성, 검증, 피드백 기준.
  - `code-style.md`, `user-profile.md`는 필요 시 생성.
  - `00_context/` 변경은 개인 기준이라 `index.md`에 넣지 않고 필요 시 `log.md`에만 남긴다.

## 작업 흐름

### Context First

말투, 글쓰기, 판단 기준이 결과물에 영향을 주는 작업은 `00_context/`를 먼저 읽는다. 특히 사용자를 대신한 글쓰기, 다듬기, 회고, 기여 정리, 장문 답변, 문서화가 그렇다.

- 문체는 [글쓰기 스타일](00_context/writing-style.md), 사실성, 검증, 피드백은 [원칙과 사고방식](00_context/thinking-principles.md)을 따른다.
- `00_context/`와 일반 템플릿이 충돌하면 `00_context/`가 우선한다. 단 출처 표기, 사실/추론 구분, raw 보존은 유지한다.

### Ingest

`10_raw/`에 새 자료가 들어오면:

1. 원본을 읽는다.
2. 관련 `principles/`, `conventions/`, `operations/` 문서를 새로 만들거나 갱신한다. **이것이 ingest의 본체다.** 단 기본 기술개념, 성능은 문서를 만들지 않고 raw 원문 참조로 둔다(§범위).
3. frontmatter `source:`에 `10_raw/` 경로, URL, 기준일을 남긴다.
4. 관련 개념을 상대경로 마크다운 링크로 잇고, [목차](20_wiki/index.md)와 [작업 이력](20_wiki/log.md)을 갱신한다.

### Query

1. [목차](20_wiki/index.md)를 먼저 읽고 관련 문서를 찾는다. 필요 시 `10_raw/` 원문을 확인한다.
2. 근거 문서를 명시하고 사실과 추론을 구분한다. 답변을 별도 파일로 저장하지 않는다.
3. [작업 이력](20_wiki/log.md)에 query 기록을 남긴다.

### Versioning

`20_wiki/` 문서나 운영 규칙을 수정하면 [위키 버전 관리](20_wiki/operations/wiki-versioning.md)를 따른다. 요지:

1. GitLab Release 최신 tag와 `index.md` `version` 일치 확인. 어긋나면 [위키 동기화](20_wiki/operations/wiki-sync.md)로 먼저 동기화.
2. `minor`/`patch` 결정 → `index.md` `version`, `updated` 갱신 → `log.md`에 이력 추가.
3. 작업 브랜치 → MR(§Branch, MR). 머지 후 `vX.Y.Z` tag, Release 생성.

### git 반영 확인 (필수)

커밋, push, MR, tag, 릴리즈처럼 원격에 반영되는 동작은 **실행 직전 옵션 선택형으로 확인한다.** 자유서술이 아니라 선택지를 제시한다.

- 예: `커밋할까요? [커밋합니다 / 아니요]`, `MR 올릴까요? [올립니다 / 아니요]`, `태그, 릴리즈 진행할까요? [진행합니다 / 아니요]`
- 준비 작업(브랜치 생성, staged 확인, 메시지 작성)은 확인 없이 진행하고 **반영 동작에서만** 묻는다. 사용자가 이미 "커밋/푸시 해줘"라고 명시한 그 단계는 다시 묻지 않는다.
- "아니요"면 반영하지 않고 로컬 상태만 유지한다.

### Commit

1. staged 변경 범위를 확인한다.
2. 커밋 메시지는 [커밋 컨벤션](20_wiki/operations/commit-convention.md)을 최우선 기준으로 작성한다. 없을 때만 일반 Conventional Commit.

### Branch, MR (필수)

`main`에 직접 커밋, push하지 않는다. 변경은 항상 작업 브랜치 → MR.

1. `main`에서 작업 브랜치(`docs/...`, `feat/...` 등)를 만든다.
2. 커밋([커밋 컨벤션](20_wiki/operations/commit-convention.md)), push 후 MR을 연다([MR PR 작성 가이드](20_wiki/operations/mr-pr-guide.md) 위키 MR 템플릿).
3. 버전 bump가 필요하면 `index.md`, `log.md` 갱신도 같은 MR에 포함한다.
4. MR은 **반드시 squash merge**한다(merge, rebase 커밋 금지).
5. tag, Release는 머지 후에 만든다(§Versioning, [위키 버전 관리](20_wiki/operations/wiki-versioning.md)).

### Lint

정기 점검: 끊어진 링크, 고립, 중복 문서, 오래된, 충돌, 출처 없는 주장, `index.md` 누락, 과도한 길이. 고칠 수 있으면 고치고, 판단이 필요하면 `log.md`에 남긴다.

## 문서 작성 규칙

기본 구조:

```md
# 제목

## 한 줄 요약

## 핵심 내용

## 관련 문서
- [제목](상대경로.md)

## 출처
-
```

- **파일명, frontmatter** — [위키 작성 가이드](20_wiki/operations/wiki-authoring-guide.md)가 SSOT. 파일명은 영문 소문자 kebab-case, 한글 제목은 `title`+`aliases`로 보존. 공통 필수 frontmatter `id`, `title`, `type`, `status`, `created_at`, `updated_at`, `tags`(+`created_by`/`updated_by`). 유형별 추가 필드, `relations`, `audit_log`, `status`/`type` 값은 [위키 작성 가이드](20_wiki/operations/wiki-authoring-guide.md). `10_raw/`는 예외.
- **링크** — 문서, 개념 참조는 **현재 파일 기준 상대경로 마크다운 링크**로 쓴다. 텍스트는 대상 문서 제목, 경로는 상대경로(같은 폴더 `[네이밍 컨벤션](naming-convention.md)`, 상위 `[목차](../index.md)`, 다른 폴더 `[커밋 컨벤션](../operations/commit-convention.md)`). 상대경로라 심볼릭 링크로 하위 프로젝트에 걸어도 유효하다. 저장소 루트 기준 경로나 `/` 시작, 머신 절대경로는 쓰지 않는다(심링크, 하위 폴더에서 깨짐). 존재하지 않는 링크는 만들지 않고, 일반 단어(`중요`, `참고`)는 링크하지 않는다.
- **파일 참조** — 문서 본문에서 파일을 언급하면 위와 같은 상대경로 마크다운 링크로 쓴다. 백틱 단독 파일명 금지([위키 작성 가이드](20_wiki/operations/wiki-authoring-guide.md)). 단 파일명을 값, 예시로 보이거나 이 저장소에 없는 외부 경로는 백틱을 쓴다.
- **표기** — 나열, 구분에는 쉼표(`,`)를 쓴다. 가운뎃점(`·`)은 쓰지 않는다.

### stack 참조 규칙

- 문서 `stack` 값: `common`(모든 백엔드 공통) / `nestjs`(NestJS 전용). 다른 프레임워크가 늘면 값으로 추가한다(예: `express`).
- 프로젝트에 `stack:`이 있으면 해당 스택 + `common`을 우선 참조한다. 불명확하면 `common`부터.

## Obsidian과 프로젝트 docs 역할 분리

- **Obsidian 위키** — 순수 백엔드 아카이브. 어떤 프로젝트에도 강제하지 않는 참고 지식.
- **프로젝트 `docs/`, `AGENTS.md`, `CLAUDE.md`** — 그 프로젝트의 실제 실행 규칙.
- 충돌 시 **프로젝트 규칙이 우선**한다.

## 금지 사항

- `10_raw/` 원본 수정
- 출처 없는 주장을 사실처럼 쓰기
- 불확실한 내용 단정
- 같은 개념 문서 중복 생성
- 존재하지 않는(깨진) 링크 남기기
- `index.md`, `log.md` 갱신 누락

## 작업 후 검증

- [목차](20_wiki/index.md)와 새로 만든 문서가 정상적으로 열리는지
- 마크다운 링크의 상대경로가 실제 파일과 맞는지, `relations`의 `id`가 실재하는지
- 공통 필수 frontmatter(`id`, `title`, `type`, `status`, `created_at`, `updated_at`, `tags`)가 있는지
- `index.md`, `log.md` 갱신이 빠지지 않았는지