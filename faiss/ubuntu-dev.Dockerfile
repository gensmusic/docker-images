FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# rm is the workaround for chucksum mismatch
RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-get update && \
    apt-get install -y libopenblas-dev python-numpy python-dev libpcre3 libpcre3-dev wget unzip && \
    apt-get clean