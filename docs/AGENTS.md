# AGENTS.md

모든 AI 에이전트가 따르는 표준 운영 규칙. 이 파일이 단일 기준(SSOT)이다.
`CLAUDE.md`는 Claude 전용 진입 파일일 뿐, 상세 규칙은 여기를 따른다.

## 시작 전 필수

반드시 순서대로 작업을 진행한다.

1. **[20_wiki/index.md](/20_wiki/index.md)를 먼저 읽는다.**
2. **git 작업(커밋·push·태그·릴리즈)이면 §Branch·MR과 §Versioning을 먼저 따른다.**

## 목적

프론트엔드 개발 지식을 Markdown 위키로 관리한다.

- 버저닝이 있는 raw 문서는 내부 raw 폴더에 저장하지 않고 **context7**으로 조회한다([[context7-instruction-guide]]).
- 에이전트는 판단·기준·규칙을 `/20_wiki/`에 정리 문서로 만든다.
- `/00_context/`는 잘 안 바뀌는 개인 기준을 보관한다.

## 프로젝트 연동

위키 실체는 **`~/frontend-wiki` 한 곳**에만 두고, 다른 프로젝트는 심볼릭링크로 참조한다(링크는 커밋 금지). 연동·부트스트랩·`.gitignore`·`AGENTS.md` 템플릿은 [[agent-instruction-guide]]가 SSOT다.

**위치 점검 (필수)** — 작업 전 frontend-wiki 저장소가 `$HOME/frontend-wiki`인지 확인한다. 다른 경로면 링크가 깨지고 상대경로가 어긋나므로 `$HOME`으로 옮기라고 권유한다. 사용자가 거부하면 현재 경로로 진행하되 표준이 아님을 계속 인지시킨다.

## 기본 원칙

- 답변·문서는 언어는 한국어를 기본으로 한다.
- 기본적으로 `/20_wiki/` 문서만 만들거나 수정한다. `/00_context/`는 사용자가 개인 기준 정리를 요청할 때만.
- 중요한 개념은 `[[Wikilink]]`로 연결한다.
- 출처를 남기고, 사실과 추론을 구분한다. 불확실은 `[검증 필요]`, 추론은 `[추론]`으로 표시한다.
- 새 자료를 처리하면 [20_wiki/log.md](/20_wiki/log.md)에 기록하고 필요에 따라 [20_wiki/index.md](/20_wiki/index.md) 를 업데이트한다.

## 폴더 역할

구조 트리와 폴더별 설명은 [20_wiki/index.md](/20_wiki/index.md) 구조 절이 기준이다. 여기엔 index에 없는 판단 규칙만 둔다.

- 폴더는 `principles`·`conventions`·`operations` **3개**뿐인 저장통이고, **분류의 진실은 index 목차**다. 새 분류가 필요해도 폴더를 늘리지 않고 셋 중 가까운 곳에 두고 index 제목으로 묶는다. 링크는 `[[파일명]]` 기준이라 경로 무관.
- conventions/operations 판별 질문: **"이 규칙이 개발에만 국한되나?"** YES면 conventions, 위키 등 개발 외에서도 쓰이면 operations.
- `/00_context/` 변경은 개인 기준이라 `index.md`에 넣지 않고 필요 시 `log.md`에만 남긴다. `code-style.md`·`user-profile.md`는 필요 시 생성.

## 작업 흐름

### Context First

말투·글쓰기·판단 기준이 결과물에 영향을 주는 작업은 `/00_context/`를 먼저 읽는다. 특히 사용자를 대신한 글쓰기·다듬기, 회고·기여 정리, 장문 답변·문서화가 그렇다.

- 문체는 [00_context/writing-style.md](/00_context/writing-style.md), 사실성·검증·피드백은 [00_context/thinking-principles.md](/00_context/thinking-principles.md)를 따른다.
- `/00_context/`와 일반 템플릿이 충돌하면 `/00_context/`가 우선한다. 단 출처 표기·사실/추론 구분·raw 보존은 유지한다.

