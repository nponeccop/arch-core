FROM archlinux
RUN setarch i686 pacman -Suy --noconfirm --noprogressbar --needed sudo
RUN useradd -m builder -G wheel -u 500
RUN sed -i 's|# %wheel ALL=(ALL) NOPASSWD: ALL|%wheel ALL=(ALL) NOPASSWD: ALL|' /etc/sudoers
WORKDIR /home/builder
USER builder
