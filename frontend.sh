source common.sh

print_head "installing nginx"
yum install nginx -y &>>${log_file}
echo $?
print_head "removing unwanted files"
rm -rf /usr/share/nginx/html/* &>>${log_file}
echo $?
print_head "downloading the code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file}
echo $?
print_head "changing the directory"
cd /usr/share/nginx/html
echo $?
print_head "unzip the code file"
unzip /tmp/frontend.zip  &>>${log_file}
echo $?
print_head "copying the code to default location"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf   &>>${log_file}
echo $?
print_head "enable and restart nginx"
systemctl enable nginx  &>>${log_file}
systemctl restart nginx   &>>${log_file}
echo $?
