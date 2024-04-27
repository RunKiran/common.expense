#!/bin/bash
echo "Please enter DB password:"
read  mysql_root_password

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading backend code"

cd /app 
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "extracting backend code"
 

npm install &>>$LOGFILE
VALIDATE $? "installation of nodejs dependencies"

#coping backend file 
cp /home/ec2-user/expenses-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copy of backend service"

# we need to install mysql client
dnf install mysql -y &>>$LOGFILE
VALIDATE $? "installation of mysql-client"

systemctl daemon-reload
VALIDATE $? "deamon-reloaded"

systemctl enable backend.service
VALIDATE $? "enabled backend"

systemctl start backend.service
VALIDATE $? "started backend"

#Load Schema
mysql -h db.mkaws.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "dbrecords are updated"

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disabled  modules"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enaabled  module20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installation of Nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
else
    echo -e "Expense user already cre





#Restart the service 
systemctl restart backend.service &>>$LOGFILE
VALIDATE $? "restarting backend"