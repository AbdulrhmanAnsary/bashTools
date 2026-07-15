#!/data/data/com.termux/files/usr/bin/zsh
# === Usage ===
# ./tmuxman.sh [name]        -> create/attach to a session with given prefix
# ./tmuxman.sh list          -> list all active tmux sessions
# ./tmuxman.sh -l            -> list all active tmux sessions (shortcut)
# ./tmuxman.sh kill [name]   -> kill session(s) starting with prefix
# ./tmuxman.sh -k [name]     -> kill session(s) starting with prefix (shortcut)
# ./tmuxman.sh kill all      -> kill all active tmux sessions

CMD="$1"
PREFIX="$2"

# Function to kill sessions
kill_sessions() {
  # If "all" is passed, kill all sessions
  if [[ "$PREFIX" == "all" ]]; then
    sessions=("${(@f)$(tmux list-sessions -F "#{session_name}" 2>/dev/null)}")
    if [[ ${#sessions[@]} -eq 0 ]]; then
      echo "No active sessions to kill."
      exit 1
    fi
    echo "Killing all sessions..."
    for s in "${sessions[@]}"; do
      tmux kill-session -t "$s"
      echo "Killed session: $s"
    done
    exit 0
  fi

  # Otherwise, kill sessions with prefix
  sessions=("${(@f)$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep "^$PREFIX")}")
  if [[ ${#sessions[@]} -eq 0 ]]; then
    echo "No sessions found with prefix: $PREFIX"
    exit 1
  fi

  echo "Sessions matching '$PREFIX':"
  for s in "${sessions[@]}"; do
    echo " - $s"
  done

  echo
  echo "Do you want to:"
  echo "1) Kill all"
  echo "2) Choose manually"
  echo "3) Cancel"
  read "choice?Enter choice [1/2/3]: "

  case "$choice" in
    1)
      for s in "${sessions[@]}"; do
        tmux kill-session -t "$s"
        echo "Killed session: $s"
      done
      ;;
    2)
      for s in "${sessions[@]}"; do
        read "confirm?Kill session '$s'? [y/N]: "
        if [[ "$confirm" == [yY] ]]; then
          tmux kill-session -t "$s"
          echo "Killed session: $s"
        else
          echo "Skipped: $s"
        fi
      done
      ;;
    *)
      echo "Aborted."
      exit 0
      ;;
  esac
}

# List sessions (with shortcut -l)
if [[ "$CMD" == "list" || "$CMD" == "-l" ]]; then
  echo "Active tmux sessions:"
  tmux list-sessions 2>/dev/null || echo "No sessions found."
  exit 0
fi

# Kill sessions (with shortcut -k)
if [[ "$CMD" == "kill" || "$CMD" == "-k" && -n "$PREFIX" ]]; then
  kill_sessions
  exit 0
fi

# Start or attach to a session
SESSION_PREFIX="${CMD:-dev}"
INDEX=0

while tmux has-session -t "${SESSION_PREFIX}_${INDEX}" 2>/dev/null; do
  INDEX=$((INDEX + 1))
done

SESSION_NAME="${SESSION_PREFIX}_${INDEX}"

tmux new-session -d -s "$SESSION_NAME"
tmux set-hook -t "$SESSION_NAME" after-new-window  "run-shell 'tmux rename-window \"#S_#I\"'"
tmux set-hook -t "$SESSION_NAME" window-linked     "run-shell 'tmux rename-window \"#S_#I\"'"
tmux set-hook -t "$SESSION_NAME" window-renamed    "run-shell 'tmux rename-window \"#S_#I\"'"
tmux rename-window -t "$SESSION_NAME:0" "${SESSION_NAME}_0"
tmux attach -t "$SESSION_NAME"
