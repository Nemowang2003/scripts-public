# Config Remote Host

## configure.zsh

### Usage

    configure [--use-pip-mirror] <login_name> <hostname> <host_to_add> <user_to_add> [port]

It's estimated that `ssh login_name@hostname -p port` can login.  
And would append the following to .ssh/config.
```
Host host_to_add
  HostName hostname
  Port a-random-port
  User user_to_add
```

Configure remote host by uploading a script and execute to get my custom configurations.  
Consists a lot of my personal preferences.  
I was encountering a bunch of remote hosts to configure these days, so I wrote it.  
Although I'm pretty sure it wastes much more time than it saves :(
