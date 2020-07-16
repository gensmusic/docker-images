FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# rm is the workaround for chucksum mismatch
RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-get update && \
    apt-get install -y libopenblas-dev python-numpy python-dev libpcre3 libpcre3-dev wget unzip && \
    apt-get clean


RUN cd /tmp && \
    wget https://github.com/Enet4/faiss/archive/c_api_head.zip && \
    unzip c_api_head.zip && \
    mv faiss* /faiss

RUN cd /faiss && ./configure --with-cuda=/usr/local/cuda && \
    make -j 10 && make install && make clean

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"