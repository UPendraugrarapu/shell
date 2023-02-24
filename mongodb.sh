source common.sh

print_head "setup mongodb repository"
cp ${code_dir}configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "updating the mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf

print_head "enable and start mongodb service"
systemctl enable mongod &>>${log_file}
systemctl start mongod &>>${log_file}

