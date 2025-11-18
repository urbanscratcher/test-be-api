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

