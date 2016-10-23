#!/bin/bash

# The {} will be expended to the current line and become the first argument of this script
FROM=$1
BASENAME=${FROM##*/}

BASE=${BASENAME%.*}
SUFFIX=${BASENAME##*.}

TOSUFFIX="$(echo $SUFFIX | tr '[a-z]' '[A-Z]')"
TO=$2/$BASE.$TOSUFFIX
COM="mv $FROM $TO"
echo $COM
eval $COM