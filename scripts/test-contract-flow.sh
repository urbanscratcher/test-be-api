#!/bin/bash
# 양방향 API 계약 테스트 통합 스크립트

set -e

echo "🧪 양방향 API 계약 테스트 시작..."
echo ""

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 테스트 결과 추적
TESTS_PASSED=0
TESTS_FAILED=0

# 테스트 함수
test_step() {
    local step_name=$1
    local command=$2
    
    echo -e "${YELLOW}▶ 테스트: $step_name${NC}"
    
    if eval "$command"; then
        echo -e "${GREEN}✅ $step_name 성공${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}❌ $step_name 실패${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# 1. YAML 생성 테스트
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣ OpenAPI YAML 생성 테스트"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_step "YAML 생성" "./scripts/generate-openapi.sh"

if [ -f "api-contracts/openapi.yaml" ]; then
    echo -e "${GREEN}✅ YAML 파일 생성 확인${NC}"
    YAML_SIZE=$(wc -l < api-contracts/openapi.yaml)
    echo "   YAML 파일 크기: $YAML_SIZE 줄"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}❌ YAML 파일이 생성되지 않았습니다${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# 2. YAML 파일 유효성 검사
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣ YAML 파일 유효성 검사"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v yq &> /dev/null; then
    test_step "YAML 구문 검사" "yq eval '.' api-contracts/openapi.yaml > /dev/null"
    
    # 필수 필드 확인
    if yq eval '.openapi' api-contracts/openapi.yaml > /dev/null 2>&1; then
        OPENAPI_VERSION=$(yq eval '.openapi' api-contracts/openapi.yaml)
        echo "   OpenAPI 버전: $OPENAPI_VERSION"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    
    if yq eval '.info.title' api-contracts/openapi.yaml > /dev/null 2>&1; then
        API_TITLE=$(yq eval '.info.title' api-contracts/openapi.yaml)
        echo "   API 제목: $API_TITLE"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    
    # 엔드포인트 개수 확인
    ENDPOINT_COUNT=$(yq eval '.paths | length' api-contracts/openapi.yaml 2>/dev/null || echo "0")
    echo "   엔드포인트 개수: $ENDPOINT_COUNT"
else
    echo -e "${YELLOW}⚠ yq가 설치되지 않아 YAML 검증을 건너뜁니다${NC}"
    echo "   설치: brew install yq"
fi

# 3. Mock 서버 테스트 (선택사항)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣ Mock 서버 테스트 (선택사항)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v npx &> /dev/null; then
    echo "Mock 서버를 시작합니다 (Ctrl+C로 종료)..."
    echo "테스트하려면 다른 터미널에서 다음 명령어를 실행하세요:"
    echo "  curl http://localhost:4010/api/students"
    echo ""
    read -p "Mock 서버를 시작하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npx @stoplight/prism-cli mock api-contracts/openapi.yaml -p 4010 &
        MOCK_PID=$!
        sleep 5
        
        if curl -s http://localhost:4010/api/students > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Mock 서버 정상 동작${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            kill $MOCK_PID 2>/dev/null || true
        else
            echo -e "${RED}❌ Mock 서버 시작 실패${NC}"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            kill $MOCK_PID 2>/dev/null || true
        fi
    fi
else
    echo -e "${YELLOW}⚠ Node.js가 설치되지 않아 Mock 서버 테스트를 건너뜁니다${NC}"
fi

# 4. 클라이언트 코드 생성 테스트 (선택사항)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣ 클라이언트 코드 생성 테스트 (선택사항)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v npx &> /dev/null; then
    read -p "클라이언트 코드를 생성하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p generated-client
        
        if npx @openapitools/openapi-generator-cli generate \
            -i api-contracts/openapi.yaml \
            -g typescript-axios \
            -o ./generated-client/typescript 2>&1 | head -20; then
            echo -e "${GREEN}✅ TypeScript 클라이언트 생성 성공${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}❌ 클라이언트 생성 실패${NC}"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    fi
else
    echo -e "${YELLOW}⚠ Node.js가 설치되지 않아 클라이언트 생성 테스트를 건너뜁니다${NC}"
fi

# 결과 요약
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 테스트 결과 요약"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ 성공: $TESTS_PASSED${NC}"
echo -e "${RED}❌ 실패: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 모든 테스트가 성공했습니다!${NC}"
    exit 0
else
    echo -e "${RED}⚠️ 일부 테스트가 실패했습니다.${NC}"
    exit 1
fi

