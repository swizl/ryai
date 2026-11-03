# ryai

用「日月」语言（`.心` 源码编译为原生 Windows 可执行文件）实现的本地大模型推理引擎，CLI 与 HTTP 接口对齐 Ollama 常用子集。

单机 CPU 推理，不做训练、不做 GPU。

目标模型：`Qwen2.5-0.5B-Instruct`（Q8_0/Q4_0）与 `TinyLlama-1.1B-Chat`（Q4_0）。

## 规划中的里程碑

| 里程碑 | 内容 | 验收 |
| --- | --- | --- |
| D1 GGUF 与张量 | GGUF v2/v3 头、元数据 KV、张量表、对齐；mmap 权重；F32/F16/Q8_0/Q4_0 反量化 | `ryai info 模型.gguf` 打印架构/层数/词表/量化；抽检 3 个张量的前 8 个值，与 llama.cpp 一致 |
| D2 分词器 | 从 GGUF 读取 vocab/merges；SentencePiece（Llama）与 byte-level BPE（Qwen2）；特殊 token | 100 条文本 encode→decode 往返一致；与 llama.cpp tokenize 结果逐 token 相同 |
| D3 单步前向 | RMSNorm、RoPE、GQA 注意力、SwiGLU、残差；单 token 无缓存前向 | 固定输入下最后一层 logits 与 llama.cpp 余弦相似度 ≥ 0.999 |
| D4 生成 | KV Cache、prefill + decode、温度/top-k/top-p/重复惩罚、流式输出；`ryai run` | 同一 prompt 生成 128 token 可读中英文；与参考实现前 32 token 重合率达标 |
| D5 性能与服务 | 多线程 matmul（按行切分）、量化矩阵乘内核、内存复用；HTTP `/api/generate`、`/api/chat` | 0.5B Q4 在 8 核 CPU ≥ 10 token/s；curl 流式返回 |
| D6 模型管理与健壮性 | `ryai pull/list/show/rm`（本地模型目录 + 校验和）、上下文长度限制、OOM 友好报错 | pull 模型 → run → serve → 客户端调用端到端可用 |

## 当前状态

**尚未开工。** 依赖日月的原始内存读写、文件与 mmap 内置函数（已就绪）。
