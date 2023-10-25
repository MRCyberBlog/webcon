# webcon
webcon - Automation script that does...
1. Finds subdomains of the provided second.top domain provided.
2. Weeds out dead subdomains and creates active(pingable) list.
3. Visits active subdomain list and takes screenshots.

Idea is to save time when doing external pentests.
E.g., You're starting your external and you want to find webpages with interactive elements in the page. Like a login panel.
The script will create lists of dead and live subdomains, along with screenshots of live subdomains you can sift through vs visting each site manually.


### Tools used in script
(Shout out to the scripts below)
Subfinder(https://github.com/projectdiscovery/subfinder)
assetfinder(https://github.com/tomnomnom/assetfinder)
amass(https://github.com/owasp-amass/amass)
httprobe (https://github.com/tomnomnom/httprobe)
gowitness (https://github.com/sensepost/gowitness)


### Install go & config PATH for go
(command below is for zshrc shell. change over to bashrc if using bash as your source. To check what shell you're using run `echo $SHELL`)

`sudo apt update && sudo install golang -y && echo 'export GOROOT=/usr/lib/go\nexport GOPATH=$HOME/go\nexport PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.zshrc && source ~/.zshrc`

### Install go binaries needed through go
`go install github.com/tomnomnom/httprobe@master`
`go install github.com/sensepost/gowitness@latest`

### Install subfinder, assetfinder, amass(optional) through apt
`sudo apt update && sudo apt install subfinder assetfinder amass -y`

Enjoy!