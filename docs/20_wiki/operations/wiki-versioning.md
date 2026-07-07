---
id: operation-wiki-versioning
title: 위키 버전 관리
aliases: [위키 버전 관리]
type: operation
status: active
created_at: 2026-06-25
created_by: 이상협
updated_at: 2026-07-01
updated_by: 이상협
last_verified_at: 2026-07-01
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-06-25
    by: 이상협
    commit: ""
  - action: updated
    at: 2026-07-01
    by: 이상협
    commit: ""
    note: "frontmatter 스키마 v2"
tags: [common, convention, wiki, version]
stack: common
scope: wiki-versioning
relations:
  - id: operation-wiki-sync
    label: related
  - id: operation-mr-pr-guide
    label: related
---

# 위키 버전 관리

## 한 줄 요약

위키 버전은 [목차](../index.md) frontmatter의 `version` 값으로 관리한다. 형식은 SemVer를 빌려온다.

```txt
MAJOR.MINOR.PATCH
```

1.0 전까지는 `0.MINOR.PATCH`를 쓰고, `1.0.0`은 팀 공유 기준선이 안정됐을 때만 올린다(기준은 아래 [1.0.0 기준](#100-기준) 참고).

## 올리는 기준

여러 변경이 섞이면 가장 높은 기준 하나만 적용한다.

`minor`는 **드물게** 올린다. 1.0 전까지 `minor`는 곧 마일스톤이다. 하루 2회 이상이면 기준을 잘못 적용했을 가능성이 높으니 다시 검토한다.

### MINOR — 아래 셋 중 하나를 충족할 때만

`minor`는 **위키 범위, 능력의 의미 있는 확장** 또는 **에이전트 작동 방식의 구조 변경**이다. "전엔 못 하던 걸 하게 됨" 수준.

1. **새 카테고리 + 실제 문서 3개 이상.** 1~2개거나 빈 카테고리는 `patch`.
2. **대형 ingest.** 새 raw 묶음으로 개념 문서 3개 이상 신설 + index 연결.
3. **작동 방식 구조 변경.** 판정 질문 = "이 변경 후 에이전트가 실제로 다르게 동작하나?" YES면 `minor`. (예: ingest 흐름 단계 추가, 삭제, 폴더 역할 재정의, 경로 resolver 도입, 새 필수 선행 읽기 규칙)

### PATCH — 그 외 파일 변경 전부

| 변경 | 예시 |
|---|---|
| 기존 컨벤션 보강 | 절차, 항목, 예외 추가 |
| 문서 이동, 이름 변경 | 폴더, 파일명 변경 |
| 단일 문서 신설 | 새 문서 1~2개, 워크플로 변화 없음 |
| 판단 기준 조정 | 기술결정 결론 변경, 컨벤션 문구 수정 |
| 기존 문서 보강 | 설명, 예시, 출처 추가 (양 많아도 patch) |
| 오탈자, 표현 수정 | 의미 변화 없는 정리 |
| 링크, index, log 보정 | 누락 링크, 오래된 목차 갱신 |

파일 변경 없는 단순 질문 답변은 **버전 변경 없음**.

### 경계 케이스

| 상황 | 판정 | 이유 |
|---|---|---|
| 새 컨벤션 문서 1개, 워크플로 안 바뀜 | patch | 참고용 추가 |
| 새 컨벤션 + AGENTS 흐름에 강제 단계 생김 | minor | 작동 방식 변경(#3) |
| 카테고리 + 문서 2개 | patch | 3개 미만 |
| 기존 문서 10개 대량 보강 | patch | 양 ≠ 범위 확장 |
| 기술결정 결론 뒤집음 | patch | 단일 판단, 범위 그대로 |

### 릴리즈 케이던스

- `patch`는 **누적**한다. 매 편집마다 tag, release를 만들지 않는다.
- 릴리즈 시점: `minor` 발생 시, 또는 `patch`가 쌓여 한 묶음으로 의미가 생길 때.

## 작업 절차

1. 변경 범위를 확인한다.
2. GitLab Release 최신 tag와 [목차](../index.md)의 `version`을 비교한다. 불일치 시 [위키 동기화](wiki-sync.md)의 "원격 버전 동기화"를 따른다.
3. 이 문서 기준으로 `minor` / `patch`를 고른다.
4. [목차](../index.md)의 `version`과 `updated`를 갱신한다.
5. [작업 이력](../log.md)에 날짜, 이전 버전, 새 버전, bump 이유를 최신 항목으로 추가한다(단일 파일, 최신순).
6. 작업 브랜치에 커밋 → push → MR 생성([MR PR 작성 가이드](mr-pr-guide.md) 위키 MR 템플릿). `main` 직접 커밋 금지.
8. MR은 **반드시 squash merge**한다. 머지로 `main`이 갱신된 뒤 `vX.Y.Z` tag 생성(`v` + index의 `version`) → tag push.
9. GitLab Release를 만든다. 제목은 tag와 같게, 본문에는 해당 날짜 log의 버전 변경 요약을 압축해 적는다.

## 1.0.0 기준

아래를 만족하면 `1.0.0` 검토 가능.

- `AGENTS.md`와 주요 `에이전트 지침 파일 작성 가이드`가 팀 공유 방식까지 포함.
- [목차](../index.md)가 핵심 문서를 빠짐없이 가리킴.
- 주요 문서가 출처, 스택, 상태를 가짐.
- 링크 lint 기준이 정해져 있고 큰 깨짐 없음.
- 공통 지식과 프로젝트 맥락 문서 역할이 명확히 분리됨.

## 관련 문서

- [목차](../index.md)
- [에이전트 지침 파일 작성 가이드](agent-instruction-guide.md)
