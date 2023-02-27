code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {

echo -e "\e[35m$1\e[0m"
}

status_check() {

    if [ $1 -eq 0 ] ; then
       echo SUCCESS
    else
       echo FAILURE
       echo "Read the log file ${log_file} for more information about error"
       exit 1
    fi
}

schema_setup() {
if [ ${schema_type} == "mongo" ] ; then
  print_head "copy mongodb repo file server"
  cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  status_check $?
  print_head "install mongodb"
  yum install mongodb-org-shell -y &>>${log_file}
  status_check $?
  print_head "Load the schema"
  mongo --host mongodb.devopsb71.tech </app/schema/${component}.js &>>${log_file}
  status_check $?
fi
}


nodejs () {
    print_head "Configuring the nodejs repo files"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installing nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Add user"
id roboshop &>>${log_file}
if [ $? -ne 0 ] ; then
 useradd roboshop &>>${log_file}
 fi
status_check $?

print_head "Create directory"
if [ ! -d /app ] ; then
 mkdir /app  &>>${log_file}
 fi
status_check $?

print_head "Removing old files"
rm -rf /app/* &>>${log_file}
status_check $?
print_head "Download app content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}
status_check $?
print_head "Change directory & extract the app content file"
cd /app &>>${log_file}
unzip /tmp/${component}.zip &>>${log_file}
status_check $?
print_head "change directory & install nodejs dependencies"
cd /app &>>${log_file}
npm install &>>${log_file}
status_check $?
print_head "copy the systemd service file"
cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?
print_head "Reload the service"
systemctl daemon-reload &>>${log_file}
status_check $?
print_head "Enable and start the service"
systemctl enable ${component} &>>${log_file}
systemctl start ${component} &>>${log_file}
status_check $?

schema_setup

}