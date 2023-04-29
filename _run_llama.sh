#!/bin/bash -e
export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export SCRIPT_NAME=`basename "$0"`
export HAM_NO_VER_CHECK=1
if [[ -z "$HAM_HOME" ]]; then echo "E/HAM_HOME not set !"; exit 1; fi
. "$HAM_HOME/bin/ham-bash-setenv.sh"

cd "$SCRIPT_DIR"
# . ham-toolset > /dev/null

usage() {
    echo "usage: _run.sh model (prompt)"
    echo ""
    echo " The default prompt is 'Building a website can be done in 10 simple steps:'"
    echo ""
    exit 1
}

MODEL="$1"
if [ -n "$MODEL" ]; then
    shift
else
    usage
fi
echo "I/MODEL: $MODEL"

MODEL_PATH="./models/llama/$MODEL/ggml-model-q4_0.bin"
if [ ! -e "$MODEL_PATH" ]; then
    echo "E/Can't find model file '$MODEL_PATH'."
    echo ""
    usage
fi

PROMPT="$1"
if [ -n "$PROMPT" ]; then
    shift
else
    PROMPT="What's a squirrel?"
fi
echo "I/PROMPT: $PROMPT"

if [ ! -e "main" ]; then
    echo "I/'main' not found, trying to build it..."
    # Because the default make on macOS seems to be stuck in a loop if we
    # don't start it this way first.
    make -version
    (set -x ;
     make -j)
fi

# NUM_THREADS=$HAM_NUM_JOBS
NUM_THREADS=${NUM_THREADS:-20}

# Random seed
# SEED=-1
# Use a fixed seed so we have reproducible result, easier for benchmarking
SEED=7892343

(set -x ;
 ./main -s "$SEED" -t "$NUM_THREADS" -m "$MODEL_PATH" -n 512 -p "$PROMPT" "$@")
