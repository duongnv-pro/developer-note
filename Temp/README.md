![](https://i.imgur.com/waxVImv.png)


### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)
## Old DevNotes
Remove program

```bash
sudo apt-get --purge remove NameOfProgram
sudo rm -rf .NameOfProgram
sudo apt-get remove NameOfProgram
sudo apt-get remove --auto-remove NameOfProgram
```

Config Git SSH, #ssh, #git

```bash
git config --global user.name "duongshiro"
git config --global user.email "xxx@gmail.com"

// Add new SSH
ssh-keygen -t rsa -C "xxx@gmail.com"
    enter name:  /home/duongnv/.ssh/id_rsa_home
    copy content below
cat ~/.ssh/id_rsa_home.pub
    open github: https://github.com/settings/keys
    add NEW SSH KEY

// Config multi SSH
touch ~/.ssh/config
sudo vi ~/.ssh/config

    --CONTENT CONFIG--

#personal account
Host github.com
	HostName github.com
	IdentityFile ~/.ssh/id_rsa_home

#sun account
Host sun.github.com
	HostName github.com
	IdentityFile ~/.ssh/id_rsa_sun

    --END CONTENT CONFIG--

// Update remote project
git remote
git remote set-url framgia git@sun.github.com:framgia/XXX.git
    note: sun.github.com
ggpush // TEST OK?
```

Clone Project

```bash
git clone git@github.com:../XXX.git
cd App
git remote -v
git remote add framgia git@github.com:framgia/XXX.git
git fetch framgia --all
```

Setting project

```bash
gem install rmagick -v '2.16.0'
gem install rmagick -v '2.16.0' --source 'https://rubygems.org/'
sudo apt-get install imagemagick
sudo apt autoremove
sudo apt update
sudo apt-get install imagemagick
sudo apt-get install libmagickwand-dev
sudo apt-get install nginx
```

Setting nginx

```bash
sudo subl nginx.conf
sudo subl /etc/nginx/
sudo subl /etc/hosts
nginx -t // Check log nginx
```

Install JDK

```bash
sudo apt-get install openjdk-8-jre
```

Install Elasticsearch

```bash
curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.16.deb
sudo dpkg -i elasticsearch-5.6.16.deb
sudo /etc/init.d/elasticsearch start
sudo service elasticsearch start
cd /usr/share/elasticsearch
sudo bin/elasticsearch-plugin install analysis-kuromoji
```

Install Mysql

```bash
sudo apt-get update
sudo apt-get install mysql-server
sudo mysql_secure_installation utility
mysql
/usr/bin/mysql -u root -p
sudo ufw enable
sudo ufw allow mysql
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl restart mysql
/usr/bin/mysql -u root -p
sudo mysql -u root
service mysql restart
```

Install Mysql-workbeach

```bash
sudo apt-get install mysql-workbench
```

Run project

```bash
cd DISCO
gem install mysql2 -v '0.3.21' --source 'https://rubygems.org/'
sudo apt-get install libmysqlclient-dev
bundle install
bundle exec rake db:create
sudo mysql -u  root DISCO_development < tuannm.sql
rails c // TEST OK?
redis-server --daemonize yes
```

Install redis server

```bash
sudo apt-get install redis-server
sudo systemctl enable redis-server.service
redis-server --daemonize yes
rails s // TEST OK?
```

Install kibana service, #kibana, #install

```bash
???

```

Install unrar #unrar, #install

```bash
sudo apt install unrar
```

Setup DISCO project #disco

```bash
bundle update mimemagic
rails db:create
rails db:migrate
```

Export, Import Database
#mysql, #export data, #import data, #export mql

```bash
mysql -u  root -p DISCO_development < DISCO_development.sql

mysqldump -u root -p DISCO_development > DISCO_development.sql
```

Search + kill process running

```bash
ps aux | grep redis
kill -9 1207
```

Install peek | Support gif #peek #gif

```bash
sudo add-apt-repository ppa:peek-developers/stable
sudo apt-get update
sudo apt install peek
```

Grep #grep

```bash
grep -rnw "Test user seach" app --exclude="messages.js"
```

VS Code export current extention #VSCode, #vs code

```bash
code --list-extensions | xargs -L 1 echo code --install-extension > output.txt
echo "code --list-extensions | xargs -L 1 echo code --install-extension > output.txt" >> output.txt
cat output.txt
```

Install virtualbox + genymotion
#virtualbox #genymotion #install

```bash
sudo apt install virtualbox
chmod +x ~/Downloads/genymotion-3.1.2-linux_x64.bin
sudo ~/Downloads/genymotion-3.2.1-linux_x64.bin

chmod +x ~/Downloads/genymotion-3.1.2-linux_x64.bin
sudo ~/Downloads/genymotion-3.2.1-linux_x64.bin --uninstall
```

Install create-react-app, #npx #react app #create react app, #npm

```bash
sudo apt install npm
// sudo npm install -g npx --force
// sudo npm install -g npm@next --force

export PATH=$HOME/.node_modules_global/bin:$PATH
npm config set prefix /usr/local
sudo npm install -g create-react-app
create-react-app react-app  // TEST OK?
cd react-app
npm start
```

Install ruby gc #rbenv #install ruby

```bash
rbenv --help
rbenv install 2.7.2
rbenv local 2.7.2
rbenv versions // TEST OK?
ruby -v // TEST OK?
```

GC run hook eslint #gc #hook #eslint

```bash
./scripts/install_hook.sh
```

Install mailhog #mailhog

```bash
sudo apt-get -y install golang-go
go get github.com/mailhog/MailHog
```
