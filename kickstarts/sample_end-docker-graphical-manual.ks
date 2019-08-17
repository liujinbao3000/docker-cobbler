# This kickstart file should only be used with EL > 5 and/or Fedora > 7.
# For older versions please use the sample.ks kickstart file.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
#text
#graphical
graphical
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  Asia/Shanghai
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
#autopart

# Disk partitioning information
# method1 stand part
#   1. biosboot:2M
#   2./boot:1G
#   3./:50G
#   4.swap:8G
#   5./home:max
#part biosboot --fstype="biosboot" --ondisk=sda --size=2
#part /boot --fstype="xfs" --ondisk=sda --size=1024
#part / --fstype="xfs" --ondisk=sda --size=51200
#part swap --fstype="swap" --ondisk=sda --size=8192
#part /home --fstype="xfs" --ondisk=sda  --grow --size=31387

# method2 stand+lvm parts
#part biosboot --fstype="biosboot" --ondisk=sda --size=2
#part /boot --fstype="xfs" --ondisk=sda --size=1024
#part swap --fstype="swap" --ondisk=sda --size=8192
#part pv.709 --fstype="lvmpv" --ondisk=sda --grow --size=90780
#volgroup centos --pesize=4096 pv.709
#logvol /  --fstype="xfs" --size=51200 --name=root --vgname=centos
#logvol /home  --fstype="xfs" --grow --size=39575 --name=home --vgname=centos

# method3 auto parts
#autoparts
%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
$SNIPPET('func_install_if_enabled')
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
rm -f /etc/yum.repos.d/cobbler-config.repo
rm -f /root/ks-* /root/cobbler.ks /root/original-ks.cfg
#curl -o /root/set-ip http://192.168.88.100/cobbler/pub/set-ip
#chmod +x /root/set-ip
echo "UseDNS no" >> /etc/ssh/sshd_config
systemctl restart sshd
%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end
