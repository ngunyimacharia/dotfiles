# Brew setup {{
# ====================================================

eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(direnv hook zsh)"

# }}}

# Aliases {{{
# ====================================================

alias art="valet php artisan"


# Path configurations {{{
# ====================================================

export PATH="$HOME/.composer/vendor/bin:$PATH"

# }}}

# Bash functions {{{

# Switch AWS profiles

aws_profile()
{
  export AWS_PROFILE=$1
  aws configure list
}
