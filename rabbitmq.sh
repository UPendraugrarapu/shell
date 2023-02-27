source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ] ; then
echo -e "\e[31mMissing RabbitMQ app user password argument\e[0m"
exit 1
fi
#While running add password 'roboshop123' to the bash Rabbitmq.sh
print_head "Setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "Setup RabbitMQ repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "Install RabbitMQ and Erlang"
yum install rabbitmq-server erlang -y &>>${log_file}
status_check $?

print_head "Enable and start RabbitMQ service"
systemctl enable rabbitmq-server &>>${log_file}
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "Add application user"
rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
status_check $?

print_head "Configure permissions to app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?