FROM nvidia/cuda:12.0.1-devel-ubuntu18.04

# Install necessary packages
RUN apt update && apt install -y --no-install-recommends \
    zip \
    git \
    python3 \
    python3-pip \
    python3-psutil \
    python3-requests \
    pciutils \
    curl \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root/htpclient

# Clone Hashtopolis agent and prepare it
RUN git clone https://github.com/hashtopolis/agent-python.git && \
    cd agent-python && \
    ./build.sh && \
    mv hashtopolis.zip ../ && \
    cd .. && \
    rm -rf agent-python && \
    unzip hashtopolis.zip && \
    pip3 install -r requirements.txt

# Default command does nothing - you will run agent manually
CMD ["bash"]
