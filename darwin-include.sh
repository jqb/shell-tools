# Change background color
# Usage:
#
# $ set-background-color "{15000,0,0}"
#
function set-background-color() {
  osascript -e "tell application \"iTerm\"
    set current_terminal to (current terminal)
    tell current_terminal
      set current_session to (current session)
      tell current_session
        set background color to $1
      end tell
    end tell
  end tell"
}


export EDITOR="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias xselb="pbcopy"
