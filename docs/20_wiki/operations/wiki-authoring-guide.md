---
id: operation-wiki-authoring-guide
title: 위키 작성 가이드
aliases: [위키 작성 가이드]
type: operation
status: active
created_at: 2026-07-01
created_by: 이상협
updated_at: 2026-07-02
updated_by: 이상협
last_verified_at: 2026-07-02
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "frontmatter 스키마 v2 도입"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "표기 규칙 신설 — 구분자는 쉼표, 가운뎃점(·) 금지"
tags: [common, convention, wiki, schema]
stack: common
scope: wiki-authoring
relations:
  - id: operation-wiki-versioning
    label: related
  - id: operation-agent-instruction-guide
    label: related
  - id: operation-project-wiki-guide
    label: related
---

# wiki-authoring-guide

## 한 줄 요약

모든 위키 문서의 **파일명, id, frontmatter 표준**과 **본문 파일 참조 규칙**. 메인 위키(`20_wiki/`, `00_context/`)와 개별 프로젝트(`docs/`) 위키 양쪽에 적용한다. `10_raw/`는 예외. 목차: [목차](../index.md)

## 적용 범위

- **적용** — 메인 위키 `20_wiki/`, `00_context/`, 개별 프로젝트 `docs/`의 위키 문서(worklog 등).
- **예외** — `10_raw/`(메인 위키, 프로젝트 모두). 원본 보관소라 강제하지 않는다. 현행 유지.

## 파일명 규칙

- **영어, 전부 소문자, kebab-case.** 공백 대신 하이픈(`-`). 확장자 `.md`.
- 기술 고유명도 소문자로: `nestjs`, `prisma`, `dto`, `jwt`.
- 한글은 파일명에 쓰지 않는다. 한글 제목은 frontmatter `title`로 보존한다.
- 예: `코드 리뷰` → `code-review.md`, `Prisma 트랜잭션 패턴` → `prisma-transaction-pattern.md`

## id 규칙

`id`는 문서의 안정적 식별자다. **파일명 slug에 type을 접두**한다.

```
id = <type>-<파일명 slug>
```

- 예: `principle-orm-choice`, `convention-naming-convention`, `operation-wiki-sync`, `context-writing-style`.
- **싱글턴 예외** — `index.md`는 `id: index`, `log.md`는 `id: log`(이중 접두 회피).
- `relations`는 이 `id`로 다른 문서를 가리킨다. 파일 경로가 바뀌어도 id는 유지되게 한다.

## Frontmatter 스키마

```yaml
---
id: <type>-<slug>              # 위 id 규칙
title: "사람이 읽을 한글 제목"
aliases: [한글 제목]            # 한글 제목 대체 표기, Obsidian 검색용. 한글 제목이 있으면 권장
type: principle | convention | operation | context | log | index
status: active                 # 아래 status 값 중 하나

# 생성, 갱신, 검증 추적 (git author 기준)
created_at: YYYY-MM-DD
created_by: <git author>
updated_at: YYYY-MM-DD
updated_by: <git author>
last_verified_at: YYYY-MM-DD    # 유형별 필수 — 아래 표
last_verified_by: <git author>

# 변경 이력 — 문서 관련 시간순 액션 로그
audit_log:
  - action: created            # created / updated / verified / superseded / archived
    at: YYYY-MM-DD
    by: <git author>
    commit: ""                 # 선택. commit short hash — 훅 도입 전까지 비움(아래 audit_log 참고)
    note: "선택 — 변경 사유 한 줄"

# 분류, 스택, 출처
tags: [tag1, tag2]
stack: common | nestjs         # 선택 — 스택 표기
scope: <scope-slug>            # 선택
source:                        # 선택 — raw 경로, URL, 기준일
  - ...

# 다른 위키 문서와의 관계
relations:
  - id: <다른 문서 id>
    label: related             # 아래 relations label 표준 중 하나
    note: "선택 — 관계 맥락 한 줄"
  - <다른 문서 id>              # plain 문자열 = label 없는 느슨한 참조

# 코드 파일 참조 (저장소 루트 기준 경로)
code_refs:
  - file: <저장소 루트 기준 경로>
    note: "선택"
---
```

### 전 type 공통 필수

`id`, `title`, `type`, `status`, `created_at`, `updated_at`, `tags`.

`created_by`, `updated_by`는 git author로 채운다. 단일 저자 위키는 실제 이름을 쓴다.

## type 값

| type | 용도 |
|---|---|
| `index` | 진입점 목차 (`index.md`) |
| `log` | 작업 이력 (`log.md`, 프로젝트 `worklog.md`) |
| `principle` | 원칙, 기준 — 아키텍처, 기술 선택 이유 |
| `convention` | 개발 컨벤션 — 네이밍, 커밋, MR, 코드 리뷰 |
| `operation` | 운영 규약, 가이드 — 개발 외 전반(위키, 에이전트) |
| `context` | 개인 정적 기준 (`00_context/`) |

## status 값

