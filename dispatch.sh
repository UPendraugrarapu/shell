source common.sh

print_head "Install golang"
yum install golang -y &>>${log_file}
system_check $?

app_prereq_setup

cd/app

print_head "Download dependencies"
go mod init dispatch &>>${log_file}
go get  &>>${log_file}
go build &>>${log_file}
system_check $?

print_head "Reload system"
systemctl daemon-reload  &>>${log_file}
system_check $?

print_head "Enable and start service"
systemctl enable dispatch &>>${log_file}
systemctl start dispatch &>>${log_file}
system_check $?