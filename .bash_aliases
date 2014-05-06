alias vi="vim"

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if [ $IS_LINUX ]; then
  alias ls="ls --color"
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias be="bundle exec"
alias bi="bundle install"

# Pretty-print JSON from STDIN
alias json="python -mjson.tool"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# OS X doesn't have "seq" (a la "for ii in `seq 1 10`; do ... done" for looping from 1 to 10.)
# Shim it instead. (TODO: Add skip as optional middle parameter, eg `seq 1 2 10` for 1 3 5...)
if [ $IS_MAC ]; then
	alias seq="ruby -e 'Range.new((ARGV[0].to_i), (ARGV[1].to_i)).each { |i| puts i }'"
fi

if [ $IS_LINUX ]; then
  # Debian has an inconvenient name for its ack.
  alias ack="ack-grep"
fi

# Today's journal log (with yesterday's log in a split pane)
alias log='mkdir -p ~/logs && vim -O ~/logs/`date +%F`.txt ~/logs/`date -v-1d +%F`.txt'
