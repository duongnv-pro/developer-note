# Tmux Cheat Sheet & Quick Reference

![](https://i.imgur.com/waxVImv.png)

[MUST READ] [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- #tmux
### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

## 1. Sessions
```bash
tmux
tmux new
tmux new-session
```

Start a new session with the name mysession, #new
```bash
tmux new -s mysession
```
kill/delete session mysession, #kill
```bash
tmux kill-ses -t mysession
tmux kill-session -t mysession
```
kill/delete all sessions but the current
```bash
tmux kill-session -a
```
kill/delete all sessions but mysession
```bash
tmux kill-session -a -t mysession
```

Rename session #rename
```bash
Ctrl + b $
```
Detach from session #detach
```bash
Ctrl + b d
```
Show all sessions #list
```bash
tmux ls
tmux list-sessions
```
Attach to last session, #attach
```bash
tmux a
tmux at
tmux attach
tmux attach-session
```
Attach to a session with the name mysession, #attach
```bash
tmux a -t mysession
```

### 2. Windows
start a new session with the name mysession and window mywindow
```bash
tmux new -s mysession -n mywindow
```
Create window
```bash
Ctrl + b c
```
Rename current window
```bash
Ctrl + b ,
```
Close current window
```bash
Ctrl + b &
```
List windows
```bash
Ctrl + b w
```
Previous window, Next window, Switch/select window by numbe
```bash
Ctrl + b p
Ctrl + b n
Ctrl + b 0...9
```
Toggle last active window
```bash
Ctrl + b l
```
### 3. Panes
Toggle last active pane
```bash
Ctrl + b ;
```
Split pane with
```bash
# horizontal layout
Ctrl + b %

# vertical layout
Ctrl + b "
```
Move the current pane
```bash
# left
Ctrl + b {

#right
Ctrl + b }
```
Switch to pane to the direction, #switch pane
```bash
Ctrl + b up
Ctrl + b down
Ctrl + b left
Ctrl + b right
```
Toggle between pane layouts, #switch pane
```bash
# between
Ctrl + b Spacebar

# next
Ctrl + b o
```
Show pane numbers
```bash
Ctrl + b q
```
Switch/select pane by number, #switch pane
```bash
Ctrl + b q 0...9
```
Toggle pane zoom #zoom
```bash
Ctrl + b z
```
Convert pane into a window
```bash
Ctrl + b !
```
Resize current pane height(holding second key is optional), #resize pane
```bash
Ctrl + b + up
Ctrl + b Ctrl + up

Ctrl + b + down
Ctrl + b Ctrl + down

Ctrl + b + right
Ctrl + b Ctrl + right

Ctrl + b + left
Ctrl + b Ctrl + left
```
Close current pane, #close pane
```bash
Ctrl + b x
```
### 4. Copy Mode
Enter copy mode
```bash
Ctrl + b [
```
Quit mode
```bash
q
```
Go to top line
```bash
# top
g

# bottom
G
```
Search, #search
```bash
# forward
/

#backward
?
```
### 5. Help
List key bindings(shortcuts)
```bash
Ctrl + b ?
```
