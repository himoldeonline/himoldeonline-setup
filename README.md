## Helper Tools for himoldeonline project

### Get up and running
#### Run the below command 'click the upper right box to fetch command into clipboard' in your terminal to get started
* The script downloads this repository to ~/himoldeonline and runs the start.sh file
* When completed, this repo is then removed and a new copy with all other repos are cloned into ~/himoldeonline where we store all work related to himoldeonline
```bash
export _DIR=~/.himoldeonline && rm -rf $_DIR; mkdir -p $_DIR && \
  cd $_DIR && git clone https://github.com/himoldeonline/himoldeonline-setup.git && \
  cd $_DIR/himoldeonline-setup && ./start.sh && cd ~/ && rm -rf $_DIR && unset _DIR
```
#### What does start.sh do?
* validates your environment and generates an ssh-key for authentication against your github
* downloads all repositories in himoldeonline to a pre-defined directory ~/himoldeonline on your host
* updates and installs system packages for running and or compiling the tools we use


### After running the start.sh script:
#### Run the below command for a list of options
```bash
himolde
```
#### The command is used for:
* setting up docker images and containers using existing tools for Open edX and Craft CMS
* starting/stopping containers associated with our platform
* adding Nitro containers to the Tutor docker network
