#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings lib test example

pub run test -p vm,firefox,chrome