#!/usr/bin/env bash
# install.sh — backend-wiki가 참조하는 도구 일괄 설치 (OS/에이전트 자동 감지, idempotent)
#
# 사람도, 에이전트도 실행할 수 있다.
#   - 대화형(사람, TTY): 대화형 설치 단계까지 진행한다.
#   - 비대화형(에이전트/CI): 멈추는 대화형/권한 단계는 건너뛰고, 셸로 끝낼 수 없는 작업은
#     끝의 "다음 단계" 목록으로 낸다 → 에이전트가 자기 세션에서 실행.
#   - 강제 비대화형: NONINTERACTIVE=1 ./install.sh
#
# 도구는 두 그룹으로 나뉜다.
#   [프로젝트 셋업 도구]  mise, Node 24, pnpm, Python(+pipx), Docker
#   [AI 도구]            context7(MCP), code-review-graph(MCP), im-not-ai(윤문), superpowers(스킬)
# 프로젝트 devDeps(eslint/prettier/husky 등)는 각 프로젝트에서 설치한다(대상 아님).
#
# 보안 주의(원격 실행):
#   mise, Homebrew, Docker(Linux)는 공식 업스트림 설치 스크립트를 HTTPS로 받아 실행한다
#   (https://mise.run, Homebrew install.sh, https://get.docker.com). 안정 체크섬이 없어 핀은 못 하고,
#   업스트림을 신뢰한다는 전제다.
#   - 원격 실행을 피하려면: --no-remote  (원격 스크립트 단계를 건너뛰고 수동/패키지로 안내)
#   - 버전 핀이 필요하면 환경변수로: MISE_VERSION=... , (Docker) VERSION=...  ./install.sh

# shellcheck disable=SC2015
# (A && B || C 패턴 다수 사용. B는 항상 ok/info/warn = printf 래퍼라 실패하지 않으므로
#  성공 시 C가 실행되는 SC2015 위험은 없다. 검토 완료.)
set -uo pipefail

c_green=$'\033[32m'; c_yellow=$'\033[33m'; c_red=$'\033[31m'; c_cyan=$'\033[36m'; c_bold=$'\033[1m'; c_dim=$'\033[2m'; c_reset=$'\033[0m'
info(){ printf '%s[..]%s %s\n' "$c_dim" "$c_reset" "$*"; }
ok(){   printf '%s[ok]%s %s\n' "$c_green" "$c_reset" "$*"; }
warn(){ printf '%s[!!]%s %s\n' "$c_yellow" "$c_reset" "$*"; }
err(){  printf '%s[xx]%s %s\n' "$c_red" "$c_reset" "$*"; }
group(){ printf '\n%s== %s ==%s\n' "$c_bold" "$*" "$c_reset"; }
have(){ command -v "$1" >/dev/null 2>&1; }

FAILED=(); NEXT=()          # NEXT: 셸로 끝낼 수 없어 세션/사람이 실행할 것
TOOLS_DIR="${TOOLS_DIR:-$HOME/.tools}"

INTERACTIVE=1
{ [ ! -t 0 ] || [ "${CI:-}" = "true" ] || [ "${NONINTERACTIVE:-}" = "1" ]; } && INTERACTIVE=0

DRY=0; REMOTE=1
for a in "$@"; do case "$a" in
  --dry-run|-n) DRY=1 ;;
  --no-remote)  REMOTE=0 ;;
  --help|-h) echo "사용법: ./install.sh [--dry-run|-n] [--no-remote]";
             echo "  --dry-run    설치하지 않고 무엇을 설치할지 계획만 출력";
             echo "  --no-remote  curl|sh 원격 설치(mise/Homebrew/Docker) 건너뛰고 수동/패키지로 안내"; exit 0 ;;
esac; done
would(){ printf '%s[dry]%s %s\n' "$c_cyan" "$c_reset" "$*"; }   # dry-run: 설치 대신 계획

