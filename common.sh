code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {

    echo -e "\e[35m$1\e[0m"
}

status_check() {

    if [ $1 -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
        echo "Read the log file ${log_file} for more information about error"
        exit 1
    fi
}

systemd_setup() {
    print_head "copy the systemd service file"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

#This sed operation is only for payment service, for other services it will not be any impact
sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}

    print_head "Reload the service"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    print_head "Enable and start the service"
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}
    status_check $?
}

schema_setup() {
    if [ "${schema_type}" == "mongo" ]; then
        print_head "copy mongodb repo file server"
        cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
        status_check $?
        print_head "install mongodb"
        yum install mongodb-org-shell -y &>>${log_file}
        status_check $?
        print_head "Load the schema"
        mongo --host mongodb.devopsb71.tech </app/schema/${component}.js &>>${log_file}
        status_check $?
    elif [ "${schema_type} "== "mysql" ]; then
        print_head "Install mysql client"
        yum install mysql -y &>>${log_file}
        status_check $?

        print_head "Load schema"
        mysql -h mysql.devopsb71.tech -uroot -p${mysql_root_password} </app/schema/${component}.sql &>>${log_file}
        status_check $?

    fi
}

app_prereq_setup() {
    print_head "Add user"
    id roboshop &>>${log_file}
    if [ $? -ne 0 ]; then
        useradd roboshop &>>${log_file}
    fi
    status_check $?

    print_head "Create directory"
    if [ ! -d /app ]; then
        mkdir /app &>>${log_file}
    fi
    status_check $?

    print_head "Removing old files"
    rm -rf /app/* &>>${log_file}
    status_check $?
    print_head "Download app content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    status_check $?
    print_head "Change directory & extract the app content file"
    cd /app &>>${log_file}
    unzip /tmp/${component}.zip &>>${log_file}
    status_check $?
}

nodejs() {
    print_head "Configuring the nodejs repo files"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
    status_check $?

    print_head "Installing nodejs"
    yum install nodejs -y &>>${log_file}
    status_check $?

    app_prereq_setup

    print_head "change directory & install nodejs dependencies"
    cd /app &>>${log_file}
    npm install &>>${log_file}
    status_check $?

    schema_setup
    
    systemd_setup
}

java() {

    print_head "Installing maven"
    yum install maven -y &>>${log_file}
    status_check $?

    app_prereq_setup

    print_head "Download dependencies and package"
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
    status_check $?

#schema setup function
    schema_type

#systemD function
    systemd_setup

}

pyhton() {
    print_head "Installing python"
    yum install python36 gcc python3-devel -y &>>${log_file}
    status_check $?

    app_prereq_setup

    print_head "Download dependencies "
    pip3.6 install -r requirements.txt &>>${log_file}   
    status_check $?


#systemD function
    systemd_setup


}