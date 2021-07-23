param ($name)


write-host "Deleting distro $name"
Invoke-Expression 'wsl --unregister $name '

write-host "Deleting the folder $name"
Remove-Item -Path "./$name" 