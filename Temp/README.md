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

## 11 Tips To Maximize the Power of TypeScript’s Type System

### Think in {Set}

```typescript
type Measure = { radius: number };
type Style = { color: string };

// typed { radius: number; color: string }
type Circle = Measure & Style;
```

```typescript
type ShapeKind = 'rect' | 'circle';
let foo: string = getSomeString();
let shape: ShapeKind = 'rect';

// disallowed because string is not subset of ShapeKind
shape = foo;

// allowed because ShapeKind is subset of string
foo = shape;
```

### Use Discriminated Union Instead of Optional Fields
```typescript
type Shape = {
  kind: 'circle' | 'rect';
  radius?: number;
  width?: number;
  height?: number;
}

function getArea(shape: Shape) {
  return shape.kind === 'circle' ?
    Math.PI * shape.radius! ** 2
    : shape.width! * shape.height!;
}
```
The non-null assertions (when accessing radius, width, and height fields) are needed because there’s no established relationship between kind and other fields. Instead, a discriminated union is a much better solution. Here’s what that looks like:

```typescript
type Circle = { kind: 'circle'; radius: number };
type Rect = { kind: 'rect'; width: number; height: number };
type Shape = Circle | Rect;

function getArea(shape: Shape) {
  return shape.kind === 'circle' ?
    Math.PI * shape.radius ** 2
    : shape.width * shape.height;
}
```

### Stay DRY By Being Creative With Type Manipulation
Instead of duplicating field declarations,
```typescript
type User = {
    age: number;
    gender: string;
    country: string;
    city: string
};
type Demographic = { age: number: gender: string; };
type Geo = { country: string; city: string; };
```
use the `Pick` utility to extract new types:

```typescript
type User = {
    age: number;
    gender: string;
    country: string;
    city: string
};
type Demographic = Pick<User, 'age'|'gender'>;
type Geo = Pick<User, 'country'|'city'>;
```

Instead of duplicating the function’s return type,
```typescript
function createCircle() {
    return {
        kind: 'circle' as const,
        radius: 1.0
    }
}

function transformCircle(circle: { kind: 'circle'; radius: number }) {
    ...
}

transformCircle(createCircle());
```
use `ReturnType<T>` to extract it:
```typescript
function createCircle() {
    return {
        kind: 'circle' as const,
        radius: 1.0
    }
}

function transformCircle(circle: ReturnType<typeof createCircle>) {
    ...
}

transformCircle(createCircle());
```

Instead of synchronizing shapes of two types (typeof config and Factory here) in parallel,
```typescript
type ContentTypes = 'news' | 'blog' | 'video';

// config for indicating what content types are enabled
const config = { news: true, blog: true, video: false }
    satisfies Record<ContentTypes, boolean>;

// factory for creating contents
type Factory = {
    createNews: () => Content;
    createBlog: () => Content;
};
```
use `Mapped Type` and `Template Literal` Type to automatically infer the proper factory type based on the shape of config:

```typescript
type ContentTypes = 'news' | 'blog' | 'video';

// generic factory type with a inferred list of methods
// based on the shape of the given Config
type ContentFactory<Config extends Record<ContentTypes, boolean>> = {
    [k in string & keyof Config as Config[k] extends true
        ? `create${Capitalize<k>}`
        : never]: () => Content;
};

// config for indicating what content types are enabled
const config = { news: true, blog: true, video: false }
    satisfies Record<ContentTypes, boolean>;

type Factory = ContentFactory<typeof config>;
// Factory: {
//     createNews: () => Content;
//     createBlog: () => Content;
// }
```
