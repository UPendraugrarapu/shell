code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

echo -e "\e[36m installing nginx \e[0m"
yum install nginx -y &>>${log_file}

echo -e "\e[36m removing unwanted files \e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "\e[36m downloading the code \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file}

echo -e "\e[36m changing the directory \e[0m"
cd /usr/share/nginx/html

echo -e "\e[36m unzip the code file \e[0m"
unzip /tmp/frontend.zip  &>>${log_file}

echo -e "\e[36m copying the code to default location \e[0m"

cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf   &>>${log_file}

echo -e "\e[36m enable and restart nginx \e[0m"
systemctl enable nginx  &>>${log_file}
systemctl restart nginx   &>>${log_file}

