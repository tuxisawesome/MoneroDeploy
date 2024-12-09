#!/bin/bash
echo "Monero Deployer 1.0"
if test -f ~/xmrig/build/xmrig; then
  echo "File exists."
  xmrun
  exit
fi
sudo apt update
sudo apt full-upgrade -y
sudo apt install dialog build-essential cmake libuv1-dev libssl-dev libhwloc-dev tmux -y

OUTPUT="/tmp/input.txt"

# create empty file
>$OUTPUT

# Purpose - say hello to user 
#  $1 -> name (set default to 'anonymous person')
function sayhello(){
	local n=${@-"ubuntu-device"}
	#display it
    cd
	git clone https://github.com/xmrig/xmrig
    cd xmrig
    mkdir build
    cd build
    cmake ..
    make
    rm $OUTPUT
    xmrun
    exit
}

function xmrun(){
	cd ~/xmrig/build
    sudo ./xmrig -o gulf.moneroocean.stream:10128 -u 8AjNPgo48p1UnU3NTCGYAuKKeptXHxyPf1zMrubenDSff72W6B7wbXt6SpGoCgz8ujE9ffvBtpGBG5WEmt8M2yUWUW1CW5y -p ${n} --randomx-1gb-pages --cpu-priority=5 --asm=intel --donate-level=0 
}
# cleanup  - add a trap that will remove $OUTPUT
# if any of the signals - SIGHUP SIGINT SIGTERM it received.
trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM

# show an inputbox
dialog --title "Configuration" \
--backtitle "Monero Deployer 1.0" \
--inputbox "Enter your instance name" 8 60 2>$OUTPUT

# get respose
respose=$?

# get data stored in $OUPUT using input redirection
name=$(<$OUTPUT)

# make a decsion 
case $respose in
  0) 
  	sayhello ${name} 
  	;;
  1) 
  	echo "Cancel pressed." 
  	;;
  255) 
   echo "[ESC] key pressed."
esac

# remove $OUTPUT file
