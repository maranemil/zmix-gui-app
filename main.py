# See PyCharm help at https://www.jetbrains.com/help/pycharm/

# sudo apt-get install python3-tk -y
# sudo apt-get install python3-pygame -y


import os
import shutil
import tkinter as tk
import subprocess
import pygame
from tkinter import filedialog
from tkinter import messagebox
import time
from tkinter.ttk import *
from functions import *

# Initialize pygame
pygame.init()

#######################################
# Create a tk window
#######################################

window = tk.Tk()
window.title('Zmix App')
# window.geometry("900x600+50+50")  # Width x Height
window.geometry("1400x900+50+50")  # Width x Height
window.resizable(True, True)

#######################################
# Create menu bar to import mp3 file
#######################################

menu_bar = tk.Menu(window)
file_menu = tk.Menu(menu_bar, tearoff=0)
# file_menu.add_command(label="New", command=file_new)
file_menu.add_command(label="Open", command=file_open)
# file_menu.add_command(label="Save", command=file_save)
file_menu.add_separator()
file_menu.add_command(label="Exit", command=window.quit)
menu_bar.add_cascade(label="File", menu=file_menu)
window.config(menu=menu_bar)

#######################################
# Create a label for displaying output
#######################################

output_label = tk.Label(window)
output_label.pack()

#######################################
# frame1 - Create buttons for play and stop
#######################################

frame1 = tk.Frame(master=window, width=50, bg="white")
frame1.pack(fill=tk.BOTH, side=tk.LEFT, expand=False)

frame3 = tk.Frame(master=window, width=700, bg="lightgrey")
frame3.pack(fill=tk.BOTH, side=tk.LEFT, expand=True)

play_button = tk.Button(master=frame1, text="Play Input", command=play_audio, width=20,
                        height=2,
                        bg="green",
                        fg="yellow", )
play_button.pack(anchor="w")  # side="left",

stop_button = tk.Button(master=frame1, text="Stop Input", command=stop_audio, width=20,
                        height=2,
                        bg="red",
                        fg="yellow", )
stop_button.pack(anchor="w")  # side="left",

# label = tk.Label(frame1, text=" 1\n 2\n 3")
# label.pack()

#######################################
# split shuffle rubberband
#######################################

button = tk.Button(master=frame1, text="Run Split",
                   command=lambda frame3a=frame3: execute_command_split(frame3a),
                   justify=tk.LEFT,
                   width=20,
                   height=2,
                   bg="honeydew",
                   fg="black", )
button.pack(anchor="w")  # side="left",

button = tk.Button(master=frame1, text="Run RubberBand",
                   command=lambda frame3a=frame3: execute_command_rubberband(frame3a),
                   width=20,
                   height=2,
                   bg="honeydew",
                   fg="black",
                   )
button.pack(anchor="w")

# button = tk.Button(master=frame1, text="Run Shuffle",
#                    command=execute_command_shuffle,
#                    width=20,
#                    height=2,
#                    bg="honeydew",
#                    fg="black", )
# button.pack(anchor="w")

button = tk.Button(master=frame1, text="Clean Temp Files",
                   command=clean_tmp_files(output_label),
                   width=20,
                   height=2,
                   bg="black",
                   fg="yellow", )
button.pack(anchor="w")



button = tk.Button(master=frame1, text="Preview Split files",
                   command=lambda frame3a=frame3: generate_split_previw(frame3a),
                   width=20,
                   height=2,
                   bg="darkorange",
                   fg="yellow", )
button.pack(anchor="w")

button = tk.Button(master=frame1, text="Preview Rubberband files",
                   command=lambda frame3a=frame3: generate_rubberband_previw(frame3a),
                   width=20,
                   height=2,
                   bg="darkorange",
                   fg="yellow", )
button.pack(anchor="w")

button = tk.Button(master=frame1, text="Preview Output files",
                   command=lambda frame3a=frame3: generate_output_previw(frame3a),
                   width=20,
                   height=2,
                   bg="magenta",
                   fg="yellow", )
button.pack(anchor="w")

#######################################
# Create a button for loading file
#######################################

# load_button = tk.Button(window, text="Load mp3 File", command=load_file)
# load_button.pack(anchor="w")

# Create a label
#label =  tk.Label(frame3, text = "Fact of the Day", bg="lightgrey", anchor="nw")
#label.pack()

# Create a button
# button = tk.Button(window, text="Click Me", command=button_click)
# button.pack()


# Start the GUI event loop
window.mainloop()
