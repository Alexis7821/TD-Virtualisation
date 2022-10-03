#BAHU & MOURLANETTE - TD Virtualisation

$env:PATH = $env:PATH + ";D:\LOGICIELS\VIRTUALBOX"
$choix = 0
[string]$nomclone ="string"
[string]$nomcreer = "string"
[int]$RAM = 0

do{
    Write-Host "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    Write-Host "TD Virtualisation - BAHU Florian & MOURLANETTE Alexis" 
    Write-Host " " 
    Write-Host "Menu"
    Write-Host " " 
    Write-Host "1. Créer Une VM"
    Write-Host "2. Cloner Une VM"
    $choix = Read-Host
    Write-Host " " 
}until($choix -eq 1 -or $choix -eq 2)

if($choix -eq "1"){
    $choix = 0
    Write-Host "*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    Write-Host "Création d'une nouvelle VM"
    Write-Host "*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    Write-Host " " 
    do{
        Write-Host "Choix du système d'exploitation. Voulez vous voir la liste des OS disponibles? O\n "
        $choix = Read-Host
        Write-Host " " 
    }until($choix -eq "o" -or $choix -eq "n")
    if(($choix -eq "O") -or ($choix -eq "0")){
        $choix = 0
        #Vboxmanage list ostypes
        Get-Content "D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\TD\OS.txt"
        $listos = Get-Content "D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\TD\OS.txt"
    }
    do{
        Write-Host "Quel OS voulez vous?"
        $OS = Read-Host
        Write-Host " " 
    }until($os -in $listos)
    Write-Host "Vous avez choisi" $OS
    Write-Host " " 
    Write-Host "Quel sera le nom de la machine?"
    $nomvm = Read-Host
    Write-Host " " 
    Write-Host "La machine" $nomvm "va être créée"
    Write-Host " " 
    VBoxManage createvm --name $nomvm --ostype $OS --register --basefolder "D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\TD"
    Write-Host " " 
    do{
        Write-Host "Combien de mémoire RAM voulez vous ? (en Mo)"
        $RAM = Read-Host
        Write-Host " " 
    }until($RAM -ge 512 -and $RAM -le 4096) 
    VBoxManage modifyvm $nomvm --memory $RAM
    VBoxManage modifyvm $nomvm --bridgeadapter1 vmnet1
    VBoxManage modifyvm $nomvm --nic1 bridged
    do{
        Write-Host "Quelle est la taille du disque ? (en Mb)"
        $tailledisk = Read-Host
        Write-Host " "
        Write-Host $tailledisk
    }until($tailledisk -ge 100 -and $tailledisk -le 10000)
    VBoxManage createmedium --filename D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\TD\$nomvm\$nomvm.vdi --size $tailledisk --format VDI                     
    VBoxManage storagectl $nomvm --name "SATA Controller" --add sata --controller IntelAhci       
    VBoxManage storageattach $nomvm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\TD\$nomvm\$nomvm.vdi
    Write-Host " " 
    do{
        Write-Host "Combien de coeurs de cpu voulez vous ?"
        $nbcpu = Read-Host
        Write-Host " " 
    }until($nbcpu -ge 1 -and $nbcpu -le 4)
    VboxManage modifyvm $nomvm --cpus $nbcpu
    Write-Host "Votre machine a bien été créée :D"
    Write-Host " " 
}
else{
    Write-Host "*-*-*-*-*-*-*-*-*"
    Write-Host "CLONAGE D'UNE VM"
    Write-Host "*-*-*-*-*-*-*-*-*"
    Write-Host "Voici les VMs disponibles"
    Write-Host " " 
    VBoxManage list vms
    $listvm = VBoxManage list vms
    $nbelem = $listvm.Count
    Write-Host " "
    if($nbelem -eq 0){
        Write-Host "Il n'y a pas de machines disponibles"
    }
    else{
        for($i = 0; $i -lt $nbelem; $i++){
            $nomvm = $listvm[$i].Split(" ")
            do{
                Write-Host "Entrer le nom de la machine a cloner : "
                $g = '"'
                $nomclone = Read-Host
                $nomclonefinal = $g + $nomclone + $g
            }until($nomclonefinal -eq $nomvm[0])
            break
        }
        Write-Host "Entrer le nom de la nouvelle machine a créer : " 
        $nomcreer = Read-Host
        VBoxManage export $nomclone --output D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\template\$nomcreer.ova
        VBoxManage import D:\DOCUMENTS\ESIEE\I5\VIRTUALISATION\VM\template\$nomcreer.ova --vsys 0 --vmname $nomcreer
        Write-Host " " 
    }
}