---
id: operation-install-guide
title: 설치 가이드 (install.sh)
aliases: [설치 가이드, install-guide, install.sh]
type: operation
status: active
created_at: 2026-07-03
created_by: 이상협
updated_at: 2026-07-03
updated_by: 이상협
last_verified_at: 2026-07-03
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-07-03
    by: 이상협
    commit: ""
    note: "루트 install.sh 통합 설치 스크립트 사용 가이드 신설"
tags: [common, operation, install, setup, tool]
stack: common
scope: tooling-install
source: "install.sh"
relations:
  - id: operation-context7-instruction-guide
    label: related
  - id: operation-superpowers-instruction-guide
    label: related
  - id: operation-humanize-korean
    label: related
  - id: convention-code-review
    label: related
---

# 설치 가이드 (install.sh)

## 한 줄 요약

저장소 루트 `install.sh` **하나로** 위키가 소개하는 도구를 전부 설치한다. OS, 에이전트, 대화형 여부를 감지해 알아서 설치하고, 이미 있으면 자연히 넘어간다. 사람도 에이전트도 실행할 수 있다. 목차: [목차](../index.md)

## 무엇을 설치하나

두 그룹으로 나눠 관리한다.

| 그룹 | 도구 |
|---|---|
| 프로젝트 셋업 도구 | mise, Node 24, pnpm, Python(+pipx), Docker |
| AI 도구 | context7(MCP), code-review-graph(MCP), im-not-ai(윤문), superpowers(스킬) |

- 프로젝트 devDeps(ESLint, Prettier, Husky 등)는 **대상이 아니다.** 각 프로젝트에서 `npm`/`pnpm`으로 설치한다([ESLint, Prettier, mise 설정](../conventions/eslint-prettier-mise.md), [Husky (git hooks)](../conventions/husky-git-hooks.md)).
- code-review-graph의 `build`는 대상 프로젝트에서 실행한다([코드 리뷰](../conventions/code-review.md)).

> **설치 위치 (중요)** — 위 도구는 mise, Node, Python, Docker와 AI 도구(context7, superpowers, code-review-graph, im-not-ai)를 가리지 않고 **모두 사용자 전역(`~/`)에 설치한다**(mise는 `~/.local`, im-not-ai는 `~/.tools`, 스킬, 플러그인은 `~/.claude` 등). **프로젝트 디렉토리 안에 클론하거나 설치하지 않는다.** 프로젝트 안에서 실행하는 것은 code-review-graph `build`(대상 프로젝트 그래프)와 각 프로젝트 devDeps뿐이다. 개별 설치를 할 때도 클론 경로를 `$HOME` 아래로 지정한다.

## 실행

**두 단계다. `--dry-run`만으로는 아무것도 설치되지 않는다. 반드시 2단계까지 진행한다.**

1. (선택) 미리보기 — 무엇이 설치될지 계획만 출력. 설치는 하지 않는다.
   ```bash
   ./install.sh --dry-run
   ```
   여기서 멈추면 설치가 안 된 것이다. 반드시 2단계로 넘어간다.

2. (필수) 실제 설치 — 없는 것만 설치, 이미 있으면 건너뜀(멱등).
   ```bash
   ./install.sh
   ```

- 이미 설치된 도구는 `[ok] ... 이미 있음`, 설치 예정은 `[dry] ...`로 구분된다.
- 기타 플래그: `--no-remote`(curl|sh 원격 설치 건너뜀), `--help`(사용법).

### 플래그, 환경변수

| 플래그 | 동작 |
|---|---|
| `--dry-run`, `-n` | 계획만 출력, 아무것도 설치, 수정하지 않는다 |
| `--no-remote` | 원격 스크립트 단계를 건너뛰고 수동/패키지 안내로 대체 |
| `--help`, `-h` | 사용법 출력 후 종료 |

| 환경변수 | 동작 |
|---|---|
| `NONINTERACTIVE=1` | 대화형 단계를 건너뛰고 "다음 단계"로 안내(에이전트, CI용) |
| `TOOLS_DIR` | 클론 위치(기본 `$HOME/.tools`) |
| `MISE_VERSION` | mise 설치 버전 핀(원격 스크립트에 전달) |
| `VERSION` | Docker 설치 버전 핀(Linux 원격 스크립트에 전달) |

