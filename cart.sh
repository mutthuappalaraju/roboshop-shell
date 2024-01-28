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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling new version NodeJS"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "install NodeJS"

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app

VALIDATE $? "creating app direcotry"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "downloading roboshop cart"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "unzipping cart"

npm install  &>> $LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/roboshop-shell/cart.service  /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "service reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "service enable"

systemctl start cart &>> $LOGFILE

VALIDATE $? "service started"