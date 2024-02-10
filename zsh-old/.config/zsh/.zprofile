# .zprofile - Can be used to execute commands just after logging in.

# set keyboard repeat rate
# default values are:
# auto repeat delay:  660    repeat rate:  25
if [[ -n "$DISPLAY" ]] ; then
  xset r rate 300 100
fi