### Ingest

새 자료 정리 요청이 오면:

1. 자료 성격을 판별한다. **버저닝 있는 라이브러리·프레임워크 문서면 위키에 만들지 않고 context7 조회로 안내한다**(§범위, [[context7-instruction-guide]]).
2. 판단·기준·규칙 성격이면 `/20_wiki/principles/`·`/20_wiki/conventions/`·`/20_wiki/operations/` 문서를 새로 만들거나 갱신한다.
3. frontmatter `source:`에 URL·기준일을 남긴다.
4. 관련 개념을 `[[Wikilink]]`로 잇고, `index.md`와 `log.md`를 갱신한다.

### Query

1. [20_wiki/index.md](/20_wiki/index.md)를 먼저 읽고 관련 문서를 찾는다. 라이브러리 문서가 필요하면 context7으로 조회한다.
2. 근거 문서를 명시하고 사실과 추론을 구분한다. 답변을 별도 파일로 저장하지 않는다.
3. `log.md`에 query 기록을 남긴다.

### git 반영 확인 (필수)

커밋·push·MR·tag·릴리즈처럼 원격에 반영되는 동작은 **실행 직전 옵션 선택형으로 확인한다.** 자유서술이 아니라 선택지를 제시한다.

- 예: `커밋할까요? [커밋합니다 / 아니요]`, `MR 올릴까요? [올립니다 / 아니요]`, `태그·릴리즈 진행할까요? [진행합니다 / 아니요]`
- 준비 작업(브랜치 생성·staged 확인·메시지 작성)은 확인 없이 진행하고, **반영 동작에서만** 묻는다. 사용자가 이미 "커밋/푸시 해줘"라고 명시한 그 단계는 다시 묻지 않는다.
- "아니요"면 반영하지 않고 로컬 상태만 유지한다.

### Commit

staged 변경 범위를 확인하고, 커밋 메시지는 [[commit-convention]]을 따른다.

### Branch · MR (필수)

`main`에 직접 커밋·push하지 않는다 — 사용자가 짧게 "커밋해줘"라고 해도, 브랜치가 안 적혀 있어도 예외 없다. 변경은 항상 작업 브랜치 → MR → **squash merge**. 절차 상세는 [[wiki-versioning]] 작업 절차와 [[mr-pr-guide]] 위키 MR 템플릿.

### Lint

정기 점검: 끊어진 `[[링크]]`, 고립·중복 문서, 오래된·충돌·출처 없는 주장, `index.md` 누락, 과도한 길이. 고칠 수 있으면 고치고, 판단이 필요하면 `log.md`에 남긴다.

## 문서 작성 규칙

문서 기본 구조·파일명·frontmatter·경로·링크 표기 전부 [[wiki-authoring-guide]]가 SSOT다. 문서를 만들거나 고치기 전에 그 가이드를 먼저 따른다.

## Obsidian과 프로젝트 docs 역할 분리

- **Obsidian 위키** — 순수 프론트엔드 아카이브. 어떤 프로젝트에도 강제하지 않는 참고 지식.
- **프로젝트 `docs/`·`AGENTS.md`·`CLAUDE.md`** — 그 프로젝트의 실제 실행 규칙.
- 충돌 시 **프로젝트 규칙이 우선**한다.

## 금지 사항

- 출처 없는 주장을 사실처럼 쓰기
- 불확실한 내용 단정
- 같은 개념 문서 중복 생성
- 존재하지 않는 위키링크 남기기
- `index.md`·`log.md` 갱신 누락

## 작업 후 검증

- [20_wiki/index.md](/20_wiki/index.md)와 새로 만든 문서가 정상적으로 열리는지
- `[[링크]]`가 실제 파일명·alias와 맞는지
- 필수 frontmatter가 전부 있는지([[wiki-authoring-guide]] 기준)
- `index.md`·`log.md` 갱신이 빠지지 않았는지
