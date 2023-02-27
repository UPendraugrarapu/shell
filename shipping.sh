source common.sh

mysql_root_password=$1

if [ -z"${mysql_root_password}" ] ; then
  echo -e "\e[31mMissing Mysql root password argument\e[0m"
  exit 1
fi
#proivde 'RoboShop@1' password at the time of executing bash shipping.sh

component=shipping
schema_type="mysql"
java

