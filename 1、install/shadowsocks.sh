# Centos 7 install shadowsocks
# Author by djshi

#!/bin/bash



chockos()
{
os=`cat /etc/redhat-release | grep -oP "(?<=release )[0-9]"`
[ $os -ne 7 ] && echo -e "\033[31;49;1m 当前操作系统非centos7,请更换操作系统 \033[39;49;0m" && exit 1
}

firewalld()
{
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config && setenforce 0
}

installpip()
{
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py
! which pip && echo -e "\033[31;49;1m pip未安装成功 \033[39;49;0m" && exit 1
}

shadowsocks()
{
pip install --upgrade pip && pip install shadowsocks
cat > /etc/shadowsocks.json << EOF
{
"server": "0.0.0.0",
"port_password": {
"8381": "foobar1",
"8382": "foobar2",
"8383": "foobar3",
"8384": "foobar4"
},
"timeout": 300,
"method": "aes-256-cfb"
}
EOF
}

systemctl()
{
cat > /etc/systemd/system/shadowsocks.service << EOF
[Unit]
Description=Shadowsocks

[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/ssserver -c /etc/shadowsocks.json

[Install]
WantedBy=multi-user.target
EOF
}

servicestart()
{
systemctl start shadowsocks && systemctl enable shadowsocks
! systemctl status shadowsocks | grep running && systemctl start shadowsocks && systemctl enable shadowsocks
! systemctl status shadowsocks | grep running && echo -e "\033[31;49;1m shadowsocks启动失败,请手动排查 \033[39;49;0m" && exit 1
echo -e "\033[32;49;1m shadowsocks已成功启动 \033[39;49;0m"
echo -e "\033[32;49;1m 注意： \033[39;49;0m"
echo -e "\033[32;49;1m 1、防火墙和selinux已关闭；如需防火墙，请手动开启并配置策略 \033[39;49;0m"
echo -e "\033[32;49;1m 2、端口和密码请在 /etc/shadowsocks.json 文件中查看并修改 \033[39;49;0m"
}

run()
{
chockos
firewalld
installpip
shadowsocks
systemctl
servicestart
}

run