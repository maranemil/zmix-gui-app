## zmix-gui-app
Shuffle sound randomizer using ffmpeg and rubberband-cli in tkinter GUI  


### Install

#### Requirements

~~~sh
sudo apt-get install python3-venv -y
sudo apt-get install python3-tk -y
sudo apt-get install python3-pygame -y
sudo apt-get install rubberband-cli -y
sudo apt-get install ffmpeg -y
~~~

~~~sh
# To install Python packages system-wide, try apt install python3-xyz, where xyz is the package you are trying to install.

sudo apt install python3-pip -y
sudo apt install python3-tk -y
sudo apt install python3-pygame -y
~~~


#### How to start Zmix App

Create folders for app:
~~~sh
mkdir -p chop output load rubberband split

# Folders explanation:

# load - where the input file is saved
# split - where input files is segmented in ~1 sec wav N files
# rubberband - where rubberband are generated based on split files
# output- where random seq output is generate from previous folders
~~~

Start App
~~~sh
python3 main.py
# pygame 2.1.2 (SDL 2.26.3, Python 3.11.2)
~~~

#### How it works

- Import some mp3 file using File "Open".
- Click "Run Rubberband" and wait until job is done.
- Click "Preview Rubberband files" and start playing and listen the result.

#
#### App Screen GUI

[![Screen](screens/zmix.png)](#features)