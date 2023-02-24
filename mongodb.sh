source common.sh

print_head "setup mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "installing mongodb"
yum install mongodb-org -y

print_head "enable and start mongodb service"
systemctl enable mongod
systemctl start mongod

#replace 127.0.0.1 with 0.0.0.0 in vim /etc/mongod.conf