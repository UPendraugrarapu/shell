source=common.sh
mysql_root_password=$1

if [ -z"${mysql_root_password}" ] ; then
echo -e "\e[31mMissing Mysql root password argument\e[0m"
exit 1
fi
#provide password while running mysql.sh 'RoboShop@1'
print_head "Disabling default mysql "
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Installing mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable and start mysql"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld  &>>${log_file}
status_check $?

print_head "Change default root password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?

