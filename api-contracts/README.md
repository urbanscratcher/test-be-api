# API Contracts

이 디렉토리는 OpenAPI 스펙 파일을 저장합니다.

## 파일 설명

- `openapi.yaml` - OpenAPI 3.0 스펙 파일 (YAML 형식)
- `openapi.json` - OpenAPI 3.0 스펙 파일 (JSON 형식)

## 생성 방법

### 방법 1: 스크립트 사용 (권장)
```bash
./scripts/generate-openapi.sh
```

### 방법 2: Gradle Task 사용
```bash
./gradlew generateOpenApiYaml
```

### 방법 3: 서버가 이미 실행 중일 때
```bash
./gradlew downloadOpenApiYaml
```

또는 직접 curl 사용:
```bash
curl http://localhost:8080/api-docs.yaml -o api-contracts/openapi.yaml
```

## CI/CD

GitHub Actions가 자동으로 이 파일들을 생성하고 커밋합니다.
코드 변경 시 `.github/workflows/generate-openapi.yml` 워크플로우가 실행됩니다.

## 버전 관리

이 파일들은 Git에 커밋되어 프론트엔드 팀과 공유됩니다.
프론트엔드 팀은 이 파일을 사용하여:
- Mock 서버 생성 (Prism 등)
- 클라이언트 코드 자동 생성 (OpenAPI Generator 등)
- API 문서 확인

