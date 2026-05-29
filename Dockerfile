# ─── Stage 1: Clone agent ──────────────────────────────────────────────────────
FROM alpine/git:latest AS cloner
WORKDIR /src
RUN git clone --depth=1 --branch master https://github.com/hashtopolis/agent-python.git .

# ─── Stage 2: Proven hashcat+CUDA base (tested on Vast.ai) ────────────────────
FROM dizcza/docker-hashcat:cuda

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    NVIDIA_DISABLE_REQUIRE=1

# Install Python deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-psutil \
    python3-requests \
    pciutils \
    curl \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/htpclient

COPY --from=cloner /src .

RUN pip3 install --no-cache-dir --quiet --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt

CMD ["bash"]
