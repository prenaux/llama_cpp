#!/bin/bash -e
export HAM_NO_VER_CHECK=1
if [[ -z "$HAM_HOME" ]]; then echo "E/HAM_HOME not set !"; exit 1; fi
. "$HAM_HOME/bin/ham-bash-setenv.sh"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"
. hat

log_info "Build..."
case $HAM_OS in
    LINUX)
        # GGML_HIPBLAS requires ROCm to be installed (see build.md)
        # gfx1030 is for the RX 6900 XT (cf https://llvm.org/docs/AMDGPUUsage.html#processors)
        # https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/install-overview.html
        (
            set -x
            make -j GGML_HIPBLAS=1 GGML_HIP_UMA=1 AMDGPU_TARGETS=gfx1030
        )
        ;;
    *)
        (
            set -x
            make -j
        )
        ;;
esac
