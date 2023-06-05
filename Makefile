# https://www.tutorialspoint.com/makefile/makefile_example.htm
# https://opensource.com/article/18/8/what-how-makefile

# Define required macros here
SHELL = /bin/sh

composer-up:
	@echo "Create folders"
	mkdir -p chop output load rubberband split

create-python-env:
	python -m venv zmix-app-env

installation:
	sudo apt-get install python3-tk python3-pygame rubberband-cli ffmpeg -y

check-packages:
	python -m tkinter

start-zmix:
	python3 main.py

