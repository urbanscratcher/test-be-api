# Student Management API

Spring Boot 기반 학생 관리 시스템 백엔드 API 프로젝트입니다.

## 기술 스택

- Java 17
- Spring Boot 3.2.0
- Spring Data JPA
- SQLite
- Swagger/OpenAPI 3
- Gradle

## 기능

- 학생 CRUD API
  - 학생 목록 조회
  - 학생 상세 조회
  - 학생 생성
  - 학생 수정
  - 학생 삭제

## 실행 방법

1. 프로젝트 빌드
```bash
./gradlew build
```

2. 애플리케이션 실행
```bash
./gradlew bootRun
```

또는

```bash
java -jar build/libs/test-be-api-0.0.1-SNAPSHOT.jar
```

## API 문서

애플리케이션 실행 후 다음 URL에서 Swagger UI에 접근할 수 있습니다:

- Swagger UI: http://localhost:8080/swagger-ui.html
- OpenAPI JSON: http://localhost:8080/api-docs
- OpenAPI YAML: http://localhost:8080/api-docs.yaml

## API 엔드포인트

- `GET /api/students` - 모든 학생 조회
- `GET /api/students/{id}` - 특정 학생 조회
- `POST /api/students` - 학생 생성
- `PUT /api/students/{id}` - 학생 수정
- `DELETE /api/students/{id}` - 학생 삭제

## 데이터베이스

SQLite 데이터베이스가 `students.db` 파일로 생성됩니다.
JPA의 `ddl-auto: update` 설정으로 자동으로 테이블이 생성됩니다.

## OpenAPI 스펙 생성

### 자동 생성

OpenAPI YAML 파일을 자동으로 생성하려면:

```bash
# 방법 1: 스크립트 사용 (권장)
./scripts/generate-openapi.sh

# 방법 2: Gradle Task 사용
./gradlew generateOpenApiYaml

# 방법 3: 서버가 이미 실행 중일 때
./gradlew downloadOpenApiYaml
```

생성된 파일은 `api-contracts/` 디렉토리에 저장됩니다.

### CI/CD

GitHub Actions가 코드 변경 시 자동으로 OpenAPI YAML을 생성하고 커밋합니다.
워크플로우 파일: `.github/workflows/generate-openapi.yml`

## 양방향 API 계약 테스트

이 프로젝트는 양방향 API 계약 테스트를 위한 시범 프로젝트입니다.

### 워크플로우

1. **계약 작성**: DTO 코드 어노테이션으로 API 계약 정의 (완료)
2. **스펙 생성**: 코드 기반 OpenAPI YAML 자동 생성 (완료)
3. **버전 관리**: YAML 파일 Git 관리, PR 리뷰
4. **프론트 협업**: YAML 수정 또는 제안 PR → 협의 및 병합
5. **자동화**: Mock 서버, 클라이언트 코드, 문서 자동 생성
6. **운영**: 정책 수립, 충돌 해결, 교육, 커뮤니케이션

