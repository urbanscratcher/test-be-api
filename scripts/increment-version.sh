#!/bin/bash
# 버전 번호 증가 스크립트 (semantic versioning: patch 버전 증가)

JAVA_CONFIG="src/main/java/com/example/testbeapi/config/SwaggerConfig.java"

# Java Config 파일에서 현재 버전 읽기
if [ ! -f "$JAVA_CONFIG" ]; then
    echo "Java Config 파일을 찾을 수 없습니다: $JAVA_CONFIG"
    exit 1
fi

CURRENT_VERSION=$(grep -E '\.version\(".*"\)' "$JAVA_CONFIG" | sed 's/.*\.version("\(.*\)").*/\1/')

if [ -z "$CURRENT_VERSION" ]; then
    echo "버전을 찾을 수 없습니다"
    exit 1
fi

echo "현재 버전: $CURRENT_VERSION"

# 버전 번호 파싱 (예: 1.0.0 -> major=1, minor=0, patch=0)
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

# Patch 버전 증가
PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

echo "새 버전: $NEW_VERSION"

# Java Config 파일 업데이트
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/.version(\"$CURRENT_VERSION\")/.version(\"$NEW_VERSION\")/g" "$JAVA_CONFIG"
else
    # Linux
    sed -i "s/.version(\"$CURRENT_VERSION\")/.version(\"$NEW_VERSION\")/g" "$JAVA_CONFIG"
fi

echo "✅ 버전이 $CURRENT_VERSION에서 $NEW_VERSION으로 업데이트되었습니다"

