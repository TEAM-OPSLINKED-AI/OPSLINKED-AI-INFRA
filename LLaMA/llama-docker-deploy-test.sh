### Localhost Test
curl http://localhost:8080/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{
  "model": "llama3-8b-gguf",
  "messages": [
    {
      "role": "user",
      "content": "Hello! Can you tell me a short joke?"
    }
  ],
  "max_tokens": 50,
  "stream": false
}'

{
   "id":"chatcmpl-bd419d2b-7d14-471a-909c-59f23683e69d",
   "object":"chat.completion",
   "created":1761631318,
   "model":"llama3-8b-gguf",
   "choices":[
      {
         "index":0,
         "message":{
            "content":"Here's one:\n\nWhy couldn't the bicycle stand up by itself?\n\n(Wait for it...)\n\nBecause it was two-tired!\n\nHope that made you smile! Do you want to hear another one?",
            "role":"assistant"
         },
         "logprobs":null,
         "finish_reason":"stop"
      }
   ],
   "usage":{
      "prompt_tokens":20,
      "completion_tokens":40,
      "total_tokens":60
   }
}

### External Test
$ curl http://<Public IP>:8080/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{
  "model": "llama3-8b-gguf",
  "messages": [
    {
      "role": "user",
      "content": "Hello! Can you tell me a short joke?"
    }
  ],
  "max_tokens": 50,
  "stream": false
}'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   620  100   439  100   181     36     14  0:00:12  0:00:12 --:--:--   109
{
   "id":"chatcmpl-772ef29d-90d7-4e83-861a-8b1b0747064e",
   "object":"chat.completion",
   "created":1761631431,
   "model":"llama3-8b-gguf",
   "choices":[
      {
         "index":0,
         "message":{
            "content":"Here's a short one:\n\nWhy don't scientists trust atoms?\n\nBecause they make up everything!\n\nHope that brought a smile to your face!",
            "role":"assistant"
         },
         "logprobs":null,
         "finish_reason":"stop"
      }
   ],
   "usage":{
      "prompt_tokens":20,
      "completion_tokens":28,
      "total_tokens":48
   }
}

