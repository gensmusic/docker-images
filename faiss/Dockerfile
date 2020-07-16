FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04


# rm is the workaround for chucksum mismatch
RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-get update && \
    apt-get install -y libopenblas-dev python-numpy python-dev libpcre3 libpcre3-dev wget unzip && \
    apt-get clean

ARG FAISS_VERSION=5d1ed5b6fbb5f93806544a0f915a33946778783f

RUN cd /tmp && \
    wget https://github.com/facebookresearch/faiss/archive/${FAISS_VERSION}.zip && \
    unzip ${FAISS_VERSION}.zip && \
    mv faiss-* /faiss

RUN cd /faiss && ./configure --with-cuda=/usr/local/cuda && \
    make -j 10 && make install && make clean

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"