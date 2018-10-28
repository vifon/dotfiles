#!/bin/sh

exec cat ~/.ssh/config.d/* > ~/.ssh/config
