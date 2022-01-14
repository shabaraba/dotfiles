
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

1. install (you nead to exec only once.)
    ```sh
    make install
    ```

1. deploy (you should exec for each changing dotfiles)
    ```sh
    make deploy
    ```

# install

Executing [the above command](#usage), you can install as following:

- neovim
- dein
- zplug

# dockerfile

If you want to use this repository in docker,
I present you to [a sample Dockerfile](https://github.com/shabaraba/dotfiles/blob/main/Dockerfile).

You use my Dockefile or make a Dockefile Inheriting it.

## NOTICE

if you use not `.vimspector.json` in your project root
but configuration files in .vimspector-config/\* to debug,  
you have to set your project root to `/var/www/html/src`
and launch neovim in your project root
because we set path-mapping as belows in the configuration file.

```json
{"/var/www/html/src": "${cwd}"}
```

