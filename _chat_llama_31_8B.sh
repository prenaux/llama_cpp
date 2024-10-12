#!/bin/bash -ex
./llama-cli --interactive --hf-repo kaetemi/Meta-Llama-3.1-8B-Q4_0-GGUF --hf-file meta-llama-3.1-8b-q4_0.gguf -r "User:" -f prompts/chat-with-bob.txt
