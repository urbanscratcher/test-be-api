#!/bin/bash
# 테스트 도구 설치 스크립트

set -e

echo "🛠️ 양방향 API 계약 테스트 도구 설치"
echo ""

# Node.js 확인
if ! command -v node &> /dev/null; then
    echo "❌ Node.js가 설치되지 않았습니다."
    echo "   설치: brew install node"
    exit 1
fi

echo "✅ Node.js: $(node --version)"
echo "✅ npm: $(npm --version)"
echo ""

# Prism 설치
echo "📦 Prism (Mock 서버) 설치 중..."
if npm install -g @stoplight/prism-cli; then
    echo "✅ Prism 설치 완료"
    prism --version
else
    echo "❌ Prism 설치 실패"
fi
echo ""

# OpenAPI Generator 설치
echo "📦 OpenAPI Generator 설치 중..."
if npm install -g @openapitools/openapi-generator-cli; then
    echo "✅ OpenAPI Generator 설치 완료"
    openapi-generator-cli version
else
    echo "❌ OpenAPI Generator 설치 실패"
fi
echo ""

# yq 설치 (YAML 검증용, 선택사항)
if command -v brew &> /dev/null; then
    if ! command -v yq &> /dev/null; then
        echo "📦 yq (YAML 검증 도구) 설치 중..."
        read -p "yq를 설치하시겠습니까? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if brew install yq; then
                echo "✅ yq 설치 완료"
            else
                echo "⚠️ yq 설치 실패 (선택사항)"
            fi
        fi
    else
        echo "✅ yq 이미 설치됨: $(yq --version)"
    fi
fi

echo ""
echo "✨ 설치 완료!"
echo ""
echo "사용 가능한 도구:"
echo "  - Prism: npx @stoplight/prism-cli mock api-contracts/openapi.yaml"
echo "  - OpenAPI Generator: npx @openapitools/openapi-generator-cli generate -i api-contracts/openapi.yaml -g <generator> -o <output>"
echo "  - yq: yq eval '.' api-contracts/openapi.yaml"

