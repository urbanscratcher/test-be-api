# 프론트엔드 프로젝트에서 사용하기

이 디렉토리의 `openapi.yaml` 파일을 프론트엔드 프로젝트에서 사용할 수 있습니다.

## 파일 위치

- **OpenAPI YAML**: `openapi.yaml`
- **OpenAPI JSON**: `openapi.json` (선택사항)

## 사용 방법

### 1. Mock 서버 생성 (Prism)

```bash
# Prism 설치
npm install -g @stoplight/prism-cli

# Mock 서버 실행
npx @stoplight/prism-cli mock openapi.yaml -p 4010
```

### 2. 클라이언트 코드 생성

#### TypeScript (Axios)
```bash
npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-axios \
  -o ./src/api/generated
```

#### TypeScript (Fetch)
```bash
npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-fetch \
  -o ./src/api/generated
```

#### JavaScript
```bash
npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g javascript \
  -o ./src/api/generated
```

### 3. 타입 정의만 생성 (openapi-typescript)

```bash
# openapi-typescript 설치
npm install -D openapi-typescript

# 타입 생성
npx openapi-typescript openapi.yaml -o src/types/api.d.ts
```

## API 엔드포인트

현재 정의된 엔드포인트:

- `GET /api/students` - 모든 학생 조회
- `GET /api/students/{id}` - 특정 학생 조회
- `POST /api/students` - 학생 생성
- `PUT /api/students/{id}` - 학생 수정
- `DELETE /api/students/{id}` - 학생 삭제

## 업데이트 방법

백엔드 코드가 변경되면:

1. 백엔드 저장소에서 YAML 재생성:
   ```bash
   cd ../test-be-api
   ./gradlew generateOpenApiYaml
   ```

2. 프론트엔드에서 YAML 파일 복사:
   ```bash
   cp ../test-be-api/api-contracts/openapi.yaml ./api-contracts/
   ```

3. 클라이언트 코드 재생성

## 자동화 (선택사항)

프론트엔드 프로젝트의 CI/CD에서 백엔드 YAML을 자동으로 가져오도록 설정할 수 있습니다:

```yaml
# .github/workflows/sync-api-contract.yml
- name: Sync API Contract
  run: |
    git clone https://github.com/your-org/test-be-api.git temp-be-api
    cp temp-be-api/api-contracts/openapi.yaml ./api-contracts/
```

