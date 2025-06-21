
# .dotfiles

Personal dotfiles configuration for development environment setup.

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
- zinit

## NOTICE

if you use not `.vimspector.json` in your project root
but configuration files in .vimspector-config/\* to debug,  
you have to set your project root to `/var/www/html/src`
and launch neovim in your project root
because we set path-mapping as belows in the configuration file.

```json
{"/var/www/html/src": "${cwd}"}
```

## Security Notice

⚠️ **Important**: Before using these dotfiles, please configure your private settings:

1. Copy example files and update with your credentials:
   ```sh
   cp sh/zsh/private/env.zsh.example sh/zsh/private/env.zsh
   cp sh/zsh/private/alias.zsh.example sh/zsh/private/alias.zsh
   ```

2. Update placeholders in private files with your actual values:
   - `YOUR_GITHUB_TOKEN`: Your GitHub personal access token
   - `YOUR_CLAUDE_API_TOKEN`: Your Claude API key
   - `YOUR_COMPANY_DOMAIN`: Your company's domain
   - `YOUR_USERNAME`: Your username
   - Other placeholder values as needed

3. **Never commit private files** - they are already in `.gitignore`

4. **Review all configurations** before using in your environment

