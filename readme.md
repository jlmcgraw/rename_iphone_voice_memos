A small perl utility to add the description of a voice memo to the file name after you've copied them from your ipad/iphone

# Installation

#### Linux
    - Run setup.sh to install Carton and update local libraries

#### Windows
	- Get and install Strawberry perl (http://strawberryperl.com/)
	- run setup.bat to install Carton and update local libraries

# Usage
	./rename_iphone_voice_memos.pl --source-directory <directory>
    	Copy existing voice memos in source_directory to a new file with the description added (if it exists in Recordings.db in that directory)
        
    ./rename_iphone_voice_memos.pl -h for help

# Copying files from an idevice using ifuse (*NIX only)

#### Install necessary software
	sudo apt install ifuse libimobiledevice-dev libimobiledevice-doc libimobiledevice-utils libimobiledevice6
    
#### Create a timestamped copy of an attached idevice 
    1. (Set the directories inside this script first)
    2.  ./backup_idevice_using_ifuse.sh
