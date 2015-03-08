#!/bin/bash
# Check Password expiry on Linux
# 自动扫描常规用户，分别检查密码有效期，并提供报警：
# 10天以上    正常
# 5天至9天    报警
# 4天以内     紧急
# 已过期      紧急
#
# 依赖如下命令：
# visudo
# nagios ALL=NOPASSWD: /usr/bin/chage -l *
# nrpe ALL=NOPASSWD: /usr/bin/chage -l *
# Defaults:nrpe !requiretty
# 脚本维护   刘远生

EXIT_STATUS=0

function check_usage {
        if (( $# >= 1 ))
        then
                echo "Usage: ./check_expiry.sh"
        exit 3
        fi
}

function calculate_days_till_expiry {
        get_expiry_date=$(sudo /usr/bin/chage -l $1 | grep 'Password expires' | cut -d: -f2)
        if [[ $get_expiry_date = ' never' || $get_expiry_date = 'never' ]]
        then
            echo "[$1 - Password never expires]  "
            chage_exit_status 0
        elif
            password_expiry_date=`date -d "$get_expiry_date" "+%s"`
            current_date=$(date "+%s")
            diff=$(($password_expiry_date-$current_date))
            let DAYS=$(($diff/(60*60*24)))
            then
            if (($DAYS>=10))
            then
                echo "[$1 - OK - Password is $DAYS days from expiry]  "
                chage_exit_status 0
            elif (($DAYS>=5 && $DAYS<=9))
            then
                echo "[$1 - WARNING - Password is $DAYS days from expiry]  "
                chage_exit_status 1
            elif (($DAYS>=0 && $DAYS<=4))
            then
                echo "[$1 - CRITICAL - Password is $DAYS days from expiry]  "
                chage_exit_status 2
            elif (($DAYS<=0))
            then
                echo "[$1 - CRITICAL - The password has expired]  "
                chage_exit_status 2
            fi
        fi
}
function chage_exit_status {
    if (($EXIT_STATUS<$1));then 
        EXIT_STATUS=$1;
    fi
}
check_usage $1
for user in `cat /etc/passwd | grep /bin/bash | cut -d: -f1`;do
 calculate_days_till_expiry $user
done

exit $EXIT_STATUS

