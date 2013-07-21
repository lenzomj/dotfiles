function __git_dirty {
  git diff --quiet HEAD &> /dev/null
  [ $? == 1 ] && echo "!"
}
