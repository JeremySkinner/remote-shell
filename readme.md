# Remote profile utilities

Helpful utilities for working with remote servers over ssh where multiple users share the same username. 

# Getting started

Install with by running the following command in your terminal on the remote server:

```
source <(curl -s https://raw.githubusercontent.com/JeremySkinner/remote-shell/master/install.sh)
```

The installer will install to ~/.remote-profile

The installer will prompt you for your unique name and create a bashrc file for you. For example, if you enter the name "jeremy" when prompted, the installer will create the file ~/.bashrc_jeremy 

By default, this will load the following files:
- ~/.remote-profile/bashrc_common.sh
- ~/.remote-profile/bashrc_[name].sh (eg bashrc_jeremy.sh)

The "Common" bashrc (`~/.remote-profile/bashrc_common.sh`) is shared by all users and loads in the git prompt scripts.

The file `~/.remote-profile/bashrc_[name].sh` is your own bashrc that is common to all machines. This should be checked into this repository. When you edit it, you should check it back in and push it to the repo.

The file `~/.bashrc_[name]` is your own bashrc that is unique to this login/server.

