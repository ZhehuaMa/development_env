FROM ubuntu:20.04

WORKDIR /root

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai

# Use Netease mirror sources
COPY sources.list-20.04 /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-get install -y apt-utils
RUN apt-get install -y autoconf
RUN apt-get install -y autoconf-archive
RUN apt-get install -y build-essential
RUN apt-get install -y curl
RUN apt-get install -y eog
RUN apt-get install -y expect
RUN apt-get install -y gdb
RUN apt-get install -y git
RUN apt-get install -y htop
RUN apt-get install -y jq
RUN apt-get install -y libgtk-3-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libpython3-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libxt-dev
RUN apt-get install -y openssh-server
RUN apt-get install -y python3-dbus
RUN apt-get install -y python3-docutils
RUN apt-get install -y python3-minimal
RUN apt-get install -y pkg-config
RUN apt-get install -y tmux
RUN apt-get install -y xsel
RUN apt-get install -y zsh

RUN chsh -s $(which zsh)
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    echo '' >> /root/.oh-my-zsh/themes/robbyrussell.zsh-theme && \
    echo 'RPROMPT=%F{green}%~%f' >> /root/.oh-my-zsh/themes/robbyrussell.zsh-theme

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g commitizen && \
    npm install -g cz-conventional-changelog && \
    echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

RUN curl -fsSLO https://go.dev/dl/go1.18.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xvzf go1.18.5.linux-amd64.tar.gz && \
    rm ./go1.18.5.linux-amd64.tar.gz && \
    echo '' >> /root/.zshrc && \
    echo 'export GOPATH=/root/gocode' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/root/gocode/bin' >> /root/.zshrc && \
    sed -i '/^plugins=/s/git/git golang/' /root/.zshrc

RUN curl -fsSLO https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3.tar.gz && \
    tar xvzf cmake-3.22.3.tar.gz && \
    cd cmake-3.22.3 && \
    ./bootstrap && make -j8 && make install && \
    cd .. && \
    rm -r cmake-3.22.3*

RUN git clone https://github.com/vim/vim.git && \
    cd vim/src && \
    sed -i 's/^#CONF_OPT_PYTHON3 = --enable-python3interp$/CONF_OPT_PYTHON3 = --enable-python3interp/' Makefile && \
    make reconfig && make -j8 && make install && \
    cd /root && \
    rm -r vim

# Download JDK manually.
COPY jdk-8u321-linux-x64.tar.gz .
RUN tar -C /usr/local -xvzf jdk-8u321-linux-x64.tar.gz && \
    rm /root/jdk-8u321-linux-x64.tar.gz && \
    echo "" >> /root/.zshrc && \
    echo 'export JAVA_HOME=/usr/local/jdk1.8.0_321' >> /root/.zshrc && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /root/.zshrc

RUN curl -fsSLO https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
    tar -C /usr/local/ -xvzf apache-maven-3.8.6-bin.tar.gz && \
    rm /root/apache-maven-3.8.6-bin.tar.gz && \
    echo '' >> /root/.zshrc && \
    echo 'export PATH=$PATH:/usr/local/apache-maven-3.8.6/bin' >> /root/.zshrc

# RUN ssh-keygen -t ed25519 -C "zhehuama@deepglint.com" -q -f ~/.ssh/id_ed25519 -N ''
RUN mkdir /root/.ssh && touch /root/.ssh/authorized_keys

RUN git clone https://github.com/ZhehuaMa/vim_configure.git && \
    ln -s vim_configure/.vimrc vim_configure/.brackets.vim .

RUN echo '' >> .zshrc && \
    echo 'export LANG=C.UTF-8' >> .zshrc

RUN sed -i '/X11UseLocalhost/s/.*/X11UseLocalhost no/' /etc/ssh/sshd_config

RUN sed -i '/^plugins=/s/git/git docker/' /root/.zshrc

SHELL ["/bin/zsh", "-c"]
RUN echo '' >> $HOME/.zshrc && \
    echo 'export GOPROXY="https://proxy.golang.com.cn,direct"' >> $HOME/.zshrc && \
    echo 'export GONOPROXY="https://gitlab.deepglint.com"' >> $HOME/.zshrc
RUN source $HOME/.zshrc && go install golang.org/x/tools/gopls@latest
RUN source $HOME/.zshrc && go install github.com/go-delve/delve/cmd/dlv@latest
RUN source $HOME/.zshrc && go install github.com/ramya-rao-a/go-outline@latest
RUN curl -fsSLO https://github.com/golangci/golangci-lint/releases/download/v1.45.2/golangci-lint-1.45.2-linux-amd64.tar.gz && \
    tar xvzf golangci-lint-1.45.2-linux-amd64.tar.gz && \
    cp golangci-lint-1.45.2-linux-amd64/golangci-lint $HOME/gocode/bin/ && \
    rm -rf golangci-lint-1.45.2-linux-amd64/ golangci-lint-1.45.2-linux-amd64.tar.gz
SHELL ["/bin/sh", "-c"]

EXPOSE 22
CMD ["tail", "-f", "/dev/null"]

