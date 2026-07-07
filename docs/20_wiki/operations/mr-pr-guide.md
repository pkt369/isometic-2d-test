---
id: operation-mr-pr-guide
title: MR PR 작성 가이드
aliases: [MR PR 작성 가이드]
type: operation
status: active
created_at: 2026-06-19
created_by: 이상협
updated_at: 2026-07-01
updated_by: 이상협
last_verified_at: 2026-07-01
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
    note: "백엔드 기준 전환(스크린샷→API 근거), frontmatter 스키마 v2"
tags: [common, git, mr, pr]
stack: common
relations:
  - id: operation-commit-convention
    label: related
---

# MR / PR 작성 가이드

GitLab(MR), GitHub(PR) 공통 규칙. AI가 리뷰 요청 작성 시 따름. 목차: [목차](../index.md)

| | GitLab | GitHub |
|---|---|---|
| 용어 | MR | PR |
| 템플릿 | `.gitlab/merge_request_templates/Default.md` | `.github/pull_request_template.md` |

## 1. 작성 전 — Git 상태 확인 (필수)
브랜치를 **추측 금지**. 실제 Git 상태 확인 후 사용자에게 공유:
```md
현재 브랜치: test/example
target 브랜치: main
비교 기준 커밋: target123
포함 커밋 범위: test123 ~ test789
포함 커밋:
- feat(auth): 테스트1
- fix(auth): 테스트2
```
사용자 확인 전까지 제목, 본문 확정 안 함.

## 2. 작업 범위
- target에서 갈라진 지점 이후 ~ 현재 HEAD까지.
- 비교 기준 커밋(target에 이미 있는 것)은 범위에 **불포함**.
- 커밋 1개면 시작=끝 동일.
- ❌ 금지: 저장소 최초/target 전체 히스토리부터 계산, 브랜치 미확인 상태 작성, target 변경을 현재 작업처럼 포함.

## 3. 제목
- [커밋 컨벤션](commit-convention.md) `type(scope): subject` 형식.
- 현재 브랜치 변경 범위 대표 핵심. 여러 작업이면 중심 변경 하나.

## 4. 변경 요약
- 변경 단위 분리. 한 bullet에 여러 작업 묶지 않음.
```md
✅ - 로그인 API 엔드포인트 추가
   - 비밀번호 필수값 검증 추가
❌ - 로그인 API 만들고, 검증도 넣고, 토큰 발급 로직도 분리했습니다.
```

## 5. 변경 내용
- 요약보다 구체, 과한 구현 설명 X. 종결문 **명사형** (`사용자 조회 API 추가`).
- 체크박스: 기능추가/버그수정/리팩터링/성능/문서, 설정/기타 중 해당만.

## 6. 테스트/검증
- 실제 수행했거나 성격상 필요한 항목만 체크. **확인 안 한 테스트 체크 금지.**
- 문서, 설정 변경은 검증 절차 장황하게 X.

## 7. 동작 근거 (API 예시, 로그)
백엔드는 화면이 없으므로 스크린샷 대신 **API 동작, 로그**로 변경 근거를 남긴다.
- API 변경 시 요청/응답 예시를 첨부(`curl`, HTTP 예시 + 상태 코드, 응답 본문). 없으면 `API 변경 없음`.
- 스키마, 마이그레이션(Prisma) 변경이면 변경 전, 후 스키마 차이나 마이그레이션 요약을 남긴다.
- 관찰 가능한 동작 변화(에러 처리, 로그 포맷 등)는 관련 로그 조각으로 보인다.
- 재현, 검증이 필요하지만 하지 못했으면 `동작 확인 필요`로 남기고 이유를 적는다. **확인 안 한 동작을 확인한 것처럼 쓰지 않는다.**

## 8. AI 작성 규칙
- 플랫폼 템플릿 섹션 구조 유지, 질문 문구는 실제 답변으로 대체.
- 브랜치, 범위 먼저 확인, 커밋 범위 사용자 공유 후 작성.
- 확인 안 된 검증을 수행한 것처럼 쓰지 않음.
- API, 스키마 변경이면 요청/응답 예시, 로그로 동작 근거를 남김. 확인 못 했으면 `동작 확인 필요`로 명시(§7).

## 9. 위키 MR 템플릿 (이 저장소 전용)

이 위키(`~/backend-wiki`)는 `main` 직접 커밋 금지 — 작업 브랜치 → MR 필수(`AGENTS.md` §Branch, MR). UI가 없으므로 스크린샷, 테스트 절차는 생략하고 아래 간단 템플릿을 쓴다.

```md
## 변경 요약
- (변경 단위별 bullet, 명사형)

## 변경 문서
- `경로/문서.md` — 무엇을

## 버전
- bump: none | patch | minor (사유)
- index.version: X.Y.Z → X.Y.Z

## 체크
- [ ] index, log 갱신 (해당 시)
- [ ] 링크 끊김 없음
- [ ] squash merge ([위키 버전 관리](wiki-versioning.md))
- [ ] 머지 후 tag, Release ([위키 버전 관리](wiki-versioning.md))
```

제목은 `type(scope): subject`([커밋 컨벤션](commit-convention.md)). 버전 bump가 없으면 `버전` 섹션에 `none` 명시.
머지는 **반드시 squash**(`main` 이력 1커밋/MR).

## 관련
[커밋 컨벤션](commit-convention.md)
