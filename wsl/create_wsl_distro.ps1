param ($name, $imagepath='./ubuntu-20.04-server-cloudimg-amd64-wsl.rootfs.tar.gz',$installpath='.', $user='nescau')

$installpath = "$installpath/$name"
$path = "export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/mnt/c/Program Files (x86)/Razer/ChromaBroadcast/bin:/mnt/c/Program Files/Razer/ChromaBroadcast/bin:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Windows/system32/config/systemprofile/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/Git/cmd:/mnt/c/ProgramData/chocolatey/bin:/mnt/c/FFmpeg/bin:/mnt/c/sox-14-4-2:/mnt/c/Program Files/CMake/bin:/mnt/c/tools/Manim/Scripts:/mnt/c/pango:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/PuTTY/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/Users/pape/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/JetBrains/PyCharm 2020.2.3/bin:/mnt/c/Users/pape/AppData/Local/Programs/MiKTeX/miktex/bin/x64/:/mnt/c/Users/pape/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/pape/AppData/Roaming/npm:/snap/bin'"
$sucmd = "'su $user'"

write-host $installpath

if (Test-Path -Path $installpath) {
    "Path exists! Run the script with another installpath and/or name."
    exit
} else {
    write-host "Creating a new folder: $installpath"
    New-Item -Path "d:\WSL\" -Name $installpath -ItemType "directory"
}


write-host "Creating a new distro"
Invoke-Expression 'wsl --import $name $installpath $imagepath --version 2'


write-host "Setting default distro"
Invoke-Expression 'wsl -s $name'

Copy-Item "./files/passwd" -Destination "\\wsl$\$name\etc" 
Copy-Item "./files/group" -Destination "\\wsl$\$name\etc" 
Copy-Item "./files/shadow" -Destination "\\wsl$\$name\etc" 
Copy-Item "./files/gshadow" -Destination "\\wsl$\$name\etc" 

write-host "Creating the home directory to $user"
Invoke-Expression 'wsl sudo mkhomedir_helper nescau'

write-host "append .bashrc"
Copy-Item "./.bashrc" -Destination "\\wsl$\$name\root" 

Copy-Item "../setup.sh" -Destination "\\wsl$\$name\home\$user" 

write-host "Adding $user to the sudo group"
Invoke-Expression 'wsl sudo usermod -aG sudo $user'


write-host "Appending the correct path to the users .bashrc file"
Invoke-Expression 'wsl echo "$path" >> \\wsl$\$name\home\$user\.bashrc'



#write-host "Starting the distro"
#Invoke-Expression 'wsl -d $name'


#Invoke-Expression 'wsl sh \\wsl$\$name\home\$user\setup.sh '