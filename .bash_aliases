alias vi="vim"

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#alias ls="exa"
alias ll='ls -alF'

alias be="bundle exec"
alias bi="bundle install"

# Pretty-print JSON from STDIN
alias json="python -mjson.tool"

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if ! command -v seq >/dev/null; then
  # OS X didn't have "seq" (a la "for ii in `seq 1 10`; do ... done" for looping from 1 to 10.)
  # Shim it instead. (TODO: Add skip as optional middle parameter, eg `seq 1 2 10` for 1 3 5...)
  alias seq="ruby -e 'Range.new((ARGV[0].to_i), (ARGV[1].to_i)).each { |i| puts i }'"
fi

if [ $IS_MAC ]; then
	# Reset the sound when it sometimes goes to hell.
	alias osxresetsound="sudo killall coreaudiod"

	# Sometimes the Dock sticks around even when you're looking at a fullscreen'd app.
	alias osxresetdock="killall Dock"
fi

if [ $IS_LINUX ]; then
  # Debian has an inconvenient name for its ack.
  alias ack="ack-grep"
fi

# Networking.
if [ $IS_MAC ]; then
  alias netconns="lsof -i | grep -E '(LISTEN|ESTABLISHED)'"
else
  alias netconns="netstat -tapn"
fi

# Vim
vis() {
  DIR="${1:-.}"
  vim -S "${DIR}/Session.vim"
}

# Today's journal log (with yesterday's log in a split pane)
alias log='mkdir -p ~/logs && vim -O ~/logs/`date +%F`.txt ~/logs/`date -v-1d +%F`.txt'

### Elixir ###
alias ie="iex -S mix"
alias iep="iex -S mix phx.server"

### Docker ###
alias d-c="docker-compose"

### Searching ###
alias rgt="rg --type"

### Esoteric ###
alias trek="play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14" # Infinite starship engine noise. :D
alias weather="curl http://wttr.in/Sydney"
alias minprompt='export PS1="\w$(__git_ps1)\$ "'

alias pomo="thyme -r -b"
