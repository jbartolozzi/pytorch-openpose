#!/usr/bin/env bash
# Define color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Name of the Conda environment
ENV_NAME="pytorchopenpose"

# Add the proxy hosts for anaconda to resolve
#export http_proxy="http://proxy.valve.org:3128/"
#export https_proxy="http://proxy.valve.org:3128/"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONDA_DIR="${HOME}/miniconda/${ENV_NAME}"
if [ ! -d "${CONDA_DIR}" ]; then
    echo -e "mini-conda env named ${GREEN}${ENV_NAME}${NC} does not exist. Intalling..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ $(uname -m) == 'arm64' ]]; then
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O Miniconda3-latest-MacOSX.sh
        else
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O Miniconda3-latest-MacOSX.sh
        fi
        /bin/bash ./Miniconda3-latest-MacOSX.sh -b -s -p "${CONDA_DIR}"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3-latest-Linux-x86_64.sh
        /bin/bash ./Miniconda3-latest-Linux-x86_64.sh -b -s -p "${CONDA_DIR}"
    fi

    ${CONDA_DIR}/bin/conda update -y conda
    ${CONDA_DIR}/bin/conda config --add channels conda-forge
    ${CONDA_DIR}/bin/conda config --add channels defaults

    yes | ${CONDA_DIR}/bin/pip install -U pip
    yes | ${CONDA_DIR}/bin/pip install git+https://github.com/huggingface/transformers
    yes | ${CONDA_DIR}/bin/pip install git+https://github.com/huggingface/diffusers
    yes | ${CONDA_DIR}/bin/pip install git+https://github.com/huggingface/accelerate
    yes | ${CONDA_DIR}/bin/pip install git+https://github.com/huggingface/datasets
    yes | ${CONDA_DIR}/bin/pip install matplotlib numpy pandas opencv-python scikit-learn scikit-image tqdm torch torchaudio peft torchvision protobuf sentencepiece wandb prodigyopt websocket-client tensorboard transparent_background timm kornia rembg onnxruntime
    yes | ${CONDA_DIR}/bin/pip install --upgrade tensorflow==2.16.1
    if [[ "$OSTYPE" == "darwin"* ]]; then
        rm -f Miniconda3-latest-MacOSX-x86_64.sh
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        rm -f Miniconda3-latest-Linux-x86_64.sh
    fi
fi


export PYTHONPATH="${SCRIPT_DIR}:${PYTHONPATH}"
export PATH="${CONDA_DIR}/bin:${SCRIPT_DIR}/bin:$PATH"
export TF_CPP_MIN_LOG_LEVEL=3
export GRPC_VERBOSITY="FATAL"
export GLOG_minloglevel=3
export NO_ALBUMENTATIONS_UPDATE=1
echo -e "Using mini-conda environment: ${GREEN}$ENV_NAME${NC}"
echo -e "Python: ${CYAN}$(which python)${NC}"
echo -e "Pip: ${CYAN}$(which pip)${NC}"