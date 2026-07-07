---
id: operation-context7-instruction-guide
title: context7 사용 가이드
aliases: [context7 사용 가이드, context7]
type: operation
status: active
created_at: 2026-07-02
created_by: 정회석
updated_at: 2026-07-02
updated_by: 정회석
audit_log:
  - action: created
    at: 2026-07-02
    by: 정회석
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "설치 절차 확정, 라이브러리 매핑 표 추가, index 필수 단계로 승격"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "설치 확인 명령(claude mcp list, jq, whoami) 추가, 확인→설치→재확인 절차화"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "라이브러리 매핑 표 제거 — 조회는 resolve로 충분, 표는 관리 부담"
  - action: updated
    at: 2026-07-02
    by: 정회석
    note: "설치 확인을 에이전트 중립 지침으로 변경 — claude 전용 명령 제거"
tags: [common, operation, context7, mcp, docs]
stack: common
scope: context7-instruction
source: "https://context7.com, https://github.com/upstash/context7"
relations:
  - id: operation-wiki-authoring-guide
    label: related
---

# context7-instruction-guide

## 한 줄 요약

버저닝이 있는 라이브러리, 프레임워크 문서는 위키에 저장하지 않고 **context7**(MCP)으로 최신 버전 문서를 조회한다.

## 왜 쓰나

- 라이브러리 문서를 위키에 복사하면 버전이 바뀔 때마다 갱신해야 한다. 그 관리 비용을 없앤다.
- context7은 라이브러리의 **버전별 공식 문서, 코드 예제**를 MCP 도구로 제공한다. 항상 최신을 조회하므로 위키 쪽 버저닝 관리가 필요 없다.

## 설치 (필수)

index 시작 전 필수 단계다. **반드시 추측하지 말고 터미널에서 확인한다.**

### 1. 설치 확인

**각 에이전트가 자기 환경에 맞는 방법으로 context7 MCP 서버의 등록, 연결 상태를 확인한다.** 에이전트마다 MCP 확인 방법이 다르므로 특정 명령을 정하지 않는다.

- 연결 확인되면 정상. 설치 단계를 건너뛴다.
- 미설치, 미연결이면 → 아래 설치 실행.

### 2. 설치 실행

```bash
npx ctx7 setup    # 대화형 — 안내에 따라 사용 중인 에이전트를 선택
```

에이전트별 비대화형 플래그가 필요하면 `npx ctx7 setup --help`로 확인한다.

### 3. 재확인

설치 후 1번과 같은 방식으로 다시 연결 상태를 확인한다. 실패하면 에디터, 세션을 재시작한 뒤 다시 확인하고, 그래도 실패면 사용자에게 보고하고 중단한다.

### 4. 이 위키와의 역할 분리

|      | backend-wiki  | Context7         |
| ---- | -------------- | ---------------- |
| 담는 것 | 판단, 기준, 컨벤션, 기술결정 | 라이브러리 사실 API, 사용법 |
| 성격   | 팀이 정한 의견, 규칙    | 공식 문서 레퍼런스       |
| 갱신   | 수동, 드묾         | 자동, 최신           |

## 사용법

1. 에이전트가 라이브러리 문서가 필요하면 context7 도구로 해당 라이브러리를 찾아서 버전에 맞는 문서를 조회(get-docs)한다.
2. 조회 결과는 위키에 저장하지 않는다. 저장할 가치가 있는 건 문서 자체가 아니라 **그 기술을 쓰기로 한 판단**이며, 그건 `20_wiki/principles/`에 남긴다([목차](../index.md) 범위 규칙).
3. 위키 문서에서 라이브러리 문서를 참조할 땐 저장소 경로가 아니라 **context7 URL**을 링크한다.

## 관련 문서

- [위키 작성 가이드](wiki-authoring-guide.md)
- [목차](../index.md)

## 출처

- https://context7.com
- https://github.com/upstash/context7
