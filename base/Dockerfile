FROM ubuntu:18.04

WORKDIR /root

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai
RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get install -y apt-utils && \
    apt-get install -y autoconf && \
    apt-get install -y autoconf-archive && \
    apt-get install -y build-essential && \
    apt-get install -y curl && \
    apt-get install -y expect && \
    apt-get install -y git && \
    apt-get install -y htop && \
    apt-get install -y libgtk-3-dev && \
    apt-get install -y libncurses5-dev && \
    apt-get install -y libpython3-dev && \
    apt-get install -y libssl-dev && \
    apt-get install -y libxt-dev && \
    apt-get install -y openssh-server && \
    apt-get install -y python3-dbus && \
    apt-get install -y python3-docutils && \
    apt-get install -y python3-minimal && \
    apt-get install -y pkg-config && \
    apt-get install -y tmux && \
    apt-get install -y xsel && \
    apt-get install -y zsh

RUN chsh -s $(which zsh)
COPY install.sh .
RUN sh ./install.sh && rm ./install.sh && \
    echo '' >> /root/.oh-my-zsh/themes/robbyrussell.zsh-theme && \
    echo 'RPROMPT=%F{green}%~%f' >> /root/.oh-my-zsh/themes/robbyrussell.zsh-theme

COPY go1.18.linux-amd64.tar.gz .
RUN tar -C /usr/local -xvzf go1.18.linux-amd64.tar.gz && \
    rm -v ./go1.18.linux-amd64.tar.gz && \
    echo '' >> /root/.zshrc && \
    echo 'export GOPATH=/root/gocode' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/root/gocode/bin' >> /root/.zshrc && \
    sed -i '/^plugins=/s/git/git golang/' /root/.zshrc


COPY cmake-3.22.3.tar.gz .
RUN tar xvzf cmake-3.22.3.tar.gz && \
    cd cmake-3.22.3 && \
    ./bootstrap && make -j8 && make install && \
    cd .. && \
    rm -rv cmake-3.22.3*

COPY vim ./vim
RUN cd vim/src && \
    sed -i 's/^#CONF_OPT_PYTHON3 = --enable-python3interp$/CONF_OPT_PYTHON3 = --enable-python3interp/' Makefile && \
    make reconfig && \
    make -j8 && \
    make install && \
    cd /root && \
    rm -rv vim

COPY jdk-8u321-linux-x64.tar.gz .
RUN tar -C /usr/local -xvzf jdk-8u321-linux-x64.tar.gz && \
    echo "" >> /root/.zshrc && \
    echo 'export JAVA_HOME=/usr/local/jdk1.8.0_321' >> /root/.zshrc && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /root/.zshrc && \
    rm -v /root/jdk-8u321-linux-x64.tar.gz

COPY apache-maven-3.8.5-bin.tar.gz .
RUN tar -C /usr/local/ -xvzf apache-maven-3.8.5-bin.tar.gz && \
    rm -v /root/apache-maven-3.8.5-bin.tar.gz && \
    echo '' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/usr/local/apache-maven-3.8.5/bin' >> /root/.zshrc

RUN ssh-keygen -t ed25519 -C "zhehuama@deepglint.com" -q -f ~/.ssh/id_ed25519 -N ''

COPY ./vim_configure/.vimrc ./.vimrc
COPY ./vim_configure/.brackets.vim ./.brackets.vim

RUN echo '' >> .zshrc && \
    echo 'export LANG=C.UTF-8' >> .zshrc

EXPOSE 22
CMD ["tail", "-f", "/dev/null"]