### Logs
Try increasing RLIMIT_MEMLOCK ('ulimit -l' as root).
...................
llama_context: constructing llama_context
llama_context: n_seq_max     = 1
llama_context: n_ctx         = 2048
llama_context: n_ctx_per_seq = 2048
llama_context: n_batch       = 512
llama_context: n_ubatch      = 512
llama_context: causal_attn   = 1
llama_context: flash_attn    = 0
llama_context: kv_unified    = false
llama_context: freq_base     = 500000.0
llama_context: freq_scale    = 1
llama_context: n_ctx_per_seq (2048) < n_ctx_train (8192) -- the full capacity of the model will not be utilized
set_abort_callback: call
llama_context:        CPU  output buffer size =     0.49 MiB
create_memory: n_ctx = 2048 (padded)
llama_kv_cache_unified: layer   0: dev = CPU
llama_kv_cache_unified: layer   1: dev = CPU
llama_kv_cache_unified: layer   2: dev = CPU
llama_kv_cache_unified: layer   3: dev = CPU
llama_kv_cache_unified: layer   4: dev = CPU
llama_kv_cache_unified: layer   5: dev = CPU
llama_kv_cache_unified: layer   6: dev = CPU
llama_kv_cache_unified: layer   7: dev = CPU
llama_kv_cache_unified: layer   8: dev = CPU
llama_kv_cache_unified: layer   9: dev = CPU
llama_kv_cache_unified: layer  10: dev = CPU
llama_kv_cache_unified: layer  11: dev = CPU
llama_kv_cache_unified: layer  12: dev = CPU
llama_kv_cache_unified: layer  13: dev = CPU
llama_kv_cache_unified: layer  14: dev = CPU
llama_kv_cache_unified: layer  15: dev = CPU
llama_kv_cache_unified: layer  16: dev = CPU
llama_kv_cache_unified: layer  17: dev = CPU
llama_kv_cache_unified: layer  18: dev = CPU
llama_kv_cache_unified: layer  19: dev = CPU
llama_kv_cache_unified: layer  20: dev = CPU
llama_kv_cache_unified: layer  21: dev = CPU
llama_kv_cache_unified: layer  22: dev = CPU
llama_kv_cache_unified: layer  23: dev = CPU
llama_kv_cache_unified: layer  24: dev = CPU
llama_kv_cache_unified: layer  25: dev = CPU
llama_kv_cache_unified: layer  26: dev = CPU
llama_kv_cache_unified: layer  27: dev = CPU
llama_kv_cache_unified: layer  28: dev = CPU
llama_kv_cache_unified: layer  29: dev = CPU
llama_kv_cache_unified: layer  30: dev = CPU
llama_kv_cache_unified: layer  31: dev = CPU
llama_kv_cache_unified:        CPU KV buffer size =   256.00 MiB
llama_kv_cache_unified: size =  256.00 MiB (  2048 cells,  32 layers,  1/1 seqs), K (f16):  128.00 MiB, V (f16):  128.00 MiB
llama_context: enumerating backends
llama_context: backend_ptrs.size() = 1
llama_context: max_nodes = 2328
llama_context: worst-case: n_tokens = 512, n_seqs = 1, n_outputs = 0
graph_reserve: reserving a graph for ubatch with n_tokens =  512, n_seqs =  1, n_outputs =  512
graph_reserve: reserving a graph for ubatch with n_tokens =    1, n_seqs =  1, n_outputs =    1
graph_reserve: reserving a graph for ubatch with n_tokens =  512, n_seqs =  1, n_outputs =  512
llama_context:        CPU compute buffer size =   258.50 MiB
llama_context: graph nodes  = 1126
llama_context: graph splits = 1
CPU : SSE3 = 1 | SSSE3 = 1 | AVX = 1 | AVX2 = 1 | F16C = 1 | FMA = 1 | BMI2 = 1 | LLAMAFILE = 1 | OPENMP = 1 | REPACK = 1 |
Model metadata: {'tokenizer.chat_template': "{% set loop_messages = messages %}{% for message in loop_messages %}{% set content = '<|start_header_id|>' + message['role'] + '<|end_header_id|>\n\n'+ message['content'] | trim + '<|eot_id|>' %}{% if loop.index0 == 0 %}{% set content = bos_token + content %}{% endif %}{{ content }}{% endfor %}{% if add_generation_prompt %}{{ '<|start_header_id|>assistant<|end_header_id|>\n\n' }}{% endif %}", 'tokenizer.ggml.eos_token_id': '128009', 'general.quantization_version': '2', 'tokenizer.ggml.model': 'gpt2', 'llama.rope.dimension_count': '128', 'llama.vocab_size': '128256', 'general.file_type': '15', 'general.architecture': 'llama', 'llama.rope.freq_base': '500000.000000', 'tokenizer.ggml.bos_token_id': '128000', 'llama.attention.head_count': '32', 'tokenizer.ggml.pre': 'llama-bpe', 'llama.context_length': '8192', 'general.name': 'Models', 'general.type': 'model', 'general.size_label': '8.0B', 'general.license': 'llama3', 'llama.feed_forward_length': '14336', 'llama.attention.layer_norm_rms_epsilon': '0.000010', 'llama.embedding_length': '4096', 'llama.block_count': '32', 'llama.attention.head_count_kv': '8'}
Available chat formats from metadata: chat_template.default
Guessed chat format: llama-3
INFO:     Started server process [7]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
llama_perf_context_print:        load time =    5587.48 ms
llama_perf_context_print: prompt eval time =    5587.31 ms /    20 tokens (  279.37 ms per token,     3.58 tokens per second)
llama_perf_context_print:        eval time =   17242.81 ms /    40 runs   (  431.07 ms per token,     2.32 tokens per second)
llama_perf_context_print:       total time =   22960.62 ms /    60 tokens
llama_perf_context_print:    graphs reused =         38
INFO:     172.17.0.1:36608 - "POST /v1/chat/completions HTTP/1.1" 200 OK
Llama.generate: 19 prefix-match hit, remaining 1 prompt tokens to eval
llama_perf_context_print:        load time =    5587.48 ms
llama_perf_context_print: prompt eval time =       0.00 ms /     1 tokens (    0.00 ms per token,      inf tokens per second)
llama_perf_context_print:        eval time =   11993.48 ms /    29 runs   (  413.57 ms per token,     2.42 tokens per second)
llama_perf_context_print:       total time =   12071.36 ms /    30 tokens
llama_perf_context_print:    graphs reused =         27
INFO:     210.106.232.107:52547 - "POST /v1/chat/completions HTTP/1.1" 200 OK