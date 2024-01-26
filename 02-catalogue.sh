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

dnf module disable nodejs -y  &>> $LOGFILE

VALIDATE $? "disable nodejs"

dnf module enable nodejs:18 -y  &>> $LOGFILE

VALIDATE $? "enable nodejs"

dnf install nodejs -y  &>> $LOGFILE

VALIDATE $? "install nodejs"

id roboshop

if [ $? -ne 0 ]
    then 
        useradd roboshop
        VALIDATE $? " roboshop user creation"
    else
        echo -e "user already creating...$Y skipping $N"
    fi

mkdir -p /app

VALIDATE $? "app directory creating"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE

VALIDATE $? "downloading catalogue"

cd /app 

unzip -o /tmp/catalogue.zip  &>> $LOGFILE

VALIDATE $? "unzipping catalogue"

npm install  &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying catalogue service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue  &>> $LOGFILE

VALIDATE $? "start catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo 

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y  &>> $LOGFILE

VALIDATE $? "install mongodb client"

mongo --host $MONGDB_HOST </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalouge data into MongoDB"