# ===========================================================================
# 공통 감지/도우미
# ===========================================================================
OS=""; PKG=""; SUDO=""
detect_os(){
  case "$(uname -s)" in Darwin) OS=macos;; Linux) OS=linux;; *) OS=unknown;; esac
  if [ "$OS" = linux ]; then
    for m in apt-get dnf yum pacman zypper; do have "$m" && { PKG="$m"; break; }; done
    [ "$(id -u)" -ne 0 ] && have sudo && SUDO="sudo"
  fi
  ok "OS: $OS${PKG:+ ($PKG)} / $([ "$INTERACTIVE" -eq 1 ] && echo 대화형 || echo 비대화형)"
}
can_sudo(){ [ -z "$SUDO" ] && return 0; [ "$INTERACTIVE" -eq 1 ] && return 0; sudo -n true 2>/dev/null; }
pkg_install(){
  can_sudo || { warn "sudo 불가(비대화형) — 건너뜀: $*"; return 1; }
  case "$PKG" in
    apt-get) $SUDO apt-get update -y && $SUDO apt-get install -y "$@" ;;
    dnf) $SUDO dnf install -y "$@" ;; yum) $SUDO yum install -y "$@" ;;
    pacman) $SUDO pacman -Sy --noconfirm "$@" ;; zypper) $SUDO zypper install -y "$@" ;;
    *) return 1 ;;
  esac
}
run_npx(){ if have mise; then mise exec -- npx "$@"; else npx "$@"; fi; }

# ===========================================================================
# [프로젝트 셋업 도구]  mise / Node / Docker
# ===========================================================================
ensure_prereqs(){
  if [ "$OS" = macos ] && ! have brew; then
    if [ "$DRY" -eq 1 ]; then would "Homebrew 설치";
    elif [ "$REMOTE" -eq 0 ]; then warn "원격 설치 비활성(--no-remote) — Homebrew 건너뜀"; NEXT+=("Homebrew 설치: https://brew.sh");
    else
      info "Homebrew 설치 중..."
      # [원격실행] Homebrew 공식 install.sh (HTTPS, 체크섬 핀 없음)
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { err "Homebrew 실패"; FAILED+=("brew"); }
      [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
      [ -x /usr/local/bin/brew ]    && eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  for bin in git curl; do
    have "$bin" && continue
    [ "$DRY" -eq 1 ] && { would "$bin 설치"; continue; }
    info "$bin 설치 중..."
    if [ "$OS" = macos ]; then have brew && brew install "$bin"; else pkg_install "$bin"; fi
  done
}
setup_mise(){
  if have mise; then ok "mise 이미 있음 ($(mise --version 2>/dev/null))"; return; fi
  [ "$DRY" -eq 1 ] && { would "mise 설치: curl https://mise.run | sh"; return; }
  if [ "$REMOTE" -eq 0 ]; then
    if have brew; then info "mise 설치 중 (brew)..."; brew install mise && ok "mise(brew) 설치" || { err "mise 실패"; FAILED+=("mise"); }; return; fi
    warn "원격 설치 비활성(--no-remote) — mise 건너뜀"; NEXT+=("mise 설치: brew install mise 또는 https://mise.run"); return
  fi
  info "mise 설치 중..."
  # [원격실행] mise 공식 설치 스크립트 (HTTPS). 버전 핀: MISE_VERSION=... ./install.sh
  if curl -fsSL https://mise.run | sh; then
    export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
    have mise && ok "mise 설치 완료" || warn "mise 설치됨 — rc에 'eval \"\$(mise activate)\"' 추가 후 새 셸"
  else err "mise 설치 실패"; FAILED+=("mise"); fi
}
setup_node(){
  export PATH="$HOME/.local/share/mise/shims:$PATH"
  # Node 24
  if have mise && mise ls node 2>/dev/null | grep -q .; then ok "Node(mise) 이미 있음"
  elif [ "$DRY" -eq 1 ]; then would "Node 24 설치: mise use -g node@24"
  elif ! have mise; then warn "mise 없음 — Node 건너뜀"; return
  else info "Node 24 설치 중..."; mise use -g node@24 && ok "Node 24 완료" || { err "Node 실패"; FAILED+=("node"); }; fi
  # pnpm도 mise로 관리(corepack 대신)
  have mise || return
  if mise ls pnpm 2>/dev/null | grep -q .; then ok "pnpm(mise) 이미 있음"
  elif [ "$DRY" -eq 1 ]; then would "pnpm 설치: mise use -g pnpm@latest"
  else info "pnpm 설치 중..."; mise use -g pnpm@latest && ok "pnpm 완료" || warn "pnpm 설치 확인 필요"; fi
}
setup_python(){   # code-review-graph(pip/pipx) 전제
  export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
  if have python3; then ok "Python 있음 ($(python3 --version 2>/dev/null))"
  elif [ "$DRY" -eq 1 ]; then would "Python 설치: mise use -g python@3.12"; return
  elif have mise; then info "Python 설치 중 (mise)..."; mise use -g python@3.12 && ok "Python 설치" || { err "Python 실패"; FAILED+=("python"); return; }
  else warn "Python, mise 모두 없음 — 건너뜀"; NEXT+=("Python 3.10+ 설치 후 재실행"); return; fi
  if have pipx; then ok "pipx 있음"
  elif [ "$DRY" -eq 1 ]; then would "pipx 설치: python3 -m pip install --user pipx"
  else info "pipx 설치 중..."; { python3 -m pip install --user pipx && python3 -m pipx ensurepath; } >/dev/null 2>&1 && ok "pipx 설치" || warn "pipx 설치 실패 — pip로 대체"; fi
}
setup_docker(){
  if have docker; then ok "Docker 있음 ($(docker --version 2>/dev/null | head -1))"; return; fi
  [ "$DRY" -eq 1 ] && { would "Docker 설치 (mac: colima+docker / linux: get.docker.com)"; return; }
  info "Docker 설치 중 ($OS)..."
  case "$OS" in
    macos)
      if have brew; then brew install colima docker docker-compose && colima start && ok "Docker(colima) 설치, 시작" || { err "Docker 실패"; FAILED+=("docker"); }
      else NEXT+=("Docker 설치: https://docs.docker.com/get-docker/"); fi ;;
    linux)
      if [ "$REMOTE" -eq 0 ]; then warn "원격 설치 비활성(--no-remote) — Docker 건너뜀"; NEXT+=("Docker 설치: 배포판 패키지 또는 https://get.docker.com"); return; fi
      if ! can_sudo; then warn "sudo 불가 — Docker 건너뜀"; NEXT+=("curl -fsSL https://get.docker.com | sudo sh   # Docker"); return; fi
      # [원격실행] Docker 공식 편의 스크립트 (HTTPS). 버전 핀: VERSION=... 환경변수
      if curl -fsSL https://get.docker.com | $SUDO sh; then $SUDO usermod -aG docker "$USER" 2>/dev/null || true; ok "Docker 설치(그룹 반영에 재로그인 필요할 수 있음)"
      else err "Docker 실패"; FAILED+=("docker"); fi ;;
    *) NEXT+=("Docker 설치: https://docs.docker.com/get-docker/") ;;
  esac
}

