FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04


RUN apt-get update && apt-get install -y \
    python3 python3-pip python3.12-venv \
    git libgl1 libglib2.0-0 s3fs \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

RUN pip install --no-cache-dir --break-system-packages torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129 && \
    pip install --no-cache-dir --break-system-packages tensorflow && \
    pip install --no-cache-dir --break-system-packages -U "huggingface_hub[cli]"


WORKDIR /opt/onetrainer
RUN git clone https://github.com/Nerogar/OneTrainer.git
RUN mkdir -p instance training_concepts training_samples training_data

WORKDIR /opt/onetrainer/OneTrainer
RUN ./install.sh

CMD hf auth login --token ${HF_TOKEN} && \
    echo "${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}" > /etc/passwd-s3fs && \
    chmod 600 /etc/passwd-s3fs && \
    mkdir -p ${MINIO_MOUNT} && \
    s3fs ${MINIO_BUCKET} ${MINIO_MOUNT} -o passwd_file=/etc/passwd-s3fs -o url=${MINIO_ENDPOINT} -o use_path_request_style -o allow_other && \
    nvidia-smi && \
    ulimit -a  && \
    ./venv/bin/python scripts/train.py --config-path /mnt/s3data/OneTrainer/training_presets/flux_lora_backup_af_epoch_sierpien.json
