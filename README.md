# Cobbler 批量装机

> 这是一个运行在docker里的cobbler平台。

### 使用说明
1. 启动容器
   ```
   docker run -itd \
      --name cobbler \
      --net host \
      -v /mnt:/mnt \
      -e SERVER_IP="192.168.88.10" \
      -e ROOT_PASSWORD="China123" \
      -e DHCP_RANGE="192.168.88.200 192.168.88.230" \
      -e DHCP_SUBNET="192.168.88.0" \
      -e DHCP_ROUTER="192.168.88.1" \
      -e DHCP_DNS="223.5.5.5" \
      liujinbao3000/cobbler:latest
   ```
1. 访问cobbler_web
   https://127.0.0.1/cobbler_web
   用户名:`cobbler`密码:`cobbler`
1. 访问容器
   ```
   docker exec it cobbler bash
   ```
1. 示例
   1. 挂载ISO
      ```
      sudo mount CentOS-6.5-x86_64-bin-DVD1.iso /mnt
      ```
   1. 导入cobbler (确定容器的/mnt下有ISO里的文件)
      Import DVD
      Prefix:CentOS-6.5-x86_64
      Arch:x86_64
      Breed:Red Hat based(includes Fedora,CentOS,...) 
      Path:/mnt
      Run
      ![示例](cobbler.png)
   1. Centos7挂载后好像自动应答文件不对不能自动安装. 