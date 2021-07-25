#!/usr/bin/env bash

source ./setup/lib/display.sh
source ./setup/lib/validate.sh
source ./setup/lib/system.sh
source ./setup/lib/paths.sh
source ./setup/lib/repositories.sh
source ./setup/lib/log.sh

_has_profiles && echo $SHELL_TYPE || echo "No shell"