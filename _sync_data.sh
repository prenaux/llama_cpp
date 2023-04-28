#!/bin/bash -e
if [ -z "$1" ]; then
  echo "syntax:"
  echo "  ./_sync_data.sh DIR COMMAND"
  echo ""
  echo "example:"
  echo "  # Get all new data from the server"
  echo "  ./_sync_data.sh . pull"
  echo "  # Push all new local data to the server"
  echo "  ./_sync_data.sh . push"
  echo "  # Push all new data in data/img to the server"
  echo "  ./_sync_data.sh img push"
 exit 1
fi
export HAM_SYNC_NUM_CHECKERS=64
export HAM_SYNC_NUM_TRANSFERS=48
time ham-sync-resources llama_cpp $*
