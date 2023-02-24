source common.sh

print_head "Downloading the nodejs repo files"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Installing nodejs"
yum install nodejs -y &>>${log_file}

print_head "Add user"
useradd roboshop &>>${log_file}

print_head "Create directory"
mkdir /app  &>>${log_file}

print_head "Removing unwanted files"
rm -rf /app/* &>>${log_file}

print_head "Download catalogue service code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log_file}

print_head "Change directory & unzip the code file"
cd /app &>>${log_file}
unzip /tmp/catalogue.zip &>>${log_file}

print_head "change directory & install dependencies"
cd /app &>>${log_file}
npm install &>>${log_file}

print_head "copy the catalogue service file"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload the service"
systemctl daemon-reload &>>${log_file}

print_head "Enable and start the service"
systemctl enable catalogue &>>${log_file}
systemctl start catalogue &>>${log_file}

print_head "copy mongodb repo file server"
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Load the schema"
mongo --host mongodb.devopsb71.tech </app/schema/catalogue.js &>>${log_file}