## 설치 확인 (필수)

설치 명령을 실행했다고 끝이 아니다. **각 도구가 실제로 설치되고 연결됐는지 확인한 뒤에 넘어간다. 됐다고 가정하지 않는다.** 특히 에이전트 세션에서 직접 실행하는 "다음 단계" 항목(context7, superpowers 등)은 실행 후 반드시 확인한다.

- context7 — MCP 연결 확인(예: `claude mcp list`). 실패면 [context7 사용 가이드](context7-instruction-guide.md).
- superpowers — 세션에서 스킬, 명령이 뜨는지 확인. 실패면 재시작 후 [superpowers 사용 가이드](superpowers-instruction-guide.md).
- code-review-graph — MCP 등록 확인. 실패면 [코드 리뷰](../conventions/code-review.md).
- im-not-ai(Humanize KR) — 스킬(`/humanize`)이 뜨는지 확인. 실패면 [Humanize KR (im-not-ai) 사용 가이드](humanize-korean.md).
- mise, Node, Python, Docker — `mise --version`, `node -v`, `python3 --version`, `docker --version`.

확인 실패 시: 재시작 후 다시 확인 → 그래도 실패면 해당 지침으로 개별 설치 → 재확인. 확인될 때까지 다음으로 넘어가지 않는다.

## 어떻게 동작하나

- **OS 감지** — macOS(Homebrew), Linux(apt/dnf/yum/pacman/zypper)를 감지해 맞는 패키지 매니저를 쓴다.
- **대화형 감지** — TTY가 없거나 `CI=true`, `NONINTERACTIVE=1`이면 비대화형으로 판단한다. 멈출 수 있는 대화형 설치(예: `npx ctx7 setup`)는 실행하지 않고 **"다음 단계"** 안내로 미룬다.
- **에이전트 감지(superpowers)** — CLI로 설치되는 에이전트(copilot, agy, droid, pi)는 스크립트가 설치하고, 세션 내부 슬래시 명령으로만 설치되는 에이전트(Claude Code, Codex, Cursor, opencode)는 **"다음 단계"**에 명령을 출력한다. 이건 사람이나 에이전트가 자기 세션에서 직접 실행해야 한다.
- **멱등** — 여러 번 실행해도 안전하다. 있으면 건너뛰고 없는 것만 설치한다.

## 설치가 안 될 때 (개별 지침 폴백)

`install.sh`가 어떤 도구를 설치하지 못하면(권한, 비대화형, 원격 차단 등) 실패나 미설치로 표시된다. 그 도구는 아래 각 지침으로 개별 설치한다.

- context7 → [context7 사용 가이드](context7-instruction-guide.md)
- superpowers → [superpowers 사용 가이드](superpowers-instruction-guide.md)
- code-review-graph → [코드 리뷰](../conventions/code-review.md)
- im-not-ai(Humanize KR) → [Humanize KR (im-not-ai) 사용 가이드](humanize-korean.md)
- mise/Node/Docker → 각 공식 설치 안내(스크립트 "다음 단계" 출력 참고)

## 보안 (원격 실행)

mise, Homebrew, Docker(Linux)는 공식 업스트림 설치 스크립트를 HTTPS로 받아 실행한다(mise.run, Homebrew install.sh, get.docker.com). 안정 체크섬이 없어 핀은 못 하고, 업스트림을 신뢰한다는 전제다.

- 원격 실행을 피하려면 `--no-remote`로 건너뛰고 수동이나 패키지로 설치한다.
- 버전 핀이 필요하면 `MISE_VERSION=...`, (Docker) `VERSION=...` 환경변수로 전달한다.

## 관련 문서

- [context7 사용 가이드](context7-instruction-guide.md)
- [superpowers 사용 가이드](superpowers-instruction-guide.md)
- [Humanize KR (im-not-ai) 사용 가이드](humanize-korean.md)
- [코드 리뷰](../conventions/code-review.md)

## 출처

- `install.sh` (저장소 루트)
- 기준일 2026-07-03
