# Typescript

![](https://i.imgur.com/waxVImv.png)

[MUST READ] Watch free courses: [Easy Frontend](https://www.youtube.com/watch?v=_yfpSc6ubLE&list=PLeS7aZkL6GOtUGTQ81kfm3iGlRTycKjrZ)
- Typescript lang docs
- Typescript Deep Dive
- React Typescript Cheatsheet

### [View all DevNotes](../../README.md)

![](https://i.imgur.com/waxVImv.png)

### 1. Install
First way:
```
yarn global add typescript ts-node ts-lib @types/node
yarn add --dev typescript ts-node ts-lib @types/node

npm i -g typescript ts-node ts-lib @types/node
```
Second way:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# Add new lines to the ~/.zshrc file
source ~/.nvm/nvm.sh

# wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# source ~/.bashrc

nvm --version

nvm install 14.17
nvm use 14.17

npm install -g typescript
npm install -g ts-node
```
Install unit test:
```bash
yarn add --dev jest typescript ts-jest @types/jest
yarn ts-jest config:init
```
