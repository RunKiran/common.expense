#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read  mysql_root_password

#Install MySQL Server 8.0.x

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of MySql"

#Start MySQL Service

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabled  of MySql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting  of MySql"

#We need to change the default root password in order to start using the database service. Use password ExpenseApp@1 or any other as per your choice.
# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting up root passwd"

mysql -h db.mkaws.online -u  root -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi