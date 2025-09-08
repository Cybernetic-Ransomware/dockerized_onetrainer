FROM nvidia/cuda:13.0.0-cudnn-runtime-ubuntu24.04
LABEL authors="aleksander.marszalki"
LABEL name="trainer-s3"

RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential apt-utils \
    wget curl vim git ca-certificates kmod \
    nvidia-driver-525 \    
    python3 python3-pip python3.12-venv \
    git libgl1 libglib2.0-0 s3fs \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

RUN pip install --no-cache-dir --break-system-packages torch torchvision --index-url https://download.pytorch.org/whl/cu129 && \
    pip install --no-cache-dir --break-system-packages tensorflow && \
    pip install --no-cache-dir --break-system-packages -U "huggingface_hub[cli]"


# last proper buiilded commit: 5031626351d98cd1fa0d10add1d516e4e594bac8
WORKDIR /opt/onetrainer
RUN git clone https://github.com/Nerogar/OneTrainer.git --single-branch --branch master --depth 1
RUN mkdir -p instance training_concepts training_samples training_data

WORKDIR /opt/onetrainer/OneTrainer
RUN ./install.sh


CMD hf auth login --token ${HF_TOKEN} && \
    hf download black-forest-labs/FLUX.1-dev --local-dir ~/.cache/huggingface/flux && \
    mkdir -p ${S3_MOUNT} && \
    s3fs ${S3_BUCKET} ${S3_MOUNT} -o allow_other && \
    mkdir -p /opt/onetrainer/local_training_data && \
    cp -r ${S3_MOUNT}/dane_treningowe_JDTAG/* /opt/onetrainer/local_training_data/ && \
    nvidia-smi && \
    ulimit -a && \
    ./venv/bin/python scripts/train.py --config-path ${S3_MOUNT}/OneTrainer/training_presets/flux_lora_backup_af_epoch_sierpien_JDTAG_S3.json
