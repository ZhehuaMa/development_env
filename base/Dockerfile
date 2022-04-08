FROM ubuntu:18.04

WORKDIR /root

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-get install -y apt-utils
RUN apt-get install -y autoconf
RUN apt-get install -y autoconf-archive
RUN apt-get install -y build-essential
RUN apt-get install -y curl
RUN apt-get install -y expect
RUN apt-get install -y gdb
RUN apt-get install -y git
RUN apt-get install -y htop
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
COPY install.sh .
RUN sh ./install.sh && rm ./install.sh && \
    echo '' >> /root/.oh-my-zsh/themes/robbyrussell.zsh-theme && \
    echo 'RPROMPT=%F{green}%~%f' >> /root/.oh-my-zsh/themes/robbyrussell.zsh-theme

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g commitizen && \
    npm install -g cz-conventional-changelog && \
    echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

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

RUN ssh-keygen -t ed25519 -C "zhehuama@deepglint.com" -q -f ~/.ssh/id_ed25519 -N '' && \
    touch /root/.ssh/authorized_keys

COPY ./vim_configure/.vimrc ./.vimrc
COPY ./vim_configure/.brackets.vim ./.brackets.vim

RUN echo '' >> .zshrc && \
    echo 'export LANG=C.UTF-8' >> .zshrc

RUN sed -i '/X11UseLocalhost/s/.*/X11UseLocalhost no/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["tail", "-f", "/dev/null"]

