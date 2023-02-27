source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ] ; then
echo -e "\e[31mMissing RabbitMQ app user password argument\e[0m"
exit 1
fi
#proivde 'RoboShop@1' password at the time of executing bash payement.sh

component=payement

python