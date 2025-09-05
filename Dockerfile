FROM 13.0.0-tensorrt-devel-ubuntu24.04


# Install essential packages
RUN apt update && apt install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-psutil \
    python3-requests \
    pciutils \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root/htpclient

# Clone agent repo
RUN git clone https://github.com/hashtopolis/agent-python.git .

# Show files for debug
RUN ls -l

# Install Python requirements
RUN pip3 install -r requirements.txt

# Default shell
CMD ["bash"]
