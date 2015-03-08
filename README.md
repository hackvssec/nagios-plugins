# nagios-plugins

## check_expiry.sh
自动扫描常规用户，分别检查密码有效期，并提供报警：<br />
10天以上    正常<br />
5天至9天    报警<br />
4天以内     紧急<br />
已过期      紧急<br />
<br />
### 依赖如下命令：
visudo  <br />
> nagios ALL=NOPASSWD: /usr/bin/chage -l *
> nrpe ALL=NOPASSWD: /usr/bin/chage -l *
> Defaults:nrpe !requiretty