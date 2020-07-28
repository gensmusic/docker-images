FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# 会编译指定 faiss c_api 并且 install

# rm is the workaround for chucksum mismatch
RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-get update && \
    apt-get install -y libopenblas-dev python-numpy python-dev libpcre3 libpcre3-dev wget unzip && \
    apt-get clean

# a93a4b39571db0ab6ad0b4ef42a6b8734ca05135 这个版本对应的是 1.6.x 切修复了 c_api的 gpu 编译
ARG FAISS_VERSION=a93a4b39571db0ab6ad0b4ef42a6b8734ca05135

RUN cd /tmp && \
    wget https://github.com/facebookresearch/faiss/archive/${FAISS_VERSION}.zip && \
    unzip ${FAISS_VERSION}.zip && \
    mv faiss-* /faiss && \
    cd /faiss && \
    ./configure --with-cuda=/usr/local/cuda && \
    make && make install && \
    cd c_api && make && \
    cp libfaiss_c.so /usr/local/lib/ && \
    cp libfaiss_c.a /usr/local/lib/ && \
    cd gpu && make && make libgpufaiss_c.a && \
    cp libgpufaiss_c.a /usr/local/lib/ && \
    cp libgpufaiss_c.so /usr/local/lib/ && \
    make clean && \
    cd .. && make clean && \
    cd .. && make clean

# headers /usr/local/include/faiss
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH