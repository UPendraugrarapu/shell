source common.sh

print_head "Downloading the nodejs repo files"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installing nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Add user"
id roboshop &>>${log_file}
if [ &? -ne 0 ] ; then
 useradd roboshop &>>${log_file}
 fi
status_check $?

print_head "Create directory"
if [ ! -d /app ] ; then
 mkdir /app  &>>${log_file}
 fi
status_check $?

print_head "Removing unwanted files"
rm -rf /app/* &>>${log_file}
status_check $?
print_head "Download app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log_file}
status_check $?
print_head "Change directory & extract the app content file"
cd /app &>>${log_file}
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?
print_head "change directory & install nodejs dependencies"
cd /app &>>${log_file}
npm install &>>${log_file}
status_check $?
print_head "copy the systemd service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?
print_head "Reload the service"
systemctl daemon-reload &>>${log_file}
status_check $?
print_head "Enable and start the service"
systemctl enable catalogue &>>${log_file}
systemctl start catalogue &>>${log_file}
status_check $?
print_head "copy mongodb repo file server"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?
print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?
print_head "Load the schema"
mongo --host mongodb.devopsb71.tech </app/schema/catalogue.js &>>${log_file}
status_check $?