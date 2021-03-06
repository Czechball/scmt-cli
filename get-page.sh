#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" || { echo -e "\e[91mERROR\e[0m: Script path cannot be found" ; exit; } >/dev/null 2>&1 ; pwd -P )"
CONFIGFILE="$SCRIPTPATH"/config.txt
source "$CONFIGFILE" || { echo -e "\e[91mERROR\e[0m: $CONFIGFILE doesn't exist in script path" ; exit; }
USER_AGENT="get-torrent.sh, part of scmt-cli by Czechball (https://github.com/Czechball/scmt-cli)"

if [[ ${SCMT_URL,USER_ID,PASS} == "" ]]; then
  echo "Error, please check your config.txt file"
  exit 1
fi

# https://stackoverflow.com/questions/6250698/how-to-decode-url-encoded-string-in-shell
function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

URL="$1"

if [[ "$URL" == "" ]]; then
  echo "Error: No URL specified."
  exit 1
fi

URL_FIX=$(echo "$URL" | sed s/"&hit=1"//)


PAGE_CONTENT=$(curl "$URL_FIX" -H 'User-Agent:'"$USER_AGENT" -H 'Cookie: uid='"$USER_ID"'; pass='"$PASS" --compressed)

URIS=$(grep -Po 'href="download.php?\K[^"]+' <<< "$PAGE_CONTENT" | sed s/"amp;"// | uniq)

for URI in $URIS;
do
	DECODED_URI=$(urldecode "$URI")
	DOWNLOAD_URL="$SCMT_URL""download.php""$DECODED_URI"

	curl "$DOWNLOAD_URL" \
	  -H 'User-Agent:'"$USER_AGENT" \
	  -H 'Cookie: uid='"$USER_ID"'; pass='"$PASS" \
	  --compressed -J -O --create-dirs --output-dir torrents/
done
