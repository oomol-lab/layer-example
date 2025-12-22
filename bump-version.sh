#!/bin/bash
set -e  # 任何命令失败立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 使用说明
usage() {
    echo "Usage: $0 <patch|minor|major|version> [--yes]"
    echo "Examples:"
    echo "  $0 patch        # 0.1.0 → 0.1.1 (需要确认)"
    echo "  $0 minor --yes  # 0.1.0 → 0.2.0 (跳过确认)"
    echo "  $0 major        # 0.1.0 → 1.0.0"
    echo "  $0 0.2.5 --yes  # 直接指定版本号"
    exit 1
}

# 检查参数
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    usage
fi

BUMP_TYPE=$1
SKIP_CONFIRM=false

if [ $# -eq 2 ]; then
    if [ "$2" == "--yes" ] || [ "$2" == "-y" ]; then
        SKIP_CONFIRM=true
    else
        echo -e "${RED}错误: 无效的参数 '$2'${NC}"
        usage
    fi
fi
VERSION_FILE="package.oo.yaml"
VERSION_FILE_SECONDARY="pyproject.toml"

# 检查工作区是否干净
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}错误: 工作区有未提交的更改${NC}"
    git status --short
    exit 1
fi

# 读取当前版本 (从 package.oo.yaml)
CURRENT_VERSION=$(grep -E '^version:' "$VERSION_FILE" | awk '{print $2}')

if [ -z "$CURRENT_VERSION" ]; then
    echo -e "${RED}错误: 无法从 $VERSION_FILE 读取当前版本${NC}"
    exit 1
fi

# 解析版本号
IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"

# 计算新版本
case "$BUMP_TYPE" in
    patch)
        NEW_VERSION="$major.$minor.$((patch + 1))"
        ;;
    minor)
        NEW_VERSION="$major.$((minor + 1)).0"
        ;;
    major)
        NEW_VERSION="$((major + 1)).0.0"
        ;;
    *)
        # 直接指定版本号
        if [[ ! "$BUMP_TYPE" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo -e "${RED}错误: 无效的版本格式 '$BUMP_TYPE'${NC}"
            usage
        fi
        NEW_VERSION="$BUMP_TYPE"
        ;;
esac

echo -e "${YELLOW}当前版本: $CURRENT_VERSION${NC}"
echo -e "${YELLOW}新版本: $NEW_VERSION${NC}"

# 检查 tag 是否已存在
if git rev-parse "v$NEW_VERSION" >/dev/null 2>&1; then
    echo -e "${RED}错误: tag v$NEW_VERSION 已存在${NC}"
    exit 1
fi

# 确认操作
if [ "$SKIP_CONFIRM" = false ]; then
    read -p "确认升级版本? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作已取消"
        exit 0
    fi
fi

# 1. 更新版本号
echo -e "${GREEN}[1/4] 更新版本号...${NC}"
# 更新 package.oo.yaml (主版本文件)
sed -i.bak "s/^version: $CURRENT_VERSION$/version: $NEW_VERSION/" "$VERSION_FILE"
rm -f "$VERSION_FILE.bak"
# 更新 pyproject.toml (次要版本文件)
sed -i.bak "s/version = \"$CURRENT_VERSION\"/version = \"$NEW_VERSION\"/" "$VERSION_FILE_SECONDARY"
rm -f "$VERSION_FILE_SECONDARY.bak"

# 2. 提交变更
echo -e "${GREEN}[2/4] 提交变更...${NC}"
git add "$VERSION_FILE" "$VERSION_FILE_SECONDARY"
git commit -m "$(cat <<EOF
Bump version from $CURRENT_VERSION to $NEW_VERSION

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

# 3. 创建 tag
echo -e "${GREEN}[3/4] 创建 tag v$NEW_VERSION...${NC}"
git tag "v$NEW_VERSION"

# 4. 推送到远程
echo -e "${GREEN}[4/4] 推送到远程...${NC}"
git push
git push --tags

echo -e "${GREEN}✅ 版本 v$NEW_VERSION 发布成功!${NC}"
