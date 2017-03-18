# tmux-notify

Simple tmux notification system written in `sh`.  Based on an idea by tcreech: http://www.github.com/tcreech/tmux-notifications
Released under the BSD licence.

Example uses: e-Mail notifications, ad-hoc "job finished" notifications, etc.

## Usage

Send notification to active window:
``` tmux-notify "program_name" "notification_text" ```

Show number of pending notifications:
``` tmux-notify count ```

Clear notifications:
``` tmux-notify clear ```

Show all notifications:
``` tmux-notify show ```

Show all notifications and _don't_ clear them:
``` tmux-notify show-nc ```
