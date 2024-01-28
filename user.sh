#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGDB_HOST=mongodb.2512raju.online

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

dnf module disable nodejs -y

dnf module enable nodejs:18 -y

dnf install nodejs -y

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app  

VALIDATE $? "creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGFILE

VALIDATE $? "downloading user application"

cd /app 

unzip -o /tmp/user.zip  &>> $LOGFILE

VALIDATE $? "unzippping user"

npm install  &>> $LOGFILE

VALIDATE $? "installing npm"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service  &>> $LOGFILE

VALIDATE $? "copying user service"

systemctl daemon-reload  &>> $LOGFILE

VALIDATE $? "reloading daemon"

systemctl enable user  &>> $LOGFILE

VALIDATE $? "enabling user"

systemctl start user  &>> $LOGFILE

VALIDATE $? "starting user service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y  &>> $LOGFILE

VALIDATE $? "installing mongodb client"

mongo --host $MONGDB_HOST </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading user data into MongoDB"

