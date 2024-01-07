FROM archlinux:latest

RUN pacman -Syuu --noconfirm jdk-openjdk kotlin git openssh curl zsh
ENTRYPOINT [ "/bin/zsh" ]

COPY . /root/config

WORKDIR /root
RUN echo "source /root/config/selector.sh --env-shell" >>.bash_profile
RUN echo "source /root/config/selector.sh --no-env" >>.bashrc
RUN echo "source /root/config/selector.zsh --env-shell" >>.zshenv
RUN echo "source /root/config/selector.zsh --no-env" >>.zshrc

RUN echo "[include]" >>.gitconfig
RUN echo "	path = /root/config/gitconfig" >>.gitconfig