# ===========================================================================
# [AI 도구]  context7 / code-review-graph / im-not-ai / superpowers
# ===========================================================================
setup_context7(){
  [ "$DRY" -eq 1 ] && { would "context7: npx ctx7 setup (대화형, 에이전트 감지)"; return; }
  if [ "$INTERACTIVE" -eq 1 ]; then
    info "context7 설정 (ctx7가 설치된 에이전트 감지)"
    run_npx -y ctx7 setup && ok "context7 완료(또는 이미 구성됨)" || NEXT+=("npx ctx7 setup   # context7 MCP")
  else warn "context7 setup은 대화형 — 세션에서 실행"; NEXT+=("npx ctx7 setup   # context7 MCP (세션에서)"); fi
}
setup_code_review_graph(){
  export PATH="$HOME/.local/bin:$PATH"
  if [ "$DRY" -eq 1 ]; then
    have code-review-graph && ok "code-review-graph 이미 있음" || would "code-review-graph 설치 (pipx/pip)"
    would "code-review-graph install(MCP), build(프로젝트에서)"; return
  fi
  if have code-review-graph; then ok "code-review-graph 이미 있음"
  else
    info "code-review-graph 설치 중..."
    local installed=0
    if   have pipx; then pipx install code-review-graph && installed=1
    elif have pip3; then pip3 install --user code-review-graph && installed=1
    elif have pip;  then pip  install --user code-review-graph && installed=1
    else warn "python/pip 없음 — code-review-graph 건너뜀 (mise use -g python 후 재실행 가능)"; NEXT+=("pipx install code-review-graph → code-review-graph install"); return; fi
    [ "$installed" -eq 1 ] && ok "code-review-graph 설치" || { err "code-review-graph 실패"; FAILED+=("code-review-graph"); return; }
  fi
  # MCP 주입은 대화형일 수 있어 비대화형에선 미룸
  if [ "$INTERACTIVE" -eq 1 ]; then
    code-review-graph install >/dev/null 2>&1 && ok "code-review-graph MCP 설정(에이전트 감지)" || warn "code-review-graph install 확인 필요"
  else NEXT+=("code-review-graph install   # MCP 설정(에이전트 감지)"); fi
  NEXT+=("code-review-graph build   # 리뷰 대상 프로젝트 루트에서 (그래프 빌드)")
}
setup_humanize(){
  local dir="$TOOLS_DIR/im-not-ai"
  [ "$DRY" -eq 1 ] && { would "im-not-ai: git clone + ./install.sh ($dir)"; return; }
  if [ -d "$dir/.git" ]; then ok "im-not-ai 이미 있음 — 최신화"; git -C "$dir" pull --ff-only >/dev/null 2>&1 || true
  else info "im-not-ai 클론 중..."; mkdir -p "$TOOLS_DIR"
    git clone --depth 1 https://github.com/epoko77-ai/im-not-ai.git "$dir" || { err "im-not-ai 클론 실패"; FAILED+=("im-not-ai"); return; }; fi
  # 서드파티 install.sh는 대화형일 수 있어 비대화형에선 미룸(hang 방지)
  if [ "$INTERACTIVE" -eq 1 ]; then
    ( cd "$dir" && ./install.sh ) && ok "im-not-ai 설치 완료" || { warn "im-not-ai install.sh 미완료"; NEXT+=("cd $dir && ./install.sh   # im-not-ai"); }
  else NEXT+=("cd $dir && ./install.sh   # im-not-ai (대화형 설치)"); fi
}
SP_FOUND=0
# CLI 하니스: 대화형이면 설치, 비대화형이면 NEXT로 미룸(프롬프트 hang 방지)
sp_cli(){ SP_FOUND=1
  [ "$DRY" -eq 1 ] && { would "superpowers($1): $2"; return; }
  if [ "$INTERACTIVE" -eq 1 ]; then info "superpowers: $1"; bash -c "$2" && ok "superpowers($1)" || warn "$1 설치 실패"
  else NEXT+=("[$1] $2"); fi
}
setup_superpowers(){
  SP_FOUND=0
  have copilot && sp_cli Copilot 'copilot plugin marketplace add obra/superpowers-marketplace && copilot plugin install superpowers@superpowers-marketplace'
  have agy     && sp_cli Antigravity 'agy plugin install https://github.com/obra/superpowers'
  have droid   && sp_cli Droid 'droid plugin marketplace add https://github.com/obra/superpowers && droid plugin install superpowers@superpowers'
  have pi      && sp_cli Pi 'pi install git:github.com/obra/superpowers'
  # 인-에이전트(슬래시 명령) — 셸 불가, 항상 세션에서 실행
  have claude   && { SP_FOUND=1; NEXT+=("[Claude Code 세션] /plugin install superpowers@claude-plugins-official"); }
  have codex    && { SP_FOUND=1; NEXT+=("[Codex CLI 세션] /plugins → superpowers → Install"); }
  have cursor   && { SP_FOUND=1; NEXT+=("[Cursor 세션] /add-plugin superpowers"); }
  have opencode && { SP_FOUND=1; NEXT+=("[OpenCode] https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.opencode/INSTALL.md 따라 설치"); }
  [ "$SP_FOUND" -eq 0 ] && { warn "에이전트 미감지 — superpowers는 하니스별 설치"; NEXT+=("superpowers: https://github.com/obra/superpowers"); }
}

