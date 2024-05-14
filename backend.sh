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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabling Default version of NodeJs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabling NodeJs Version of 20"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing NodeJs"

id expense &>>$LOG_FILE
if [ $? -ne 0 ]
then
    useradd expense
else
    echo "user already added"
fi

