#!/usr/bin/env sh

minid export | jq '.app_state["checkers-torram"]'