| status | 뜻 |
|---|---|
| `active` | 유효한 현행 문서(기본) |
| `draft` | 작성 중, 미확정 |
| `pending` | 검토, 결정 대기 |
| `superseded` | 다른 문서로 대체됨(`relations`에 `superseded-by` 명시) |
| `deprecated` | 더 이상 권장 안 함 |
| `archived` | 보관용, 현행 아님 |

`collapsed`는 문서 status가 아니라 [로그 작성 규칙](log-writing-guide.md)의 로그 **압축 항목 전용** 표기다.

## 유형별 필드 차등

공통 필수 외에, type별로 아래를 요구한다.

| type | `last_verified` | `audit_log` | `relations` | `code_refs` |
|---|---|---|---|---|
| `principle` | 필수 | 필수 | 권장 | 선택 |
| `convention` | 필수 | 권장 | 권장 | 선택 |
| `operation` | 필수 | 권장 | 권장 | 선택 |
| `context` | 선택 | 선택 | 선택 | 선택 |
| `log`, `index` | — | — | — | — |

## relations

문서 간 명시적 관계. 각 항목은 `{ id, label, note? }` 객체이거나, label 없는 느슨한 참조용 plain 문자열(id).

**label 표준**:

| label | 뜻 |
|---|---|
| `related` | 느슨한 관련 |
| `depends-on` / `required-by` | 의존 / 피의존 |
| `supersedes` / `superseded-by` | 대체함 / 대체됨 |
| `part-of` / `has-part` | 상위 / 하위 구성 |
| `references` | 참고 인용 |

## code_refs

문서가 설명, 근거로 삼는 코드 파일. **저장소 루트 기준 경로**로 적고, `note`로 맥락을 남긴다. 메인 위키는 앱 코드가 없어 대개 비운다. 개별 프로젝트 위키(worklog 등)에서 주로 쓴다.

## audit_log

문서에 일어난 시간순 액션 로그. `action`은 `created` / `updated` / `verified` / `superseded` / `archived`.

- `commit` 필드는 해당 액션을 반영한 커밋의 short hash를 위한 자리다. 문서를 쓰는 시점엔 아직 커밋 전이라 해시를 알 수 없으므로, **post-commit 훅 도입 전까지는 빈 문자열로 둔다.**
- 훅, 스킬 자동화는 별도 과제이며 이 문서 범위 밖이다.

## 문서 본문 파일 참조 규칙

위키 **문서 본문**에서 다른 문서나 파일을 참조할 때:

- **현재 파일 기준 상대경로 + 마크다운 링크**로 표기한다. 텍스트는 대상 문서 제목. 예: 같은 폴더 `[네이밍 컨벤션](naming-convention.md)`, 상위 `[목차](../index.md)`, 다른 폴더 `[커밋 컨벤션](../operations/commit-convention.md)`.
- **상대경로를 쓴다.** 저장소 루트 기준 경로(`20_wiki/...`), `/` 시작 절대경로, 머신 절대경로(`/Users/...`)는 쓰지 않는다 — 심볼릭 링크로 소비하는 프로젝트나 하위 폴더에서 깨진다. 상대경로는 위키 트리 안에서 대상 위치가 바뀌지 않는 한 유효하다.
- **백틱 단독 파일명 금지** — 저장소 안 실제 파일을 가리키면 백틱 대신 위 링크로 쓴다.
- **예외** — (1) 파일명 자체를 값, 예시로 보일 때(파일명 규칙 설명 등), (2) 이 저장소에 없는 외부 경로(`docs/worklog.md`, `.github/...` 등 링크 대상이 없는 것)는 백틱을 쓴다.
- `relations`는 경로가 아니라 `id`로 가리킨다. `code_refs`의 경로는 참조 대상 코드 저장소 기준이다.

이 규칙은 위키 문서 본문에 적용한다. 에이전트의 채팅 응답에는 강제하지 않는다.

## 표기 규칙

- 나열, 구분에는 **쉼표(`,`)**를 쓴다. **가운뎃점(`·`)은 쓰지 않는다.** 제목, frontmatter, 본문 모두 동일하다.
- YAML `aliases`처럼 쉼표가 원소 구분자인 자리에서 값 자체에 쉼표가 들어가면 따옴표로 감싼다(예: `aliases: ["Service, Rule, Policy"]`).

## 마이그레이션 절차

한글 파일명을 영문으로 바꾸거나 스키마를 갱신할 때:

1. `git mv`로 영어 kebab-case로 rename.
2. frontmatter에 `id`, `title`, `aliases`를 채우고, `created_at`/`updated_at` 등 스키마 필드를 갱신한다.
3. 이 문서를 가리키던 인바운드 링크(다른 문서의 상대경로 마크다운 링크)의 경로를 새 파일명, 위치에 맞게 갱신한다.
4. [목차](../index.md), [작업 이력](../log.md) 참조를 갱신하고, 링크 lint로 깨짐 0을 확인한다.

## 관련 문서

- [목차](../index.md)
- [위키 버전 관리](wiki-versioning.md)
- [로그 작성 규칙](log-writing-guide.md)
- [에이전트 지침 파일 작성 가이드](agent-instruction-guide.md)
- [개별 프로젝트 위키 생성 및 작성 가이드](project-wiki-guide.md)
