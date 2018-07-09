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

#### Examples

~~~ 
$ ./rename_iphone_voice_memos.pl --source-directory 2018-07-06/ --dry-run 

28 memos in 2018-07-06/Recordings.db
Dry run: 2018-07-06/20171002 150325.m4a -> "2018-07-06/20171002 150325 - After School.m4a
Dry run: 2018-07-06/20171008 201309.m4a -> "2018-07-06/20171008 201309 - Bedtime.m4a
Dry run: 2018-07-06/20171225 070601.m4a -> "2018-07-06/20171225 070601 - Christmas 2017.m4a
Dry run: 2018-07-06/20180513 093355.m4a -> "2018-07-06/20180513 093355 - Mothers Day.m4a
Dry run: 2018-07-06/20180523 204551.m4a -> "2018-07-06/20180523 204551 - Bedtime Chatter.m4a
~~~

