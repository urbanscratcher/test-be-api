# 양방향 API 계약 테스트 가이드

이 문서는 양방향 API 계약 테스트 프로세스를 테스트하는 방법을 설명합니다.

## 테스트 시나리오

### 1. 로컬 YAML 생성 테스트

```bash
# 방법 1: 스크립트 사용
./scripts/generate-openapi.sh

# 방법 2: Gradle Task 사용
./gradlew generateOpenApiYaml

# 방법 3: 서버가 실행 중일 때
./gradlew downloadOpenApiYaml
```

**확인 사항:**
- `api-contracts/openapi.yaml` 파일이 생성되었는지 확인
- YAML 파일 내용이 올바른지 확인
- 모든 엔드포인트가 포함되어 있는지 확인

### 2. Mock 서버 생성 테스트 (Prism)

#### 설치
```bash
npm install -g @stoplight/prism-cli
```

#### Mock 서버 실행
```bash
# YAML 파일이 생성된 후
npx @stoplight/prism-cli mock api-contracts/openapi.yaml

# 또는 포트 지정
npx @stoplight/prism-cli mock api-contracts/openapi.yaml -p 4010
```

#### 테스트
```bash
# Mock 서버가 http://localhost:4010 에서 실행됨
curl http://localhost:4010/api/students
curl http://localhost:4010/api/students/1
```

**확인 사항:**
- Mock 서버가 정상적으로 시작되는지
- API 엔드포인트가 올바르게 동작하는지
- 응답 형식이 스펙과 일치하는지

### 3. 프론트엔드 클라이언트 코드 생성 테스트

#### TypeScript/JavaScript 클라이언트 생성

```bash
# OpenAPI Generator 설치
npm install -g @openapitools/openapi-generator-cli

# TypeScript Axios 클라이언트 생성
npx @openapitools/openapi-generator-cli generate \
  -i api-contracts/openapi.yaml \
  -g typescript-axios \
  -o ./generated-client/typescript

# JavaScript Fetch 클라이언트 생성
npx @openapitools/openapi-generator-cli generate \
  -i api-contracts/openapi.yaml \
  -g javascript-fetch \
  -o ./generated-client/javascript
```

**확인 사항:**
- 클라이언트 코드가 올바르게 생성되었는지
- 타입 정의가 정확한지
- API 호출 함수가 올바르게 생성되었는지

### 4. GitHub Actions 워크플로우 테스트

#### 수동 실행
1. GitHub 저장소의 Actions 탭으로 이동
2. "Generate OpenAPI YAML" 워크플로우 선택
3. "Run workflow" 버튼 클릭
4. 브랜치 선택 후 실행

#### 코드 변경으로 트리거
```bash
# 소스 코드 변경
# 예: StudentController.java 수정

git add .
git commit -m "test: API 변경 테스트"
git push origin main
```

**확인 사항:**
- 워크플로우가 자동으로 실행되는지
- YAML 파일이 자동으로 생성되는지
- 변경사항이 자동으로 커밋되는지

### 5. API 변경 감지 테스트

#### 시나리오 1: 엔드포인트 추가
1. `StudentController.java`에 새로운 엔드포인트 추가
2. YAML 생성
3. 변경사항 확인

#### 시나리오 2: DTO 필드 추가
1. `Student.java`에 새로운 필드 추가
2. YAML 생성
3. 스펙 변경 확인

#### 시나리오 3: Breaking Change 테스트
1. 필수 필드 추가 (기존 API와 호환되지 않는 변경)
2. YAML 생성
3. 변경사항 확인 및 문서화

### 6. 충돌 해결 테스트

#### 시나리오: 동시 커밋
1. 두 개의 브랜치에서 동시에 API 변경
2. 각각 YAML 생성
3. PR 생성 및 머지
4. 충돌 해결 프로세스 확인

### 7. 문서 자동 배포 테스트

#### Swagger UI 배포
```bash
# 로컬에서 Swagger UI 실행
docker run -p 8081:8080 -e SWAGGER_JSON=/api/openapi.yaml -v $(pwd)/api-contracts:/api swaggerapi/swagger-ui
```

**확인 사항:**
- 문서가 올바르게 표시되는지
- 모든 엔드포인트가 문서화되었는지

## 통합 테스트 스크립트

`scripts/test-contract-flow.sh` 스크립트를 실행하여 전체 플로우를 테스트할 수 있습니다.

```bash
chmod +x scripts/test-contract-flow.sh
./scripts/test-contract-flow.sh
```

## 체크리스트

- [ ] 로컬 YAML 생성 성공
- [ ] Mock 서버 정상 동작
- [ ] 클라이언트 코드 생성 성공
- [ ] GitHub Actions 워크플로우 정상 실행
- [ ] API 변경 감지 정상 작동
- [ ] 충돌 해결 프로세스 확인
- [ ] 문서 자동 배포 확인

## 문제 해결

### YAML 생성 실패
- 서버가 정상적으로 시작되었는지 확인
- 포트 8080이 사용 가능한지 확인
- 로그 확인: `/tmp/bootrun.log`

### Mock 서버 오류
- YAML 파일 형식 확인
- Prism 버전 확인
- 포트 충돌 확인

### GitHub Actions 실패
- 권한 설정 확인
- 토큰 설정 확인
- 워크플로우 로그 확인

