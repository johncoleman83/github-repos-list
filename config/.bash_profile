#  ---------------------------------------------------------------------------
#   PATH
#   -----------------------------------------------------------
#

# PATH RUBY
export PATH="$(brew --prefix qt@5.5)/bin:$PATH"
export PATH="$PATH:/usr/bin/gem"
export PATH="/usr/local/sbin:$PATH"
#export PATH="$PATH:/Users/jcoleman/jcolemanbin"
#moved new instals to /opt with symlink in /usr/local/bin

#   Add Color
#   -----------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced


#   Change Prompt
#   ------------------------------------------------------------
# get current branch in git repo

function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
	STAT=`parse_git_dirty`
	echo " [${BRANCH}${STAT}]"
    else
	echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
	bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
	bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
	bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
	bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
	bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
	bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
	echo " ${bits}"
    else
	echo ""
    fi
}

# Make some distinguishing lines for each new input command with timestamps
export PS1="\[\033[01;37m\]-._,.-'``'-.,\[\033[01;90m\]_,.-'``'-.,\
\[\033[01;38;5;95;38;5;196m\]_.:':.\[\033[01;38;5;95;38;5;214m\]_.:':.\
\[\033[01;38;5;95;38;5;229m\]_.:':.\
\[\033[01;38;5;95;38;5;048m\]_.:':.\[\033[01;38;5;95;38;5;032m\]_.:':._\
\[\033[01;38;5;95;38;5;135m\].:':._\[\033[01;38;5;95;38;5;089m\],.-'``'-.,_.-\
\[\033[01;00m\]\n| \t | \
\[\033[01;34m\]\w\
\[\033[01;38;5;95;38;5;208m\]\`parse_git_branch\`\
\[\033[01;32m\] (\u)\
\[\e[m\] \n$ "

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
export EDITOR=/usr/local/Cellar/emacs/25.3/bin/emacs-25.3

#   -----------------------------
#   2. ALIASES
#   -----------------------------

# alias emacs="/usr/local/Cellar/emacs/25.3/bin/emacs-25.3"
alias clearall="clear && printf '\e[3J'"    # clean up terminal and remove scroll history
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -lAFGhpct'                     # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias emacs='emacs --no-window-system'      # open emacs in terminal instead of GUI

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# New Functions instead of aliases

# Always list directory contents upon 'cd'
function git () {
    if [[ "$@" == "push origin master" ]]; then
        read -p "really really push to master ? " -n 1 -r YES_I_LIVE_ON_EDGE
        echo ""
        if [[ ! "$YES_I_LIVE_ON_EDGE" =~ ^[Yy]$ ]]; then
            echo "saved you this time..."
            [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
        else
            command git push origin master
        fi
    else
        command git "$@"
    fi
}

function cd () {
    builtin cd "$@";
    ll;
}

# trash: Moves a file to the MacOS trash
function trash () {
    command mv "$@" ~/.Trash;
}

# ql: Opens any file in MacOS Quicklook Preview
function ql () {
    qlmanage -p "$*" >& /dev/null;
}

# docker pretty print
function docker () {
    if [[ "$@" == "ps -a" ]]; then
        command docker ps --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}" \
            | (echo -e "CONTAINER_ID\tNAMES\tIMAGE\tPORTS\tSTATUS" && cat) \
            | awk '{printf "\033[1;32m%s\t\033[01;38;5;95;38;5;196m\%s\t\033[00m\033[1;34m%s\t\033[01;90m%s %s %s %s %s %s %s\033[00m\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10;}' \
            | column -s$'\t' -t
    else
        command docker "$@"
    fi
}


#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.            Example: mans mplayer codec
#   --------------------------------------------------------------------
mans () {
    man $1 | grep -iC2 --color=always $2 | less
}

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
findPid () { lsof -t -c "$@" ; }

#   ---------------------------
#   6. NETWORKING
#   ---------------------------

#    alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
#    alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
#    alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
#    alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
#    alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
#    alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
#    alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
#    alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
#    alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
#    alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs
#
#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
#    ii() {
#        echo -e "\nYou are logged on ${RED}$HOST"
#        echo -e "\nAdditionnal information:$NC " ; uname -a
#        echo -e "\n${RED}Users logged on:$NC " ; w -h
#        echo -e "\n${RED}Current date :$NC " ; date
#        echo -e "\n${RED}Machine stats :$NC " ; uptime
#        echo -e "\n${RED}Current network location :$NC " ; scselect
#        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
#        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
#        echo
#    }
#

#  Github bash completion
#  ----------------------------------------

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
ulimit -n 8096

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export SBT_CREDENTIALS=$HOME/.sbt/credentials
