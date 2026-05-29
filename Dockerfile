# ─── Stage 1: Clone (cached separately so repo changes don't bust other layers) ───
FROM alpine/git:latest AS cloner

WORKDIR /src
RUN git clone --depth=1 --branch main https://github.com/hashtopolis/agent-python.git .


# ─── Stage 2: Runtime image ────────────────────────────────────────────────────────
# cudnn-runtime includes CUDA runtime libs hashcat needs for GPU detection
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system deps + OpenCL so hashcat can see the GPU
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-psutil \
    python3-requests \
    pciutils \
    curl \
    ocl-icd-libopencl1 \
    opencl-headers \
    clinfo \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Register NVIDIA OpenCL ICD so hashcat discovers the GPU via OpenCL
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

WORKDIR /root/htpclient

# Copy cloned agent from Stage 1
COPY --from=cloner /src .

# Install Python requirements
RUN pip3 install --no-cache-dir --quiet --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt

CMD ["bash"]
