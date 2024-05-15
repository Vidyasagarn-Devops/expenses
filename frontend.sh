#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2..... $R Failure $N"
        exit 1
    else
        echo -e "$2.... $G Success $N"
    fi

}


if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access"
    exit 1
else
    echo "You are super user"
fi

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing existing contents"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Downloading Frontend Code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip
VALIDATE $? "Extracting HTML Code"



