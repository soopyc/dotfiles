lolcat=/home/sophie/.rvm/gems/ruby-3.1.2/bin/lolcat
fortune -c computers disclaimer ascii-art linux debian protolol bashorg -e | $lolcat

# +-----------------------------------------------------+
# | This breaks more things than being actually useful. |
# +-----------------------------------------------------+
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.cargo/bin/:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

# add zsh completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Path to your oh-my-zsh installation.
export ZSH="/home/sophie/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

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
plugins=(git node npm command-not-found zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

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
CORES=4

export CC=clang
export CXX=clang++
export MAKEOPTS="-j$CORES"
export MAKEFLAGS="$MAKEOPTS"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias down="curl -LO"
alias m="make"
alias m1="make -j1"
alias mc="make check"
alias mt="make test"
alias mi="make install"
alias cpu="./configure --prefix=/usr"
alias makepkg="GNUPGHOME=\$MAKEPKG_GPGHOME makepkg"
alias makepkg-gpg="GNUPGHOME=\$MAKEPKG_GPGHOME gpg"
alias yay="GNUPGHOME=\$MAKEPKG_GPGHOME yay"
alias scard='gpg-connect-agent "scd serialno" "learn --force" /bye'
alias ip='ip --color'
alias pmbootstrap="pmbootstrap --mirror-pmOS=https://keine.soopy.moe/pmos/postmarketos/"

#build_and_upload() {
#  makepkg && \
#  gpg --detach-sign *.tar.zst && \
#  scp ./*.tar.zst* cirno.soopy.moe:~/.pkg-in
#}

package() {
  BUILDCMD=${BUILDCMD:-extra-x86_64-build}
  echo "[1;32mUsing build command: $BUILDCMD[0m"
  echo "[1;32mBuilding package(s)[0m"

  $BUILDCMD $@
  if [ $? -ne 0 ]; then
    echo "[1;31mBuild failed, not uploading[0m"
    return 1
  fi

  echo "[1;32mBuild successful[0m"
  sau
}

package_debug () {
  BUILDCMD="testing-x86_64-build" package
}

sau() {
  echo "[1;32mSigning packages[0m"

  for i in *.tar.zst; do
    echo "  signing [33m$i[0m"
    gpg --batch --yes --detach-sign $i
  done

  echo "[1;32mUploading packages[0m"
  scp ./*.tar.zst{,.sig} cirno.soopy.moe:~/.pkg-in
}

set_color() {
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m"};' "$@"
}

colorpicker() {
  HEX=$(grim -g "`slurp -p -b 00000000`" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | rg -o "[0-9A-F]{6}")
  set_color $HEX
  printf "#$HEX\n";
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#export TERMINAL=alacritty  # i3
export EDITOR=nvim

export GIT_ASKPASS=ksshaskpass
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export MAKEPKG_GPGHOME="$HOME/.local/share/makepkg-gpg"
gpgconf --launch gpg-agent

# fuck off
export ANSIBLE_NOCOWS=1

source /usr/share/doc/pkgfile/command-not-found.zsh
source ~/dotfiles/private/woodpecker.zsh

export PATH="$PATH:./node_modules/.bin:$HOME/.local/bin/"

mkdir -pm700 $MAKEPKG_GPGHOME

source /usr/share/nvm/init-nvm.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export XDG_DATA_DIRS=$HOME/.nix-profile/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS

eval "$(direnv hook zsh)"