# ===========================================================================
echo "== backend-wiki 도구 설치 =="
[ "$DRY" -eq 1 ] && warn "DRY-RUN: 설치하지 않고 계획만 출력합니다."
detect_os

group "프로젝트 셋업 도구"
ensure_prereqs
setup_mise
setup_node
setup_python
setup_docker

group "AI 도구"
setup_context7
setup_code_review_graph
setup_humanize
setup_superpowers

echo
info "프로젝트 devDeps(eslint/prettier/husky 등)는 각 프로젝트에서 npm/pnpm으로 설치한다."
if [ "${#NEXT[@]}" -gt 0 ]; then
  printf '\n%s== 다음 단계 (에이전트는 자기 세션에서, 사람은 직접 실행) ==%s\n' "$c_cyan" "$c_reset"
  for n in "${NEXT[@]}"; do printf '  - %s\n' "$n"; done
  warn "위 항목은 실행 후 실제로 설치되고 연결됐는지 반드시 확인하고 넘어가세요(확인 없이 넘어가지 말 것)."
fi
echo
info "PATH 반영: 새 셸을 열거나 'exec \$SHELL -l' 후 mise 기반 node/python/pipx가 잡힙니다."
if [ "$DRY" -eq 1 ]; then
  warn "DRY-RUN(미리보기)이었습니다. 아무것도 설치하지 않았습니다."
  warn "실제로 설치하려면 플래그 없이 다시 실행하세요:  ./install.sh"
elif [ "${#FAILED[@]}" -eq 0 ]; then ok "설치 단계 완료. 일부 도구는 새 셸/에디터 재시작이 필요할 수 있습니다."
else err "일부 실패: ${FAILED[*]} — 로그 확인 후 재실행."; exit 1; fi
