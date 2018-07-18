firewall-cmd --zone=public --add-port=3001/tcp
firewall-cmd --zone=public --remove-port=27017/tcp --permanent
firewall-cmd --zone=public --add-port=27017/tcp --permanent
firewall-cmd --reload
