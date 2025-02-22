#!/data/data/com.termux/files/usr/bin/sh

# adb shell
# run-as com.termux files/usr/bin/bash -lic 'export PATH=/data/data/com.termux/files/usr/bin:$PATH; export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec.so; bash -i'

HOME='/data/user/0/com.termux/files/home'
cd $HOME || exit 1
passwd
pkg upgrade -y
pkg install openssh cronie termux-api -y
mkdir -p $HOME/.termux/boot/
mkdir data

cat >$HOME/.termux/boot/boot.sh <<EOL
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
termux-api-start
sshd
crond
bash ntfy.sh 'high' 'Phone booted'
bash -c 'nohup ./proximity.sh &'
EOL

chmod +x $HOME/.termux/boot/boot.sh
chmod +x ./*.sh

# Reboot