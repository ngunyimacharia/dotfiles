# Brew setup {{
# ====================================================

# eval "$(/opt/homebrew/bin/brew shellenv)"

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

# }}}

# Bash functions {{{

# Switch AWS profiles

aws_profile()
{
  export AWS_PROFILE=$1
  aws configure list
}
