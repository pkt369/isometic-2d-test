---
id: convention-env-files
title: "환경변수 파일 (.env)"
aliases: ["환경변수 파일 (.env)", env-files]
type: convention
status: active
created_at: 2026-07-02
created_by: 이상협
updated_at: 2026-07-02
updated_by: 이상협
last_verified_at: 2026-07-02
last_verified_by: 이상협
audit_log:
  - action: created
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "env 파일 컨벤션 신설 (루트 공통 + 앱별, APP_ENV)"
  - action: updated
    at: 2026-07-02
    by: 이상협
    commit: ""
    note: "실제 구조 반영 — envs/ 폴더, path.resolve(process.cwd()), 순서 공통→앱 전용"
tags: [nestjs, convention, env, config, setup]
stack: nestjs
scope: env-files
relations:
  - id: convention-docker-compose-infra
    label: related
  - id: convention-repository-prisma
    label: related
---

# 환경변수 파일 (.env)

## 한 줄 요약

루트 공통 env와 앱별 env 두 파일을 함께 주입하고, `APP_ENV`로 환경(local/dev/prod)을 고른다. **환경변수를 추가하거나 앱 설정을 세팅할 때** 읽는다. 목차: [목차](../index.md)

## 목적

여러 앱이 공유하는 공통 변수와 앱 전용 변수를 분리하고, 환경(local/dev/prod)별로 값 파일을 전환한다.

## 구조

- 공통: `envs/.env.<env>` — 프로젝트 루트 `envs/`에 두는, 여러 앱이 공유하는 변수.
- 앱 전용: `apps/<app>/envs/.env.<env>` — 그 앱만 쓰는 변수.
- `<env>`는 `APP_ENV` 값이며 `local`, `dev`, `prod` 중 하나다.

## 환경 선택 (APP_ENV)

- `process.env.APP_ENV`로 어떤 env 파일을 읽을지 정한다. 실행 환경에서 항상 설정한다(설정하지 않을 때를 대비해 기본값을 두려면 `local`).
- 파일명: `.env.local`, `.env.dev`, `.env.prod`.

## 주입 (NestJS ConfigModule)

앱은 **공통과 앱 전용 두 파일을 함께** 로드한다. 경로는 `path.resolve(process.cwd(), ...)`로 실행 위치(모노레포 루트) 기준 절대경로로 만든다.

```ts
// app.module.ts (요지)
import path from 'node:path';

const env = process.env.APP_ENV; // local | dev | prod
ConfigModule.forRoot({
  isGlobal: true,
  envFilePath: [
    path.resolve(process.cwd(), `./envs/.env.${env}`),            // 공통
    path.resolve(process.cwd(), `./apps/<app>/envs/.env.${env}`), // 앱 전용
  ],
});
```

- `envFilePath` 배열은 **앞 파일이 우선**이다. 위 순서(공통 먼저)에서는 같은 키를 공통이 앱 전용보다 우선한다. 앱이 공통을 재정의해야 하면 순서를 바꾼다. 정확한 우선순위 동작은 [context7 사용 가이드](../operations/context7-instruction-guide.md)로 ConfigModule 문서를 확인한다.

## 규칙

- 실제 값 파일(`envs/**/.env.*`)은 secret이 들어가므로 **커밋하지 않는다**(`.gitignore`).
- 키 목록은 `envs/.env.<env>.example`로 공유해 셋업 때 채우게 한다.
- 필수 env는 ConfigModule `validationSchema`(zod, joi 등)로 시작 시 검증한다.
- 로컬 인프라 접속값(DB, Redis 등)은 [로컬 인프라 (docker-compose)](docker-compose-infra.md)의 로컬 설정과 맞춘다.

## 관련 문서

- [로컬 인프라 (docker-compose)](docker-compose-infra.md)
- [Repository와 Prisma](repository-prisma.md)

## 출처

- 사용자 제공 규칙, 기준일 2026-07-02
