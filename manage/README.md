## This directory holds all the functionality to the command "himolde"
<p>
The himolde command is a management tool created to make it easier for devs at himoldeonline<br>
to work with the web-platform without having to know the intricate details of managing containers etc.<br
</p>

<p>
If you installed the himoldeonline developement platform using the start.sh script in the root directory<br>
of this repository, the command "himolde" should be accessible<br>
The himolde command is stored as ~/.local/bin/himolde<br>
The command sources the script himolde in this directory
</p>

<p>
If you do not have the himolde command, paste the whole command block below into your shell to create it<br>
</p>
* For the below command block to work, you need to be authenticated to Github with an SSH-key

```bash
mkdir -p ~/.local/bin
cat <<EOF > ~/.local/bin/himolde
#!/usr/bin/env bash
if [[ ! -f ~/himoldeonline/himoldeonline_setup_source/himoldeonline-setup/manage/himolde ]]; then
  mkdir -p ~/himoldeonline/himoldeonline_setup_source
  cd ~/himoldeonline/himoldeonline_setup_source
  git clone git@github.com:himoldeonline/himoldeonline-setup.git
fi
source ~/himoldeonline/himoldeonline_setup_source/himoldeonline-setup/manage/himolde
EOF
chmod +x ~/.local/bin/himolde
```
