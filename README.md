# Dockerized OneTrainer

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Windows 11](https://img.shields.io/badge/Windows%2011-%230078d4.svg?style=for-the-badge&logo=windows&logoColor=white)
![NVIDIA](https://img.shields.io/badge/nVIDIA-%2376B900.svg?style=for-the-badge&logo=nvidia&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![MinIO](https://img.shields.io/badge/Minio-C72E49?style=for-the-badge&logo=minio&logoColor=white)

## Overview

This project provides a containerized environment for [OneTrainer](https://github.com/Nerogar/OneTrainer), optimized for Windows 11 systems running Docker Desktop with an NVIDIA RTX 5090. It encapsulates all dependencies, including CUDA libraries and Python environments, to simplify the setup and execution of AI model training tasks.

## Features

-   **Containerized Environment**: Consistent, isolated environment for OneTrainer execution.
-   **GPU Acceleration**: Configured for NVIDIA RTX 5090 using the latest NVIDIA Container Toolkit.
-   **CUDA 13 Ready**: Built upon `nvidia/cuda:13.0.0-cudnn-runtime-ubuntu24.04` for cutting-edge performance.
-   **Integrated Storage**: Includes a local MinIO object storage service for managing training data and outputs.

## System Requirements

To run this project, ensure your system meets the following criteria:

-   **Operating System**: Windows 11 (WSL2 backend recommended for Docker).
-   **Software**: Docker Desktop for Windows.
-   **Hardware**: NVIDIA RTX 5090 (or other compatible high-end NVIDIA GPU).
-   **Drivers**: Latest NVIDIA Game Ready or Studio Drivers supporting CUDA 13.

## Getting Started

### 1. Configuration

Create a `.env` file in the root directory by copying the provided template:

```bash
cp .env.template .env
```

Open `.env` and configure the necessary variables, particularly your Hugging Face token if required:

-   `HF_TOKEN`: Your Hugging Face access token.
-   `MINIO_...`: MinIO configuration (default values are usually sufficient for local testing).

### 2. Launching the Environment

Build and start the services using Docker Compose:

```bash
docker-compose up --build
```

This command will:
1.  Start the MinIO object storage service.
2.  Initialize the storage buckets.
3.  Build the OneTrainer container (installing all dependencies).
4.  Start the training process as defined in the `CMD` of the Dockerfile.

### 3. Monitoring

Monitor the training progress via the container logs:

```bash
docker-compose logs -f onetrainer
```

## Contributing

Contributions are welcome. Please ensure any modifications adhere to the project's coding standards and license requirements.

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0). See the [LICENSE.md](LICENSE.md) file for details.