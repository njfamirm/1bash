#!/bin/bash

# Create a new directory and enter it
function md {
	mkdir -p "$@" && cd "$@"
}


# find shorthand
function f {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# List all files, long format, colorized, permissions in octal
function la {
 	lsa -l  "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# git commit browser. needs fzf
function glog {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

# get gzipped size
function gz {
	echo "orig size    (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# whois a domain or a URL
function whois {
	local domain=$(echo "$1" | awk -F/ '{print $3}') # get domain from URL
	if [ -z $domain ] ; then
		domain=$1
	fi
	echo "Getting whois record for: $domain …"

	# avoid recursion
					# this is the best whois server
													# strip extra fluff
	/usr/bin/whois -h whois.internic.net $domain | sed '/NOTICE:/q'
}

function localIpDevice {
	function _localip { echo "📶  "$(ipconfig getifaddr "$1"); }
	export -f _localip
	local purple="\x1B\[35m" reset="\x1B\[m"
	networksetup -listallhardwareports | \
		sed -r "s/Hardware Port: (.*)/${purple}\1${reset}/g" | \
		sed -r "s/Device: (en.*)$/_localip \1/e" | \
		sed -r "s/Ethernet Address:/📘 /g" | \
		sed -r "s/(VLAN Configurations)|==*//g"
}

# preview csv files. source: http://stackoverflow.com/questions/1875305/command-line-csv-viewer
function csvpreview {
  sed 's/,,/, ,/g;s/,,/, ,/g' "$@" | column -s, -t | less -#2 -N -S
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# who is using the laptop's iSight camera?
function camerausedby {
	echo "Checking to see who is using the iSight camera… 📷"
	usedby=$(lsof | grep -w "AppleCamera\|USBVDC\|iSight" | awk '{printf $2"\n"}' | xargs ps)
	echo -e "Recent camera uses:\n$usedby"
}


# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
function gifify {
  if [[ -n "$1" ]]; then
	if [[ $2 == '--good' ]]; then
	  ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
	  time convert -verbose +dither -layers Optimize -resize 900x900\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
	  rm out-static*.png
	else
	  ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
	fi
  else
	echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

# turn that video into webm.
# brew reinstall ffmpeg --with-libvpx
function webmify {
	ffmpeg -i $1 -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y $2 $1.webm
}

# direct it all to /dev/null
function nullify {
  "$@" >/dev/null 2>&1
}

function dns-fast {
cat << EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF
}

# ffmpeg

function ffm {
  ffmpeg "${@:1:$#-1}" -map_metadata 0 -movflags +faststart -benchmark "${!#}"
}

function convert2m4a {
  input="$1"; shift;

  echo "Convert (-c:a aac -b:a 64k -ar 22050)"
  ffm -i "$input" -vn -c:a aac -b:a 64k -ar 22050 "$@" "${input}-low-quality.m4a"

  echo "Convert (-c:a aac -b:a 128k -ar 44100)"
  ffm -i "$input" -vn -c:a aac -b:a 128k -ar 44100 "$@" "${input}-medium-quality.m4a"

  echo "Convert (-c:a aac -b:a 192k -ar 48000)"
  ffm -i "$input" -vn -c:a aac -b:a 192k -ar 48000 "$@" "${input}-high-quality.m4a"
}

function convert2mp4 {
	input="$1"; shift;
  ffm -i "$input" -c:v libx264 -c:a aac -q:a 0.5 $@ "${input}.mp4"
}

function random() {
	openssl rand -hex 32
}

#!/bin/bash

# Function to send a notification using the Terminal Notifier
function ncWatch() {
  local local_ip=$(localIp)
	echo "nc watch on ${local_ip}:"
	nc -l 2080 | while read message; do
		echo "$message" | pbcopy
		echo "$message"
		echo "Copied!"
	done
}

function echoNc() {
	local ip="$1"
	local message="$2"
	echo "$message" | nc "$ip" 2080
	echo "Sent!"
}

# clean remote removed git branch include not pushed branch
function cb() {
  for branch in $(git branch --no-color --merged | grep -Ev "\*|next"); do
    read -p "Are you sure you want to delete $branch? (y/N) " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      git branch -d "$branch"
    fi
  done
}

function localIp() {
  ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
}

function publicIp() {
   curl -s ipinfo.io/json
}

function fix-permissions {
	find "${1:-.}" -type d -exec chmod -vv 755 {} \;
	find "${1:-.}" -type f -exec chmod -vv 644 {} \;
}
