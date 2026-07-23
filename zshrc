# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git 
  #z 
  node 
  npm 
  vscode 
  sudo 
  gh 
  dotenv 
  docker 
  docker-compose 
  react-native 
  zsh-syntax-highlighting 
  zsh-autosuggestions 
)
  
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


eval "$(starship init zsh)"

# General Aliases
alias size="tree -L 1 -h"
alias zsh-edit="xed ~/.zshrc"
alias zsh-update="source ~/.zshrc"

#kubernetes
alias k="kubectl"

# ntl
alias r="ntl -A -s 7"
export NTL_RUNNER=na # user ni agent

# oh mysh fzf plugin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# github cli
autoload -U compinit
compinit -i

# place this after nvm initialization!
autoload -U add-zsh-hook

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm



# pnpm
export PNPM_HOME="/home/hoisel/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end#compdef gitlab-ci-local
###-begin-gitlab-ci-local-completions-###
#
# yargs command completion script
#
# Installation: gitlab-ci-local completion >> ~/.zshrc
#    or gitlab-ci-local completion >> ~/.zprofile on OSX.
#
_gitlab-ci-local_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gitlab-ci-local --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gitlab-ci-local_yargs_completions gitlab-ci-local
###-end-gitlab-ci-local-completions-###

function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

PATH=~/.console-ninja/.bin:$PATH
# bun completions
[ -s "/home/hoisel/.bun/_bun" ] && source "/home/hoisel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias cursor='/home/hoisel/Applications/cursor.AppImage'

#zodixe (rupa z replacement)
eval "$(zoxide init zsh)"

# Change project, Change node version let .nvmrc help you
# ref: https://thawinwats.medium.com/change-project-change-node-version-let-nvmrc-help-you-630b34dafd09
load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"



export PATH="$(npm config get prefix)/bin:$PATH"
# 🛠️ Hoisel Scripts CLI
export PATH="$HOME/.local/bin:$HOME/scripts/bin:$PATH"
export EDITOR=/usr/bin/xed

# Load secrets (tokens, API keys) from a separate file not tracked by git
[ -f ~/.hoisel-secrets ] && source ~/.hoisel-secrets

alias vk='HOST=127.0.0.1 PORT=45879 npx vibe-kanban'
alias vk-kill='kill $(lsof -ti:45879)'

alias claude-full='claude --dangerously-skip-permissions'

alias scripts="cd ~/scripts && git st"

add_export() { local line="export $1"; grep -q "$line" ~/.zshrc || echo "$line" >> ~/.zshrc; source ~/.zshrc; echo "✅ $line adicionado ao ~/.zshrc"; }

############################ Postgres Envs, SSH ############################
export PATH="/usr/lib/postgresql/16/bin:$PATH"
alias pg_14='/usr/lib/postgresql/14/bin/psql'
alias pg_16='/usr/lib/postgresql/16/bin/psql'
alias pg_dump_14='/usr/lib/postgresql/14/bin/pg_dump'
alias pg_dump_16='/usr/lib/postgresql/16/bin/pg_dump'

ssh-tunnel-namecoach-prod() {
  ssh -i ~/.ssh/id_namecoach \
  -L 5435:prodevents.cwnulposwkkl.us-east-2.rds.amazonaws.com:5432 \
  daniel@3.20.193.239
}

psql-namecoach-eventsdb-prod() {
  PGPASSWORD="$NAMECOACH_PROD_DB_PASSWORD" psql \
  -h localhost \
  -p 5435 \
  -U events_admin \
  -d events_api
}

ddl-namecoach-eventsdb-prod() {
  ts=$(date +"%Y%m%d-%H%M%S")

  PGPASSWORD="$NAMECOACH_PROD_DB_PASSWORD" pg_dump_16 \
  -h localhost \
  -p 5435 \
  -U events_admin \
  -d events_api \
  --schema-only \
  --no-owner \
  --no-privileges \
  > "ddl-eventsdb-prod-${ts}.sql"
}

############################ WebApps ############################
ice-clean-cache() {
  BASE="$HOME/.local/share/ice/profiles"

  echo "Cleaning ICE cache..."

  find "$BASE" -type d -name "Cache" -exec rm -rf {} + 2>/dev/null
  find "$BASE" -type d -name "Code Cache" -exec rm -rf {} + 2>/dev/null
  find "$BASE" -type d -name "GPUCache" -exec rm -rf {} + 2>/dev/null
  find "$BASE" -type d -name "CacheStorage" -exec rm -rf {} + 2>/dev/null

  echo "Done."
}

