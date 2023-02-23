code_dir=$(pwd)
echo -e "\e[36m installing nginx \e[0m"
yum install nginx -y

echo -e "\e[36m removing unwanted files \e[0m"
rm -rf /usr/share/nginx/html/* 

echo -e "\e[36m downloading the code \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

echo -e "\e[36m changing the directory \e[0m"
cd /usr/share/nginx/html 

echo -e "\e[36m unzip the code file \e[0m"
unzip /tmp/frontend.zip

echo -e "\e[36m copying the code to default location \e[0m"

cp $(code_dir)configs/nginx-roboshop.conf /etc/nginx/defualt.d/roboshop.conf

echo -e "\e[36m enable and restart nginx \e[0m"
systemctl enable nginx 
systemctl restart nginx  

