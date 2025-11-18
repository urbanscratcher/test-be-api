# 기여 가이드

## API 계약 변경 시

### 백엔드 개발자

1. 코드에서 API 계약 변경 (Controller, DTO 등)
2. OpenAPI YAML 자동 생성:
   ```bash
   ./gradlew generateOpenApiYaml
   ```
3. 생성된 YAML 파일 확인: `api-contracts/openapi.yaml`
4. 변경사항 커밋 및 PR 생성
5. 프론트엔드 팀 리뷰 요청

### 프론트엔드 개발자

1. `api-contracts/openapi.yaml` 파일 확인
2. 필요시 YAML 파일 수정 또는 PR 제안
3. 백엔드 팀과 협의 후 병합
4. Mock 서버 또는 클라이언트 코드 자동 생성

## YAML 파일 수정 시

- YAML 파일을 직접 수정하는 경우, 반드시 백엔드 코드와 일치하는지 확인
- PR 리뷰를 통해 백엔드 팀과 협의
- 충돌 발생 시 백엔드 코드를 기준으로 재생성

## 자동화 도구

### Mock 서버 생성 (Prism)
```bash
npx @stoplight/prism-cli mock api-contracts/openapi.yaml
```

### 클라이언트 코드 생성 (OpenAPI Generator)
```bash
npx @openapitools/openapi-generator-cli generate \
  -i api-contracts/openapi.yaml \
  -g typescript-axios \
  -o ./generated-client
```

