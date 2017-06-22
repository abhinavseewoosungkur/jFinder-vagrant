#!/bin/sh
set -x
# echo Get the base system up to date
sudo apt-get update

echo 'mysql-server mysql-server/root_password password root' | sudo debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root' | sudo debconf-set-selections

sudo apt-get install -q -y git zsh openjdk-8-jdk-headless maven mysql-server mysql-client curl

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo chsh -s /usr/bin/zsh ubuntu

echo Fix repeated characters in zsh
cat <<EOF >> ~/.zshrc

# Fix repeated characters at the start of commands
export LC_CTYPE=en_US.UTF-8
EOF

git clone https://github.com/abhinavseewoosungkur/jFinder.git

# setup persistence
cd jFinder
sed -i 's/validate/create-drop/g' src/main/webapp/WEB-INF/persistence.xml
mysql -u root -proot -Bse "CREATE SCHEMA jfinder;"

## Execute the commands below
## create the db and stop the server
# mvn clean jetty:run-exploded
## create an admin user
# mysql -u root -proot -Bse "use jfinder; insert into admin(name, password) values ('admin', 'admin'); commit;"

# Visit localhost:8080/Administrator on the host machine and login as user admin and password admin
