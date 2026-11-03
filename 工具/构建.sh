#!/bin/bash
# 用法：构建.sh <示例名>        例：/bin/bash 工具/构建.sh 冒烟
# 依赖：日月编译器（默认 D:\src\riyue\riyue\日月.exe）与 LLVM 工具链
export MSYS_NO_PATHCONV=1
export PATH=/usr/bin:/bin:/mingw64/bin:$PATH
k="$1"
if [ -z "$k" ]; then
  echo "用法：构建.sh <示例名>"
  exit 2
fi
cd /d/src/riyue/riyue || exit 9
out="/d/src/ryai/构建/${k}.exe"
mkdir -p /d/src/ryai/构建
rm -f "$out" "$out.ll" "$out.bc"
./日月.exe "D:/src/ryai/示例/${k}.心" "D:/src/ryai/构建/${k}.exe" > "/d/src/ryai/构建/${k}.编译.log" 2>&1
if [ -f "$out" ]; then
  echo "构建成功: $out"
  exit 0
else
  echo "构建失败: 见 /d/src/ryai/构建/${k}.编译.log"
  tail -n 20 "/d/src/ryai/构建/${k}.编译.log"
  exit 1
fi
