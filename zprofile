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
