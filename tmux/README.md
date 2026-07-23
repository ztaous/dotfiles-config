# tmux

tmux keeps terminal sessions running after the terminal is closed.

A session contains windows, and a window contains panes:

- **Session**: a tmux workspace
- **Window**: a terminal within the session
- **Pane**: a split within the window

The prefix is `Ctrl-b`. Press the prefix, release it, then press the binding.

## Sessions

Run these commands from the shell:

- `tmux`: start a session
- `tmux new -s name`: start a named session
- `tmux ls`: list sessions
- `tmux attach -t name`: attach to a session
- `tmux kill-session -t name`: stop a session

Press `Ctrl-b d` to detach without stopping the session.

## Windows

- `Ctrl-b c`: create a window
- `Ctrl-b n`: next window
- `Ctrl-b p`: previous window
- `Ctrl-b 1-9`: select a window
- `Ctrl-b ,`: rename a window
- `Ctrl-b &`: close a window

## Panes

- `Ctrl-b |`: split left and right
- `Ctrl-b -`: split top and bottom
- `Ctrl-b h/j/k/l`: move between panes
- `Ctrl-b H/J/K/L`: resize panes
- `Ctrl-b z`: zoom or restore a pane
- `Ctrl-b x`: close a pane

New panes open in the current pane's directory.

## Copy Mode

- `Ctrl-b [`: enter copy mode
- `v`: begin a selection
- `y`: copy the selection to tmux
- `Ctrl-b ]`: paste

## Configuration

- `Ctrl-b r`: reload `tmux.conf`
- Mouse support is enabled.
- Windows and panes start at index 1.
