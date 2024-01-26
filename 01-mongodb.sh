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

if [ $id -ne 0 ]
then
    echo -e "$R please run the script root acess $N"
    exit 1
else
    echo -e "$G your root user $N"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo  &>> $LOGFILE

VALIDATE $? "copied mongo.repo"

dnf install mongodb-org -y  &>> $LOGFILE

VALIDATE $? "install mongodb"

systemctl enable mongod  &>> $LOGFILE

VALIDATE $? "enable mongodb"

systemctl start mongod  &>> $LOGFILE

VALIDATE $? "start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf  &>> $LOGFILE

VALIDATE $? "remote acess"

systemctl restart mongod  &>> $LOGFILE

VALIDATE $? "restart mongod"



