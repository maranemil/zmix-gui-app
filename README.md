## zmix-gui-app

Shuffle sound randomizer using ffmpeg and rubberband-cli in tkinter GUI  

### Requirements

- Ubuntu 23.X flavours (Kubuntu, Lubuntu)


### Install

Clone Repo and run installer file

~~~sh
bash installer.sh
~~~

### How to start Zmix App

~~~sh
bash start_app.sh
# pygame 2.1.2 (SDL 2.26.3, Python 3.11.2)
~~~

### Folders explanation
~~~sh
# load - where the input file is saved
# split - where input files is segmented in ~1 sec wav N files
# rubberband - where rubberband are generated based on split files
# output- where random seq output is generate from previous folders
~~~

### How it works

- Import some mp3 file using File "Open".
- Click "Run Rubberband" and wait until job is done.
- Click "Preview Rubberband files" and start playing and listen the result.

#
#### App Screen GUI

[![Screen](screens/zmix.png)](#features)