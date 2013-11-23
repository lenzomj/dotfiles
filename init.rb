#!/usr/bin/env ruby

ROOT_DIR = File.dirname(__FILE__)

Dir.chdir ROOT_DIR do
  print "Updating submodules ... "
  `git submodule init 2>&1` && $?.exitstatus == 0 or
    fail  "ERROR: git submodule init\n"
  `git submodule update 2>&1` && $?.exitstatus == 0 or
    fail "ERROR: git submodule update\n"
  puts "Done."
end
