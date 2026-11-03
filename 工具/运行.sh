#!/bin/bash
# 用法：运行.sh <示例名>        例：/bin/bash 工具/运行.sh 冒烟
export MSYS_NO_PATHCONV=1
k="$1"
if [ -z "$k" ]; then
  echo "用法：运行.sh <示例名>"
  exit 2
fi
"/d/src/ryai/构建/${k}.exe"
code=$?
echo "RUN_EXIT=$code"
exit $code
