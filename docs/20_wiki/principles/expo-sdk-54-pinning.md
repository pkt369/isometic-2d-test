---
id: decision-expo-sdk-54-pinning
title: Expo SDK 54 버전 고정
aliases: [Expo SDK 54 버전 고정]
type: decision
status: active
created_at: 2026-06-19
created_by: 정회석
updated_at: 2026-07-02
updated_by: 정회석
last_verified_at: 2026-07-02
last_verified_by: 정회석
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
    note: "relations 단방향 정리"
tags: [frontend, react-native, expo, versioning]
stack: app
scope: expo-sdk-pinning
source: "https://expo.dev/changelog/expo-go-and-app-store-may-2026, https://expo.dev/changelog/sdk-54"
relations: []
---

# Expo SDK 54 버전 고정

> Expo 프로젝트에서 SDK를 **54.0.35**에 핀할 수 있는 이유. (웹 조사: 2026-06)

## TL;DR
두 가지 이유가 겹친다 + 패치 핀:
1. **Expo Go (App Store) 호환** — iOS App Store에 공개된 Expo Go가 지원하는 **가장 최신 SDK가 54**. SDK 55는 Apple 심사 대기(일정 미정), 56은 TestFlight 베타. → 실제 아이폰에서 **스토어 Expo Go로 바로 테스트**하려면 54여야 함.
2. **Legacy Architecture 마지막 SDK** — SDK 54(RN 0.81)는 레거시 아키텍처를 지원하는 **마지막** SDK. RN 0.82에서 레거시 제거. New-Arch 미대응 의존성·안정성 확보용.
3. **`.0.35` 패치 핀** — 마이너가 아닌 정확한 패치 고정 → 팀·CI 재현성.

## 1. Expo Go & App Store (질문의 핵심)
- **Expo Go** = 스토어에 올라온 샌드박스 앱. 네이티브 빌드 없이 JS 코드를 즉시 실행 (빠른 시작·교육용).
- **iOS 제약**: 물리 iOS 기기에는 App Store에 **공개된 최신 Expo Go 한 버전**만 설치 가능.
- **2026-05 기준 상태**:
  - App Store·Play Store에 공개된 Expo Go = **SDK 54**.
  - **SDK 55 Expo Go = Apple App Store 심사 대기** (확정 일정 없음).
  - SDK 56 = TestFlight 외부 베타 경로.
- **결론**: SDK 55/56 프로젝트는 실 아이폰의 스토어 Expo Go로 **못 돌린다**. 돌리려면 `eas go` 커스텀 빌드(TestFlight, Apple Developer 멤버십 필요) 또는 development build가 필요.
- → **SDK 54로 핀하면** 추가 빌드·멤버십 없이 **스토어 Expo Go로 실기기 즉시 테스트** 가능.

> ⚠️ 단, Expo 공식 입장: Expo Go는 "교육·빠른 시작 도구"이며 **프로덕션 앱은 development build 권장**. 54 핀은 개발 편의(스토어 Expo Go) 목적이지, 배포 전략은 별개.

## 2. Legacy Architecture 마지막 SDK
- SDK 54 = **React Native 0.81 + React 19.1**.
- RN은 New Architecture(Fabric·TurboModules)로 전환 중:
  - Legacy Architecture: RN **0.80에서 freeze** → **0.82에서 완전 제거**.
  - **SDK 54 = 레거시 아키텍처를 지원하는 마지막 SDK.** SDK 55(RN 0.83 예상)는 New-Arch 전용.
- New-Arch 미대응 네이티브 모듈에 의존하거나, 강제 마이그레이션 전 안정성이 필요하면 54가 안전판.
- 참고: `use_frameworks!`를 쓰면 SDK 54의 precompiled iOS 빌드 이점은 못 받음.

## 3. `.0.35` 패치까지 고정하는 이유
- `expo@54.0.35`처럼 **정확한 패치**를 고정 → 팀원·CI가 동일 빌드 재현.
- create-expo-app도 템플릿 버전을 핀해야 처음부터 SDK 54로 생성됨. `@latest`는 최신 SDK를 생성할 수 있으므로 SDK 선택 시 공식 Expo 문서와 실제 생성 결과를 함께 확인한다.

## 트레이드오프
| 👍 SDK 54 유지 | 👎 비용 |
|---|---|
| 스토어 Expo Go로 실기기 테스트 | SDK 55+ 신기능 미사용 |
| 레거시 아키텍처 호환 | 언젠가 New-Arch 마이그레이션 필요 |
| 안정·재현 가능 빌드 | 보안·성능 최신화 지연 |

> 향후 `create-expo-app`은 "App Store 호환 SDK vs 최신 SDK" 선택지를 제공할 예정.

## 관련 문서
`React Native` · `NativeWind`

## 출처 (조사 2026-06)
- Expo Go and the App Store (May 2026): https://expo.dev/changelog/expo-go-and-app-store-may-2026
- Expo SDK 54 changelog: https://expo.dev/changelog/sdk-54
- React Native 0.81 release: https://reactnative.dev/blog/2025/08/12/react-native-0.81
