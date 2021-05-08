# .dotfiles
dotfiles for me.

# required
if you use WSL2, you should install following:
- genie (for systemd)

# usage
1. download this repository  
```sh
git clone https://github.com/shabaraba/dotfiles.git
cd dotfiles 
make install
```
2. install (you nead to exec only once.)
```sh
make install
```
3. deploy (you should exec for each changing dotfiles)
```sh
make deploy
```

# install
Executing [the above command](#usage), you can install as following:
- neovim
- dein
- zplug

# dockerfile
If you want to use this repository in docker, I present you to [a sample Dockerfile](https://github.com/shabaraba/dotfiles/blob/main/Dockerfile).  
You use my Dockefile or make a Dockefile Inheriting it. 
