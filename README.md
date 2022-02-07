# scmt-cli

Bash scripts to help automate downloading and uploading torrents from and to private torrent tracker(s).

## Requirements

* curl
* Account on a private torrent tracker

## Usage

* First, there needs to be a valid config.txt file present in the script directory. `config.txt.example` can be used as a template.
	* `SCMT_URL` is the complete base url or your selected tracker
	* `USER_ID` is your user ID on the tracker. It can be seen in the page URL when visiting a user profile or it can be retrieved from cookies if logged in
	* `PASS` can be retrieved from cookies

### get-torrent.sh

* `get-torrent.sh <torrent page url>` will download a .torrent file
	* Example: `./get-torrent.sh "https://torrenttracker.com/details.php?id=10101"`
	