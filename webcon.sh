#!/bin/bash

##  Installation
# install go (command below is for zshrc shell. change over to bashrc if using bash as your source)
# >> sudo apt update && sudo install golang -y && echo 'export GOROOT=/usr/lib/go\nexport GOPATH=$HOME/go\nexport PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.zshrc && source ~/.zshrc

#2/ Install go binaries needed
# >> go install github.com/tomnomnom/httprobe@master
# >> go install github.com/sensepost/gowitness@latest

#3/ install subfinder,assetfinder,amass(optional),httprobe(master),gowitness
# >> sudo apt update && sudo apt install subfinder assetfinder amass -y

# TOOL OVERVIEW
# 
# *Active* External Web Domain Automation:
### *ACTIVE* = THIS SCRIPT USES TOOLS THAT ACTIVELY REACH OUT TO THE TARGET, MEANING ITS ACTIVE & NOT PASSIVE! USE AT YOUR OWN RISK.
#
#
#  1-Displays whois info
#  1-Tool(s)-Using built-in whois tool
#
##  2-Find subdomains
##   2-Tool(s)-Subfinder & assetfinder & amass(optional).
##    2-Subfinder uses passive means(Google, etc) to probe and find possible active subdomains. (https://github.com/projectdiscovery/subfinder)
##    2-assetfinder uses passive mean(some could need API keys) to find possible active subdomains. (https://github.com/tomnomnom/assetfinder)
##    2-amass, with enum options and -d flag, does subdomain enumeration. It's SLOW, so commented out by default. (https://github.com/owasp-amass/amass)
#
##   3-Parse results and ping,from host running this script(ACTIVE SCAN), found subdomains to find "live" subdomains and remove "dead" hosts.
##    3-Tool(s)-Sort "live" hosts and ping HTTPS hosts over HTTP using httprobe. Create "live" host list. (https://github.com/tomnomnom/httprobe)
#
####  4-Screenshot created of alive subdomains
####   4-Tool(s)-gowitness uses chrome headless to visit and screenshot landing page results(https://github.com/sensepost/gowitness)
#
# DONE

## PS ##
# Amass scanner disabled by default as it can take some time to finish. Enable with the understanding that you may be waiting a while.

## PSS ##
# If screenshots are created before a webpage loads(empty or blank), increase "--delay" value by a few(measures in seconds)


# # # VARIABLES BELOW

# # # Domain name is going to be stored in postitional variable $1
domain=$1

# # # Color to make things pretty
RED="\033[1;31m"
RESET="\033[0m"



# FOLDER CREATIONS

# info folder variable
info_path=$domain/info

# subdomains folder variable
subdomains_path=$domain/subdomains

# screenshots folder variable
screenshots_path=$domain/screenshots

# Creating above folders if they do not exist

if [ ! -d "$domain" ];then
		mkdir $domain
fi

if [ ! -d "$info_path" ];then
		mkdir $info_path
fi

if [ ! -d "$subdomains_path" ];then
		mkdir $subdomains_path
fi

if [ ! -d "$screenshots_path" ];then
		mkdir $screenshots_path
fi

# # # # # # START TOOL EXECUTION

echo -e "${RED} [+] Running whois...${RESET}"
whois $1 > $info_path/whois.txt

echo -e "${RED} [+] Launching subfinder...${RESET}"
subfinder -d $domain > $subdomains_path/found.txt

echo -e "${RED} [+] Launching assetfinder...${RESET}"
assetfinder $domain | grep $domain >> $subdomains_path/found.txt

#### Commented out to increase tool speed. Honestly, I've had little improvement using amass over subfinder for subdomain discovery
#### That said, it's always best to run more than one tool for each step as some tools may find what others may not.
#echo -e "${RED} [+] Slowly waiting for Amass to finish...${RESET}"
#amass enum -d $domain >> $subdomain_path/found.txt

echo -e "${RED} [+] Probing for live domains...${RESET}"
cat $subdomains_path/found.txt | grep $domain | sort -u | httprobe --prefer-https | grep https | tee -a $subdomains_path/alive.txt

echo -e "${RED} [+] Taking screenshots of alive domains...${RESET}"
gowitness file -f $subdomains_path/alive.txt -P $screenshots_path/ --no-http --delay 10


