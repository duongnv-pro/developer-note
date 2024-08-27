# Vistual Studio Code

![](https://i.imgur.com/waxVImv.png)

### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

#### Update Vistual Studio Code #update vs code
```bash
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O /tmp/code_latest_amd64.deb
sudo dpkg -i /tmp/code_latest_amd64.deb
```

#### How can you export the Visual Studio Code extension list? #export extension
###### 1. For Ubuntu
```bash
code --list-extensions | xargs -L 1 echo code --install-extension
```
_Tips: Run script to export to extensions.txt_
```bash
code --list-extensions | xargs -L 1 echo code --install-extension >> vscode-extensions.list
```
###### 2. For Windows
```bash
code --list-extensions | % { "code --install-extension $_" }
```
###### 3. Copy and paste the echo output to machine B
Sample output
```bash
code --install-extension Angular.ng-template
code --install-extension DSKWRK.vscode-generate-getter-setter
code --install-extension EditorConfig.EditorConfig
code --install-extension HookyQR.beautify
```

#### How can I export settings? #export settings
