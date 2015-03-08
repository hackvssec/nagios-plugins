# nagios-plugins

## check_expiry.sh
自动扫描常规用户，分别检查密码有效期，并提供报警：<br />
10天以上    正常<br />
5天至9天    报警<br />
4天以内     紧急<br />
已过期      紧急<br />
<br />
### 依赖：
我们需要为nagios和nrpe用户提权，用"visudo"命令来编辑/etc/sudoers,  <br />
> nagios ALL=NOPASSWD: /usr/bin/chage -l * <br />
> nrpe ALL=NOPASSWD: /usr/bin/chage -l * <br />
> Defaults:nrpe !requiretty <br />
"wq"保存退出即可。