# Brew setup {{
# ====================================================

eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(direnv hook zsh)"

# }}}

# Aliases {{{
# ====================================================

alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# Path configurations {{{
# ====================================================

export PATH="$HOME/.composer/vendor/bin:$PATH"

export PATH="$HOME/Library/Python/3.10/bin:$PATH"

export PATH="$HOME/.cargo/env:$PATH"

export PATH="/usr/local/opt/libpq/bin:$PATH"

export PATH="$(pyenv root)/shims:${PATH}"

# }}}

# Bash functions {{{

# Switch AWS profiles

aws_profile()
{
  export AWS_PROFILE=$1
  aws configure list
}

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Puppeteer configuration {{{
# ====================================================

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# }}}
