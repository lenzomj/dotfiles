#!/usr/bin/env bash

if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${HOME}/.bashrc" ]; then
    # shellcheck source=bash/common.bashrc
    source "${HOME}/.bashrc"
  fi
fi
