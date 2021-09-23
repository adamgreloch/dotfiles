#!/bin/sh

#        -lf/nf/cf color
#            Defines the foreground color for low, normal and critical notifications respectively.
# 
#        -lb/nb/cb color
#            Defines the background color for low, normal and critical notifications respectively.
# 
#        -lfr/nfr/cfr color
#            Defines the frame color for low, normal and critical notifications respectively.

[ -f "$HOME/.cache/wal/colors.sh" ] && . "$HOME/.cache/wal/colors.sh"

pidof dunst && killall dunst

dunst -lf  "${color7:-#ffffff}" \
      -lb  "${background:-#eeeeee}" \
      -lfr "${color8:-#dddddd}" \
      -nf  "${color7:-#cccccc}" \
      -nb  "${background:-#bbbbbb}" \
      -nfr "${color8:-#aaaaaa}" \
      -cf  "${color3:-#999999}" \
      -cb  "${background:-#888888}" \
      -cfr "${color3:-#777777}" > /dev/null 2>&1 &
