# URLS, BRANCH and TAGS for our repositories

GIT_URL_OPENEDX_PLATFORM='git@github.com:himoldeonline/edx-platform.git'
TAG_OPENEDX_PLATFORM='tags/open-release/lilac.1'
GIT_URL_OPENEDX_INSTRUCTIONS='git@github.com:himoldeonline/openedx-instructions.git'
GIT_URL_OPENEDX_DEV='git@github.com:himoldeonline/openedx-dev.git'
BRANCH_OPENEDX_DEV='setup'
GIT_URL_TIBETHEME='git@github.com:himoldeonline/openedx-tibetheme.git'
GIT_URL_TUTOR='https://github.com/overhangio/tutor'
PYTHON_VERSION="3.9.6"

DISTRO=$(cat /etc/*-release | grep -w "NAME" | cut -c 6-)

# ..set directory variables that depend on username that is read from input
SSH_KEY="$HOME/.ssh/id_rsa_himoldeonline"
GIT_CONFIG_FILE="$HOME/.gitconfig"
TUTOR_ROOT="$HOME/.local/share/tutor"
DEV_ROOT=~/himoldeonline

# ..directories for storing each repository
REPO_OPENEDX_PLATFORM="$DEV_ROOT/open_edx_source/edx-platform"
REPO_INSTRUCTION="$DEV_ROOT/open_edx_instruction_source/openedx-instructions"
REPO_OPENEDX_DEV="$DEV_ROOT/open_edx_dev_source/openedx-dev"
REPO_TIBETHEME="$DEV_ROOT/open_edx_themes_source/tibetheme"
REPO_TUTOR="$DEV_ROOT/tutor_source/tutor"

_LOG_FILE='setup.log'
