for i in $ONE_BASH/1bash.d/proxy/*.sh; do
  if [ -r $i ]; then
    . $i
  fi
done
