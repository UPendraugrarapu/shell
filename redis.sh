source common.sh

print_head "Install redis remi repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>${log_file}
status_check $?

print_head "Enabling redis"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "Installing redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "update listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "Enable and start redis"
systemctl enable redis &>>${log_file}
systemctl start redis &>>${log_file}
status_check $?