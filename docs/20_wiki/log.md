---
id: log-log
title: 작업 이력
aliases: [작업 이력]
type: log
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
    note: "version X.Y.Z 표기·collapsed 마커로 전체 재표기"
tags: [wiki, log]
stack: common
scope: wiki-log
relations:
  - id: operation-log-writing-guide
    label: depends-on
---

# Log

작업 이력을 이 파일 하나에 날짜순으로 남긴다. 작성·압축 규칙은 [[log-writing-guide]]가 단일 기준.

## 날짜별 로그
- **2026-07-07** (정회석) — agent-instruction-guide AGENTS 템플릿에 작업 기록·MR/PR 필수 절 신설, 작업 완료 시 worklog 기재와 MR/PR 요청 시 mr-pr-guide 선행 숙지 의무화. project-wiki-guide의 worklog 온디맨드 기록을 작업 완료 시 기재로 개정, 파일 생성은 여전히 사용자 동의 필수. AGENTS 템플릿 도입부에 conventions·operations 선행 학습 필수 항목 추가. branch-strategy 신설, dionz-frontend 이슈 2 ingest로 인프라 main 단일 트랙과 사내 제품 prod/dev 트랙 이원화, 트랙 판별·보호 설정·FF 병합·rebase·릴리즈·hotfix 동기화 정리, AGENTS 템플릿 git 규칙을 보호 브랜치로 일반화. 에이전트 작동 방식 변경으로 minor. version 0.22.0. package-manager 신설, 사내 표준 pnpm 최신 버전과 packageManager 필드 고정·pnpm-lock.yaml 단일 lockfile 규칙 정리, npm·yarn 명령은 실행 직전 선택지형 확인 의무화, 목차 등록. 에이전트 작동 방식 변경으로 minor. version 0.23.0. node-version 신설, 권장 Node 24 LTS와 .nvmrc 메이저 고정·engines 필드 병행 선언 규칙 정리, 타 버전 사용은 실행 직전 선택지형 확인 의무화, package-manager와 relations 연결, 목차 등록. 패키지 매니저 문서와의 통합은 관심사 분리와 wiki-versioning 명칭 혼동 방지로 기각. 에이전트 작동 방식 변경으로 minor. version 0.24.0. im-not-ai로 package-manager·node-version 점검, 둘 다 AI 티 0건 클린 판정, 두 문서의 em dash 기호 7곳을 쉼표·마침표·콜론으로 대체. version 0.24.1.
- **2026-07-02** (정회석) — agent-instruction-guide 로컬 전용 개인 파일 금지 문구 제거·표 포맷 정리, index Decisions 섹션 제거. expo-sdk-54-pinning 문서는 유지되어 index 미참조 상태. version 0.17.1. wiki-authoring-guide에 경로·링크 표기 표준 신설, 저장소 안 파일은 루트 절대경로 마크다운 링크·디렉토리는 루트 절대경로 백틱·저장소 밖은 백틱 유지, 본진·상위 문서 같은 모호 지칭 금지. 전 문서 sweep으로 백틱 경로 링크화, 상위 index 꼬리표 삭제, AGENTS·README의 testing 잔재와 본진 표현 정리. version 0.17.2. log-writing-guide에 작성자 표기와 버전 괄호 형식 도입, 기존 이력 backfill, 압축 용어 통일과 기준일 명확화, 오늘 제외 일자 항목 7일 쌓이면 주간 압축·한 달치 주간 항목은 월간 압축. version 0.17.3. frontmatter 필수값에 updated_by 추가, 마지막 작업자 1명을 git author 이름으로 표기, 전 문서 backfill. version 0.17.4. 10_raw expo 원문과 expo 문서 삭제, 버저닝 있는 라이브러리·프레임워크 문서는 위키에 안 두고 context7 조회로 전환. concepts 폴더를 principles로 개명해 원칙·기준 문서만 유지, expo-sdk-54-pinning을 index에 재등록. 폴더 역할 재정의로 minor. version 0.18.0. index의 expo-sdk-54-pinning 설명 문구 간결화. version 0.18.1. conventions를 적용 대상 기준으로 이원화, 개발 산출물 규칙 4개는 conventions 유지, 위키·에이전트 운영 규칙 6개는 operations 신설 이동, type operation 신설. 폴더 역할 재정의로 minor. version 0.19.0. operations 라벨을 위키 운영에서 운영 규약·가이드로 정정, 위키 한정 오해 방지, 판별 질문을 개발 산출물 적용 여부로 일반화. version 0.19.1. context7-instruction-guide 초안 신설, 라이브러리 문서 조회 역할 분담과 사용법 정리. version 0.19.2. superpowers-instruction-guide 초안 신설, 프로세스 스킬 우선 호출과 주요 스킬 매핑 정리. version 0.19.3. frontmatter 스키마 전면 교체, id·status·audit_log·aliases·stack·scope·relations 필수화와 code_refs·last_verified 선택 도입, platform을 stack으로 대체, 전 문서 마이그레이션과 NFC 정규화. 문서 수정 시 audit_log 추가가 필수라 작동 방식 변경 minor. version 0.20.0. 분류 기준을 개발 국한 여부로 재정의, 위키 커밋·MR에도 쓰이는 commit-convention과 mr-pr-guide를 operations로 재분류. version 0.20.1. 로그 규칙 프론트·백엔드 통일, 버전 version X.Y.Z 표기와 압축 collapsed 마커 도입, log 전체 재표기. version 0.20.2. relations를 단방향·객체 전용으로 개정, plain 문자열 참조 제거, 참조하는 쪽이 선언하고 역방향 중복 금지, 상호 선언 11쌍 정리. version 0.20.3. context7 사용 강제화, index 시작 전 필수에 npx ctx7 setup 설치 단계 추가, 10_raw 원문 전체와 fsd-folder-structure 문서 삭제, raw 포인터를 context7 URL로 전면 교체, Ingest 흐름을 context7 기준으로 재정의. 작동 방식 구조 변경 minor. version 0.21.0. context7 가이드에서 라이브러리 매핑 표 제거, resolve 조회로 충분해 표 관리 부담 제거. version 0.21.1. index를 필수 작업 순서 우선으로 재배치, 동기화·context7 확인·선행 학습 순서 명시, 상세 절차는 operations 문서 링크로 위임, 목차는 하위 섹션으로 이동. version 0.21.2. AGENTS를 위키 문서와의 중복 제거로 173에서 115줄로 슬림화, Versioning·Commit·Branch MR·문서 작성 규칙을 operations 링크로 위임, stale platform 절 삭제, 문서 기본 구조와 stack 참조 우선순위는 wiki-authoring-guide로 이관. version 0.21.3. superpowers 가이드 확정, 설치 확인·마켓플레이스 설치 절차와 개별 프로젝트 전용 실행 범위 신설, docs/superpowers와 .superpowers gitignore 규칙 추가, 부트스트랩에 설치 확인 단계 연결, 개별 프로젝트 원문 폴더를 raw로 개명해 숫자 프리픽스 제거. version 0.21.4. context7·superpowers 설치 확인을 에이전트 중립 지침으로 변경, claude 전용 확인 명령(claude mcp list·claude plugin list·jq·whoami)과 비대화형 플래그 제거, index 시작 전 필수 단계도 명령 없이 가이드 위임으로 통일, context7 가이드에 위키와의 역할 분리 표 추가. version 0.21.5. context7 가이드 역할 분리 표의 backend-wiki 오타를 frontend-wiki로 정정. version 0.21.6. im-not-ai 윤문 스킬로 20_wiki 문서 13종 AI 티 점검, 10종은 무변경 판정, mr-pr-guide 개조식 종결 4곳·code-review 명사 종결 1곳·agent-instruction-guide 축약어 1곳 자연화, wiki-versioning 작업 절차 번호 7 누락 정정. version 0.21.7. agent-instruction-guide AGENTS 템플릿에 도구 활용 절 신설, 라이브러리 문서 검색은 context7 우선·개발은 superpowers 권장과 미설치 시 설치 가이드 참조 명시, CLAUDE.md 생성 예시를 @AGENTS.md 한 줄 포인터로 교체. version 0.21.8. frontend-wiki 루트 CLAUDE.md도 새 규칙대로 @AGENTS.md 한 줄 포인터로 교체. version 0.21.9. commit-convention·mr-pr-guide에 AI attribution 문구 금지 신설, 하네스가 자동 삽입하는 Generated with·Co-Authored-By 서명을 커밋·MR/PR에서 차단. version 0.21.10.
- **2026-07-01** (정회석) — 본진 concepts 24개 삭제하고 expo·expo-sdk-54-pinning·fsd-folder-structure 3개만 유지, 위키를 판단·기준 문서 중심으로 축소. version 0.15.0. 에이전트·프로젝트 위키 가이드 간소화하고 실행 흐름 다이어그램 추가, README·00_context 정리. version 0.15.1. 전체 위키 파일명 영문 kebab-case 전환, frontmatter 필수값과 type 체계 도입, wiki-authoring-guide 신설, index 미사용 섹션 제거, log 작성·압축 규칙을 log-writing-guide로 분리하고 본진 log·개별 worklog 공통 적용, 날짜별 로그 전면 간결화. version 0.16.0. AGENTS.md 정리, 미사용 원문요약·comparisons·obsidian-read 절 제거하고 파일명·frontmatter는 가이드 위임, 336→166줄 슬림화. git 반영 확인 규칙 추가: 커밋·push·MR·tag·릴리즈는 실행 직전 옵션 선택형으로 확인. version 0.16.1. code-review 개편: 코드 리뷰 요청 시 code-review-graph 필수 사용·미설치 시 설치 절차 신설, 설치·워크플로 선택·MCP 도구를 리뷰 실행 절로 전면 배치, 코드 품질 4기준·접근성·디버깅을 판단 기준 절로 재편하고 트레이드오프·절차 다이어그램 추가. 리뷰 요청 시 작동 방식 변경으로 minor. testing 문서와 raw(testing-sources) 삭제, index·code-review에서 참조 제거. version 0.17.0.
- **2026-06-30** (정회석) — 상위 폴더 영문 리네임, 에이전트·프로젝트 위키 가이드 재작성, wiki-sync 분리, Claude Code 설정 ingest. version 0.12.0~0.13.3. 이어 폴더 구조를 concepts·conventions 2개로 대통합, summaries·principles·decisions·design-system·templates 폐지, 분류 기준을 index 목차로 전환. version 0.14.0.
- **2026-06-29** (정회석) — 위키 연동을 절대경로에서 심볼릭링크로 전환, 소비 프로젝트는 frontend-wiki 링크로 참조하고 git 제외. version 0.8.0. 위키 변경을 브랜치·MR 필수로. version 0.9.0. 도입기 문서 LinkedIn 기준 재작성. version 0.9.1. 루트 폴더 번호 프리픽스, obsidian 공유 설정만 추적. version 0.10.0~0.10.2. frontend-wiki 리브랜딩과 GitLab 이전. version 0.10.3. 본진 경로 점검 규칙 추가. version 0.10.4. 진입 절차 SSOT화, 시작 전 필수 신설. version 0.11.0~0.11.2.
- **2026-06-26** (정회석) — 위키 부트스트랩을 $HOME/frontend-wiki 단일 위치로 교체. version 0.6.1. wiki-versioning 정리, index에 원격 동기화 최우선 체크 추가. version 0.7.0~0.7.1.
- **2026-06-25** (정회석) — 위키 버전 관리 컨벤션 신설, index version 0.5.0 설정, 버전 기준 세분화. version 0.5.1. code-review-graph ingest하고 code-review 신설. version 0.5.2~0.5.3. 앱 기술개념 4종 신설. version 0.6.0.
- **2026-06-24** (정회석) — project-wiki-guide에 raw·최신순 학습 원칙 추가, Expo 공식 docs ingest, Expo 개념 문서 추가.
- **2026.06.19 ~ 2026.06.23** (정회석) · collapsed — 위키 초기화, raw ingest, 주요 개념·컨벤션 문서 생성. 구조 정립: 제목·파일명 직관화, 로그 일자별 분리, context frontmatter·scope 규칙, 기술개념 web/app 폴더 분리, AGENTS 표준 운영 문서화. 결정 번복: 원문요약 mandatory→조건부, 테스트 문서 23→6 병합. project-wiki-guide 신설. version 태깅 이전.
