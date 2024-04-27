#!/bin/bash

source ./common.sh

check_root

#Install Nginx

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "installation of nginx"

#Enable nginx

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "nginx enabled"

#Start nginx

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting nginx"

#Remove the default content that web server is serving.

rm -rf /usr/share/nginx/html/* &>>$LOGFILE


#Download the frontend content

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip

#Extract the frontend content.

cd /usr/share/nginx/html


unzip /tmp/frontend.zip &>>$LOGFILE

VALIDATE $? "extraction of code"

cp /home/ec2-user/expenses-shell/expense.conf /etc/nginx/default.d/expense.conf
systemctl restart nginx

VALIDATE $? "restarting of nginx"