#!/bin/bash
# OpenAPI YAML 자동 생성 스크립트

set -e

echo "🚀 OpenAPI YAML 생성 시작..."

# api-contracts 디렉토리 생성
mkdir -p api-contracts

# 서버 시작 (백그라운드)
echo "📦 서버 빌드 중..."
./gradlew build -x test > /dev/null 2>&1

echo "🌐 서버 시작 중..."
./gradlew bootRun > /tmp/bootrun.log 2>&1 &
SERVER_PID=$!

# 서버 시작 대기
echo "⏳ 서버 시작 대기 중... (최대 45초)"
MAX_WAIT=45
WAIT_COUNT=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if curl -s http://localhost:8080/api-docs.yaml > /dev/null 2>&1; then
        echo ""
        echo "✅ 서버가 준비되었습니다!"
        break
    fi
    sleep 1
    WAIT_COUNT=$((WAIT_COUNT + 1))
    if [ $((WAIT_COUNT % 5)) -eq 0 ]; then
        echo -n "."
    fi
done

if [ $WAIT_COUNT -eq $MAX_WAIT ]; then
    echo ""
    echo "❌ 서버 시작 실패 (로그 확인: /tmp/bootrun.log)"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi

# YAML 다운로드
echo "📥 OpenAPI YAML 다운로드 중..."
if curl -s http://localhost:8080/api-docs.yaml -o api-contracts/openapi.yaml; then
    echo "✅ OpenAPI YAML이 생성되었습니다: api-contracts/openapi.yaml"
else
    echo "❌ YAML 다운로드 실패"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi

# JSON도 함께 다운로드 (선택사항)
if curl -s http://localhost:8080/api-docs -o api-contracts/openapi.json; then
    echo "✅ OpenAPI JSON이 생성되었습니다: api-contracts/openapi.json"
fi

# 서버 종료
echo "🛑 서버 종료 중..."
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

echo ""
echo "✨ 완료! 생성된 파일:"
echo "   - api-contracts/openapi.yaml"
echo "   - api-contracts/openapi.json"

