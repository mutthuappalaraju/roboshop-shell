#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script start executing $TIMESTAMP"  &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R failure $N"
        exit 1
    else
        echo -e "$2....$G success $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R please run the script root acess $N"
    exit 1
else
    echo -e "$G your root user $N"
fi

dnf module disable mysql -y  &>> $LOGFILE

VALIDATE $? "disable curresnt mysql version"

cp mysql.repo  /etc/yum.repos.d/mysql.repo  &>> $LOGFILE

VALIDATE $? "copying mysql repo"

dnf install mysql-community-server -y  &>> $LOGFILE

VALIDATE $? "installing mysql server"

systemctl enable mysqld  &>> $LOGFILE

VALIDATE $? "enable mysql"

systemctl start mysqld  &>> $LOGFILE

VALIDATE $? "starting mysql server"

mysql_secure_installation --set-root-pass RoboShop@1  &>> $LOGFILE

VALIDATE $? "setting mysql root password"