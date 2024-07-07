# Update-ssh

## update-ssh.py

### Usage:

    python3 update-ssh.py

No arguments are needed.  
The script will output `xxx.xxx.0.1` and `xxx.xxx.xxx.xxx`, seperated with space.  
It indicates address of the router (perhaps) to the device and the adress of the device itself. Device is hardcoded in the script.  
The information is fetched from `p2.nju.edu.cn/api` via `curl`. (I don't know why `requests` cannot make it.)  

## connect.zsh

### Usage:

    connect

If connection established, an `ssh` command would be performed.  
Based on experience, we can do a long-last `ping` to router, and try to do several `ping`s to dest, until response recieved.  
This is what `connect` do.
