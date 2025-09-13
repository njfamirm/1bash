#!/bin/bash

# If $BASH not defined, don't do anything
if [ -z "$BASH" ]; then
  return
fi

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

if [ -z "$ONE_BASH" ]; then
  export ONE_BASH='~/1bash'
fi

for i in $ONE_BASH/1bash.d/base.d/*.sh; do
  if [ -r $i ]; then
    . $i
  fi
done
unset i

for i in $ONE_BASH/1bash.d/*.sh; do
  if [ -r $i ]; then
    . $i
  fi
done
unset i

export PATH="$ONE_BASH/commands:$PATH"
