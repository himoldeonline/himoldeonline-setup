## NOTE: This repository is not ready yet
* Do not run any scripts unless you know what you are doing!
## Scripts and Tools for getting started with developing for himoldeonline

### How to use
#### Run the below command in your terminal
* The script downloads this repository to your homefolder and runs the start.sh file
```bash
export _DIR=~/.himoldeonline && rm -rf $_DIR; mkdir -p $_DIR && \
  cd $_DIR && git clone https://github.com/himoldeonline/himoldeonline-setup.git && \
  cd $_DIR/himoldeonline-setup && ./start.sh && cd ~/ && rm -rf $_DIR && unset _DIR
```

#### What does start.sh do?
* validates environment and generates ssh-key for authentication against your github
* downloads all repositories in himoldeonline to a pre-defined directory on your host
* updates and installs system packages for running and or compiling the tools we use to manage the platform
* setting up docker images and containers using existing tools for Open edX and Craft CMS
