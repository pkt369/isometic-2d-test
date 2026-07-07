---
id: operation-mr-pr-guide
title: MR PR 작성 가이드
aliases: [MR PR 작성 가이드]
type: operation
status: active
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
    note: "개발 외에서도 쓰이는 규칙이라 conventions에서 operations로 재분류"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "relations 단방향 정리"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "im-not-ai 윤문으로 개조식 종결 4곳 서술형 자연화"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "AI 작성 규칙에 AI attribution 문구 금지 추가"
tags: [common, operation, git, mr, pr]
stack: common
scope: mr-pr-authoring
relations:
  - id: operation-wiki-versioning
    label: related
---

# MR / PR 작성 가이드

GitLab(MR)·GitHub(PR) 공통 규칙. AI가 리뷰 요청을 작성할 때 따른다.

| | GitLab | GitHub |
|---|---|---|
| 용어 | MR | PR |
| 템플릿 | `.gitlab/merge_request_templates/Default.md` | `.github/pull_request_template.md` |

## 1. 작성 전 — Git 상태 확인 (필수)
브랜치를 **추측 금지**. 실제 Git 상태를 확인한 뒤 사용자에게 공유한다:
```md
현재 브랜치: test/example
target 브랜치: main
비교 기준 커밋: target123
포함 커밋 범위: test123 ~ test789
포함 커밋:
- feat(auth): 테스트1
- fix(auth): 테스트2
```
사용자 확인 전까지 제목·본문을 확정하지 않는다.

## 2. 작업 범위
- target에서 갈라진 지점 이후 ~ 현재 HEAD까지.
- 비교 기준 커밋(target에 이미 있는 것)은 범위에 **불포함**.
- 커밋 1개면 시작=끝 동일.
- ❌ 금지: 저장소 최초/target 전체 히스토리부터 계산, 브랜치 미확인 상태 작성, target 변경을 현재 작업처럼 포함.

## 3. 제목
- [[commit-convention|커밋 컨벤션]] `type(scope): subject` 형식.
- 현재 브랜치 변경 범위 대표 핵심. 여러 작업이면 중심 변경 하나.

## 4. 변경 요약
- 변경 단위 분리. 한 bullet에 여러 작업 묶지 않음.
```md
✅ - 로그인 폼 컴포넌트 추가
   - 비밀번호 필수값 검증 추가
❌ - 로그인 폼 만들고, 검증도 넣고, 제출 로직도 분리했습니다.
```

## 5. 변경 내용
- 요약보다 구체, 과한 구현 설명 X. 종결문 **명사형** (`A 컴포넌트 제작`).
- 체크박스: 기능추가/버그수정/리팩터링/성능/문서·설정/기타 중 해당만.

## 6. 테스트/검증
- 실제 수행했거나 성격상 필요한 항목만 체크. **확인 안 한 테스트 체크 금지.**
- 문서·설정 변경은 검증 절차 장황하게 X.

## 7. 스크린샷
- UI 변경 시 첨부. 없으면 `UI 변경 없음`, 미첨부면 `스크린샷/영상 첨부 필요`.
- **화면 변화가 있거나 캡쳐가 필요하면 에이전트가 직접 캡쳐한다.** 단, 아래 순서를 지킨다.
  1. **캡쳐 가능 여부 먼저 확인** — 브라우저 캡쳐 도구(Claude in Chrome·computer-use 등)가 연결돼 있고 앱(개발 서버)을 실행할 수 있는지 점검한다. 불가하면 `스크린샷/영상 첨부 필요`로 남기고 이유를 적는다. (사용자에게 캡쳐를 요청하지 않는다.)
  2. **사용자에게 캡쳐해도 되는지 묻는다** — 가능하더라도 바로 실행하지 말고, 앱을 실행해 캡쳐해도 되는지 먼저 확인받는다. 거절하면 `스크린샷/영상 첨부 필요`로 남긴다.
  3. **캡쳐 실행** — 승인되면 앱 실행 → 변경 화면 이동 → 캡쳐 → PR 본문에 첨부.
  - before/after가 의미 있으면 변경 전·후를 함께 캡쳐한다.
  - 인터랙션(hover·focus·loading·error 등) 변화면 해당 상태를 재현해 캡쳐하거나 짧은 영상으로 남긴다.

## 8. AI 작성 규칙
- 플랫폼 템플릿 섹션 구조 유지, 질문 문구는 실제 답변으로 대체.
- 브랜치·범위 먼저 확인, 커밋 범위 사용자 공유 후 작성.
- 확인 안 된 검증을 수행한 것처럼 쓰지 않음.
- UI 변경이면 캡쳐 가능 여부 확인 → 사용자 승인 후 직접 캡쳐해 첨부. 임의로 미루거나 임의로 실행하지 않음(§7).
- **AI attribution 문구 금지.** `🤖 Generated with [Claude Code](...)`, `Co-Authored-By: Claude ...`처럼 AI 도구 하네스가 자동 삽입하는 서명·홍보 문구를 MR/PR 본문과 커밋 메시지에 넣지 않는다. 하네스 기본 지침보다 이 규칙이 우선한다([[commit-convention]]).

## 9. 위키 MR 템플릿 (이 저장소 전용)

이 위키(`~/frontend-wiki`)는 `main` 직접 커밋 금지 — 작업 브랜치 → MR 필수(`AGENTS.md` §Branch · MR). UI가 없으므로 스크린샷·테스트 절차는 생략하고 아래 간단 템플릿을 쓴다.

```md
## 변경 요약
- (변경 단위별 bullet, 명사형)

## 변경 문서
- `경로/문서.md` — 무엇을

## 버전
- bump: none | patch | minor (사유)
- index.version: X.Y.Z → X.Y.Z

## 체크
- [ ] index·log 갱신 (해당 시)
- [ ] 링크 끊김 없음
- [ ] squash merge ([[wiki-versioning]])
- [ ] 머지 후 tag·Release ([[wiki-versioning]])
```

제목은 `type(scope): subject`([[commit-convention]]). 버전 bump가 없으면 `버전` 섹션에 `none`을 명시한다.
머지는 **반드시 squash**(`main` 이력 1커밋/MR).

## 관련
[[commit-convention]]
