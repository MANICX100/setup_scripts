#!/bin/bash
size=`wmctrl -d | head -n 1 | grep -Eho '[0-9]{4}x[0-9]{3,4}' | tail -1`
width=`echo $size | cut -d'x' -f 1`
half=$(( $width/2 ))

wmctrl -r :ACTIVE: -b remove,maximized_horz,shaded &

if [[ $1 == 'left' ]]
  then
    wmctrl -r :ACTIVE: -b add,maximized_vert -e 0,0,24,$half,-1 &
  else
    wmctrl -r :ACTIVE: -b add,maximized_vert -e 0,$half,24,$half,-1 &
fi

exit 0
