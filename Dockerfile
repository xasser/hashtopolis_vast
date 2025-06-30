FROM nvidia/cuda:12.0.1-devel-ubuntu18.04

RUN apt update && apt install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-psutil \
    python3-requests \
    pciutils \
    curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/htpclient

RUN git clone https://github.com/hashtopolis/agent-python.git . && \
    pip3 install -r requirements.txt

CMD ["bash"]
