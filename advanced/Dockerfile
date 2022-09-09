FROM dockerhub.deepglint.com/atlas/developmentkit_base:v1.0-x86_64

# RUN curl -fsSLO https://registrationcenter-download.intel.com/akdlm/irc_nas/18487/l_BaseKit_p_2022.1.2.146_offline.sh && \
COPY l_BaseKit_p_2022.1.2.146_offline.sh .
RUN  sh ./l_BaseKit_p_2022.1.2.146_offline.sh \
    --remove-extracted-files yes \
    -a --silent --eula accept --components intel.oneapi.lin.mkl.devel:intel.oneapi.lin.tbb.devel && \
    rm -r intel l_BaseKit_p_2022.1.2.146_offline.sh

ARG DEBIAN_FRONTEND=noninteractive
# RUN curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
#     curl -fsSLO https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb && \
# apt-get install -y linux-headers-$(uname -r) # kernel development package should be installed on the host machine.
COPY cuda-ubuntu2004.pin .
COPY cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb .
RUN apt-key del 7fa2af80 && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    dpkg -i cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb && \
    cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && \
    apt-get install -y cuda && \
    apt-get install -y nvidia-gds && \
    echo '' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/usr/local/cuda-11.7/bin' >> /root/.zshrc && \
    rm cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
# The approriate version of the nvidia display driver should be installed on the host to make sure
# cuda applications can work in the container.

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# RUN curl -fsSLO https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh && \
COPY Anaconda3-2021.11-Linux-x86_64.sh .
RUN bash ./Anaconda3-2021.11-Linux-x86_64.sh -b && \
    eval "$(/root/anaconda3/bin/conda shell.zsh hook)" && \
    conda init zsh && \
    conda install -y pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch && \
    rm Anaconda3-2021.11-Linux-x86_64.sh

SHELL ["/root/anaconda3/bin/conda", "run", "--no-capture-output", "-n", "base", "/bin/zsh", "-c"]
RUN apt-get install -y python3-pip && \
    pip3 install onnxruntime-gpu

RUN git clone https://github.com/gflags/gflags.git && mkdir gflags/build && \
    cd gflags/build && \
    cmake -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DGFLAGS_NAMESPACE='google' -DINSTALL_HEADERS=ON .. && \
    make && \
    make install && \
    cd /root && \
    rm -rf gflags

RUN git clone https://github.com/google/glog.git && cd glog && \
    cmake -S . -B build -G "Unix Makefiles" && \
    cmake --build build && \
    cmake --build build --target install && \
    cd .. && \
    rm -rf glog

RUN apt-get install -y libopenblas-base && \
    apt-get install -y libopenblas-dev

# Download cuDNN manually.
COPY cudnn-local-repo-ubuntu1804-8.4.0.27_1.0-1_amd64.deb .
RUN dpkg -i cudnn-local-repo-ubuntu1804-8.4.0.27_1.0-1_amd64.deb && \
    apt-key add /var/cudnn-local-repo-*/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y libcudnn8=8.4.0.27-1+cuda11.6 && \
    apt-get install -y libcudnn8-dev=8.4.0.27-1+cuda11.6 && \
    apt-get install -y libcudnn8-samples=8.4.0.27-1+cuda11.6 && \
    rm -v cudnn-local-repo-ubuntu1804-8.4.0.27_1.0-1_amd64.deb

RUN curl -fsSLO https://github.com/protocolbuffers/protobuf/releases/download/v3.20.0/protobuf-all-3.20.0.tar.gz && \
    apt-get install -y unzip && \
    tar xvzf protobuf-all-3.20.0.tar.gz && \
    rm protobuf-all-3.20.0.tar.gz && \
    cd protobuf-3.20.0 && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd $HOME && \
    rm -rf protobuf-3.20.0 && \
    echo '' >> ~/.zshrc && \
    echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.zshrc

RUN pip3 install opencv-python

RUN apt-get install -y liblmdb-dev
RUN apt-get install -y libsnappy-dev
RUN apt-get install -y libleveldb-dev
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libopencv-dev
RUN apt-get install -y libhdf5-serial-dev
# Replace your own user name and password.
RUN git clone https://username:password@gitlab.deepglint.com/leimao/caffe.git
RUN cd caffe && \
    curl -fsSL -o Makefile.config https://raw.githubusercontent.com/BVLC/caffe/master/Makefile.config.example && \
    sed -i 's/# OPENCV_VERSION/OPENCV_VERSION/' Makefile.config && \
    sed -i 's/ -gencode arch=compute_20,code=sm_20//' Makefile.config && \
    sed -i '/arch=compute_[2-5]/d' Makefile.config && \
    sed -i 's/BLAS := atlas/BLAS := mkl/' Makefile.config && \
    sed -i '/^PYTHON_INCLUDE/d' Makefile.config && \
    sed -i 's%.*/usr/lib/python2.7/dist-packages/numpy/core/include.*%%' Makefile.config && \
    sed -i '/# ANACONDA_HOME/s%^.*$%ANACONDA_HOME := $(HOME)/anaconda3%' Makefile.config && \
    sed -i 's/# PYTHON_LIBRARIES.*/PYTHON_LIBRARIES := boost_python3 python3.9/' Makefile.config && \
    sed -i 's%# PYTHON_INCLUDE := /.*%PYTHON_INCLUDE := $(ANACONDA_HOME)/include/python3.9 \\%' Makefile.config && \
    sed -i 's%#.*/usr/lib/python3.5/dist-packages/numpy/core/include%\t\t\t$(ANACONDA_HOME)/lib/python3.9/site-packages/numpy/core/include%' Makefile.config && \
    sed -i '/^PYTHON_LIB :=/d' Makefile.config && \
    sed -i 's/# PYTHON_LIB :=/PYTHON_LIB :=/' Makefile.config && \
    sed -i 's/# WITH_PYTHON_LAYER/WITH_PYTHON_LAYER/' Makefile.config && \
    sed -i 's#^\(INCLUDE_DIRS :=.*\)#\1 /usr/include/hdf5/serial#' Makefile.config && \
    grep 'gflags::' $(find . -name '*') 2>/dev/null | awk -F ':' '{print $1}' | xargs -I '{}' sed -i 's/gflags::/google::/' '{}' && \
    sed -i 's/SetTotalBytesLimit(\(.*\), .*);/SetTotalBytesLimit(\1);/' src/caffe/util/io.cpp && \
    sed -i 's#/opt/intel/mkl#/opt/intel/oneapi/mkl/latest#' Makefile
# RUN cd caffe && \
#     make all -j $(nproc) && \
#     make pycaffe -j $(nproc) && \
#     sed -i 's/as_grey/as_gray/' python/caffe/io.py && \
#     echo '' >> ~/.zshrc && \
#     echo "export PYTHONPATH=$HOME/caffe/python" >> ~/.zshrc
RUN echo '' >> ~/.zshrc; echo "export LD_LIBRARY_PATH=$HOME/anaconda3/lib" >> ~/.zshrc

RUN echo '' >> ~/.zshrc && echo 'export GONOPROXY="https://gitlab.deepglint.com"' >> ~/.zshrc

RUN pip3 install Flask
RUN apt-get update && apt-get install -y libpq-dev
RUN pip3 install psycopg2

RUN curl -LOs https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz && \
    tar xvzf migrate.linux-amd64.tar.gz && \
    mv migrate $HOME/gocode/bin/ && \
    rm migrate.linux-amd64.tar.gz LICENSE README.md

