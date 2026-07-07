---
id: convention-docker-compose-infra
title: "로컬 인프라 (docker-compose)"
aliases: ["로컬 인프라 (docker-compose)", docker-compose-infra]
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
    note: "로컬 인프라 docker-compose 템플릿, 생성 규칙 신설"
tags: [nestjs, convention, docker, infra, setup]
stack: nestjs
scope: docker-compose-infra
relations:
  - id: convention-eslint-prettier-mise
    label: related
  - id: convention-repository-prisma
    label: related
---

# 로컬 인프라 (docker-compose)

## 한 줄 요약

로컬에서 인프라(PostgreSQL, Redis, Kafka 등)를 docker-compose로 띄워 개발한다. **새 프로젝트에 로컬 인프라를 세팅하거나 서비스를 추가할 때** 읽는다. 목차: [목차](../index.md)

## 목적

`docker-compose.infra.yml`로 앱이 의존하는 인프라를 로컬에서 한 번에 띄운다. 별도 설치 없이 모두 같은 환경에서 작업하게 하려는 것이다.

## 생성 규칙 (에이전트 필수)

이 파일을 만들 때 에이전트는 **먼저 두 가지를 확인**한다.

1. **프로젝트 이름** — 아래 템플릿의 `<project>`(컨테이너, 네트워크, DB 이름 접두)에 넣을 이름을 사용자에게 확인한다. 예시의 `wink`는 특정 프로젝트 값이므로 그대로 쓰지 않는다.
2. **포함할 서비스** — DB, Redis, Kafka가 늘 다 필요한 건 아니다. **어떤 서비스를 넣을지 매번 확인**하고, 필요한 서비스 블록과 그에 딸린 `volumes` 항목만 남긴다.

## 템플릿

`docker-compose.infra.yml` — `<project>`를 실제 이름으로 치환하고, 필요한 서비스만 남긴다.

```yaml
services:
  <project>-infra-db:
    image: postgres:15-alpine
    container_name: <project>-infra-db
    environment:
      - POSTGRES_DB=<project>-preview
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - TZ=UTC
    command: postgres -c timezone=UTC
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - <project>-network

  <project>-infra-redis:
    image: redis:7-alpine
    container_name: <project>-infra-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: ["redis-server", "--appendonly", "yes"]
    networks:
      - <project>-network

  <project>-infra-kafka:
    image: apache/kafka:latest
    container_name: <project>-infra-kafka
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_LISTENERS: INTERNAL://:29092,HOST://:9092,CONTROLLER://:9093
      KAFKA_ADVERTISED_LISTENERS: INTERNAL://<project>-infra-kafka:29092,HOST://localhost:9092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INTERNAL:PLAINTEXT,HOST:PLAINTEXT,CONTROLLER:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: INTERNAL
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@<project>-infra-kafka:9093
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    ports:
      - "9092:9092"
      - "9093:9093"
    volumes:
      - kafka_data:/var/lib/kafka/data
    networks:
      - <project>-network

volumes:
  postgres_data:
  redis_data:
  kafka_data:

networks:
  <project>-network:
    name: <project>-network
    driver: bridge
    external: true # dev 전용 옵션
```

## 실행

```bash
# 네트워크가 external이면 먼저 한 번 생성
docker network create <project>-network

docker compose -f docker-compose.infra.yml up -d
docker compose -f docker-compose.infra.yml down   # 정리
```

## 주의

- **이미지 태그** — `postgres:15`, `redis:7`처럼 major를 고정한다. `apache/kafka:latest`는 재현성을 위해 안정 버전으로 핀하기를 권장한다(설치 시점 확인).
- **자격 증명** — `postgres/postgres`는 **로컬 전용**이다. 실제 환경 값을 여기 넣지 않는다.
- **포함 안 한 서비스** — 서비스 블록을 빼면 그 `volumes` 항목도 함께 지운다.
- **네트워크** — `external: true`는 dev 전용이다. 앱 컨테이너와 같은 네트워크를 공유할 때 쓰며, 없으면 위 `docker network create`로 만든다.

## 관련 문서

- [ESLint, Prettier, mise 설정](eslint-prettier-mise.md)
- [Repository와 Prisma](repository-prisma.md)

## 출처

- 사용자 제공 템플릿, 기준일 2026-07-02
