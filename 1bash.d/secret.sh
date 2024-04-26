#!/bin/bash

# store secret env in this file, this file ignored in git
if [ -r ~/.secret.env ]; then
  source ~/.secret.env
fi