ice-size() {
  BASE="$HOME/.local/share/ice/profiles"

  echo "ICE profiles disk usage:"
  du -h --max-depth=1 "$BASE" 2>/dev/null | sort -h

  echo
  echo "Total:"
  du -sh "$BASE"
}

# Forces Ulauncher to rebuild its app index (fixes stale name/icon after
# editing a .desktop file - restarting Cinnamon alone does NOT fix this,
# Ulauncher keeps its own separate cache)
ulauncher-refresh() {
  echo "Stopping Ulauncher..."
  systemctl --user stop ulauncher.service 2>/dev/null
  pkill -9 -f "ulauncher --hide-window" 2>/dev/null
  sleep 1

  echo "Clearing app cache..."
  rm -f ~/.cache/ulauncher_cache/app_cache.db ~/.cache/ulauncher_cache/desktop_dirs.db

  echo "Starting Ulauncher..."
  systemctl --user reset-failed ulauncher.service 2>/dev/null
  systemctl --user start ulauncher.service

  sleep 2
  systemctl --user is-active --quiet ulauncher.service && echo "Done, Ulauncher is running." || echo "Something went wrong, check: systemctl --user status ulauncher.service"
}



############################ Utils ############################
what() {
  for cmd in "$@"; do
    echo "----- $cmd -----"
    type "$cmd"
    command -v "$cmd"
    echo
  done
}

aliases() {
  echo "=== ALIASES ==="
  alias
  echo

  echo "=== CUSTOM FUNCTIONS (.zshrc) ==="
  grep -E '^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_-]*[[:space:]]*\(\)[[:space:]]*\{' ~/.zshrc \
    | sed -E 's/^[[:space:]]*([a-zA-Z_][a-zA-Z0-9_-]*)[[:space:]]*\(\)[[:space:]]*\{/\1/' \
    | sort
}


############################ Dev ############################
open-worktree() {
  local dir
  dir=$(git worktree list | fzf | awk '{print $1}') || return
  windsurf "$dir"
}


sync-envs() {
  local env_root="$1"
  local repo_root
  local src rel dest dest_dir
  local copied_count=0
  local error_count=0

  if [[ -z "$env_root" ]]; then
    echo "Uso: sync-envs <env-root>"
    return 1
  fi

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erro: execute esta função dentro de uma worktree/repositório Git."
    return 1
  }

  if [[ ! -d "$env_root" ]]; then
    echo "Erro: diretório de envs não encontrado: $env_root"
    return 1
  fi

  while IFS= read -r -d '' src; do
    rel="${src#$env_root/}"
    dest="$repo_root/$rel"
    dest_dir="$(dirname "$dest")"

    if [[ ! -f "$src" ]]; then
      echo "Arquivo de origem não encontrado: $src"
      ((error_count++))
      continue
    fi

    mkdir -p "$dest_dir" || {
      echo "Erro ao criar diretório: $dest_dir"
      ((error_count++))
      continue
    }

    cp -f "$src" "$dest" || {
      echo "Erro ao copiar: $rel"
      ((error_count++))
      continue
    }

    echo "copied: $rel"
    ((copied_count++))
  done < <(find "$env_root" -type f \( -name '.env' -o -name '.env.*' \) -print0)

  echo
  echo "Concluído: $copied_count arquivo(s) copiado(s), $error_count erro(s)."
}

open-windsurf-here() {
  local repo_root

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erro: não foi possível localizar a raiz do repositório."
    return 1
  }

  windsurf "$repo_root"
}

sync-envs-and-open-windsurf() {
  sync-envs "$1" || return 1
  open-windsurf-here
}

alias sync-envs-vcs='sync-envs-and-open-windsurf ~/Dev/Professional/NameCoach/.envs/phonetic_vcs'
alias sync-envs-fe='sync-envs-and-open-windsurf ~/Dev/Professional/NameCoach/.envs/namecoach-fe'


# Added by Antigravity CLI installer
export PATH="/home/hoisel/.local/bin:$PATH"
