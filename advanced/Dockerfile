FROM dockerhub.deepglint.com/atlas/developmentkit_base:v0.3-x86_64

COPY l_BaseKit_p_2022.1.2.146_offline.sh .
RUN sh ./l_BaseKit_p_2022.1.2.146_offline.sh \
    --remove-extracted-files yes \
    -a --silent --eula accept --components intel.oneapi.lin.mkl.devel:intel.oneapi.lin.tbb.devel && \
    rm -rf intel l_BaseKit_p_2022.1.2.146_offline.sh

ARG DEBIAN_FRONTEND=noninteractive
COPY cuda-repo-ubuntu1804-11-6-local_11.6.2-510.47.03-1_amd64.deb cuda-ubuntu1804.pin ./
RUN apt-get install -y linux-headers-$(uname -r) && \
    dpkg -i cuda-repo-ubuntu1804-11-6-local_11.6.2-510.47.03-1_amd64.deb && \
    apt-key add /var/cuda-repo-ubuntu1804-11-6-local/7fa2af80.pub && \
    mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    apt-get update && \
    apt-get install -y cuda && \
    apt-get install -y nvidia-gds && \
    echo '' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/usr/local/cuda-11.6/bin' >> /root/.zshrc && \
    rm cuda-repo-ubuntu1804-11-6-local_11.6.2-510.47.03-1_amd64.deb
# The approriate version of the nvidia display driver should be installed on the host to make sure
# cuda applications can work in the container.

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

COPY Anaconda3-2021.11-Linux-x86_64.sh .
RUN bash ./Anaconda3-2021.11-Linux-x86_64.sh -b && \
    eval "$(/root/anaconda3/bin/conda shell.zsh hook)" && \
    conda init zsh && \
    conda install -y pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch && \
    rm Anaconda3-2021.11-Linux-x86_64.sh

SHELL ["/root/anaconda3/bin/conda", "run", "--no-capture-output", "-n", "base", "/bin/zsh", "-c"]
RUN apt-get install -y python3-pip && \
    pip3 install onnxruntime-gpu

# git clone https://github.com/gflags/gflags.git
# COPY gflags ./gflags
RUN git clone https://github.com/gflags/gflags.git && mkdir gflags/build && \
    cd gflags/build && \
    cmake -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DGFLAGS_NAMESPACE='google' -DINSTALL_HEADERS=ON .. && \
    make && \
    make install && \
    cd /root && \
    rm -rf gflags

# git clone https://github.com/google/glog.git
# COPY glog ./glog
RUN git clone https://github.com/google/glog.git && cd glog && \
    cmake -S . -B build -G "Unix Makefiles" && \
    cmake --build build && \
    cmake --build build --target install && \
    cd .. && \
    rm -rf glog

RUN apt-get install -y libopenblas-base && \
    apt-get install -y libopenblas-dev

