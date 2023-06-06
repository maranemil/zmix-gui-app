import tkinter as tk
import pygame
from os import listdir
from os.path import isfile, join
import subprocess
import os
import shutil
import subprocess
import pygame
from tkinter import filedialog
from tkinter import messagebox
import time
from tkinter.ttk import *


def get_split_files() -> list:
    mypath = 'split'
    filenames = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    # alternative way
    # from os import walk
    # filenames = next(walk(mypath), (None, None, []))[2]  # [] if no file
    return filenames


def get_rubberband_files() -> list:
    mypath = 'rubberband'
    filenames = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    return filenames


def get_output_files() -> list:
    mypath = 'output'
    filenames = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    return filenames


def divide_chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]


def clear_frame(frame3):
    for widgets in frame3.winfo_children():
        widgets.destroy()
        pass


def generate_output_previw(frame3):
    print('generate_output_previw.....')
    clear_frame(frame3)

    files = get_output_files()
    if len(files) == 0:
        show_error_dialog("Please generate files first")
    else:
        n = 6
        files_chunks = list(divide_chunks(files, n))
        grid_rows = len(files_chunks)

        for row in range(grid_rows):
            for col in range(len(files_chunks[row])):
                frame = tk.Frame(
                    master=frame3,
                    relief=tk.RAISED,
                    borderwidth=1
                )
                frame.grid(row=row, column=col, padx=5, pady=5)
                file_output = str(f"{files_chunks[row][col]}")
                button = tk.Button(master=frame, text=file_output,
                                   activebackground='magenta',
                                   command=lambda file_output3=file_output: play_audio_output(file_output3))
                button.grid(row=row, column=col, sticky="nsew")


def generate_rubberband_previw(frame3):
    print('generate_rubberband_previw.....')
    clear_frame(frame3)

    files = get_rubberband_files()
    if len(files) == 0:
        show_error_dialog("Please generate files first")
    else:
        n = 8
        files_chunks = list(divide_chunks(files, n))
        grid_rows = len(files_chunks)

        for row in range(grid_rows):
            for col in range(len(files_chunks[row])):
                frame = tk.Frame(
                    master=frame3,
                    relief=tk.RAISED,
                    borderwidth=1
                )
                frame.grid(row=row, column=col, padx=5, pady=5)
                file_rubberband = str(f"{files_chunks[row][col]}")
                button = tk.Button(master=frame, text=file_rubberband,
                                   activebackground='darkorange',
                                   command=lambda file_rubberband3=file_rubberband: play_audio_rubberband(
                                       file_rubberband3))
                button.grid(row=row, column=col, sticky="nsew")


def generate_split_previw(frame3):
    # time.sleep(2.4)
    print('generate_split_previw.....')
    clear_frame(frame3)

    files = get_split_files()
    if len(files) == 0:
        show_error_dialog("Please generate files first")
    else:
        n = 8
        files_chunks = list(divide_chunks(files, n))
        grid_rows = len(files_chunks)

        for row in range(grid_rows):
            for col in range(len(files_chunks[row])):
                frame = tk.Frame(
                    master=frame3,
                    relief=tk.RAISED,
                    borderwidth=1
                )
                frame.grid(row=row, column=col, padx=5, pady=5)
                # label = tk.Label(master=frame, text=f"Row {i}\nColumn {j}")
                # label = tk.Label(master=frame, text=f" {files_chunks[i][j]} ")
                # label.pack(padx=5, pady=5)
                file_split = str(f"{files_chunks[row][col]}")
                button = tk.Button(master=frame, text=file_split, activebackground='darkorange',
                                   command=lambda file_split3=file_split: play_audio_split(file_split3))
                button.grid(row=row, column=col, sticky="nsew")


#######################################
# Dialog Warning Error
#######################################

def show_info_dialog(message):
    messagebox.showinfo("Dialog", message)


def show_warning_dialog(message):
    messagebox.showwarning("Warning", message)


def show_error_dialog(message):
    messagebox.showerror("Error", message)


def show_confirm_dialog(message):
    result = messagebox.askyesno("Confirmation", message)
    if result:
        print("User clicked Yes")
    else:
        print("User clicked No")


#######################################
# top menu function file
#######################################

def file_open():
    file_path = filedialog.askopenfilename(filetypes=[("MP3 Files", "*.mp3")])
    if file_path:
        print(file_path)
        save_file(file_path)


def load_file():
    file_path = filedialog.askopenfilename(filetypes=[("MP3 Files", "*.mp3")])
    if file_path:
        # Process the loaded file here
        print(file_path)
        save_file(file_path)


def save_file(file_path):
    # save_path = filedialog.asksaveasfilename(defaultextension=".mp3")
    save_path = './load/in.mp3'
    if save_path:
        # Save the file to the specified path
        shutil.copy(file_path, save_path)
        # print("MP3 file saved to:", save_path)
        show_info_dialog("MP3 file saved to:" + file_path)


#######################################
# player functions
#######################################
def play_audio():
    pygame.mixer.music.load("./load/in.mp3")
    pygame.mixer.music.play()


def stop_audio():
    pygame.mixer.music.stop()


def play_audio_splits(file):
    pass
    # print(file)


def play_audio_rubberband(file):
    print(file)
    pygame.mixer.music.load("./rubberband/" + file)
    pygame.mixer.music.play()


def play_audio_output(file):
    print(file)
    pygame.mixer.music.load("./output/" + file)
    pygame.mixer.music.play()


def play_audio_split(file):
    print(file)
    pygame.mixer.music.load("./split/" + file)
    pygame.mixer.music.play()

    """
    from pygame import mixer
    mixer.init()
    mixer.music.load(f"split/{file}")
    print("music started playing....")
    mixer.music.set_volume(0.7)
    mixer.music.play()
    """


#######################################
# clean old random files
#######################################
def clean_tmp_files(output_label):
    command = 'rm -f split/*'
    output = subprocess.check_output(command, shell=True).decode()
    output_label.config(text=output)
    command = 'rm -f output/*'
    output = subprocess.check_output(command, shell=True).decode()
    output_label.config(text=output)
    command = 'rm -f rubberband/*'
    output = subprocess.check_output(command, shell=True).decode()
    output_label.config(text=output)


#######################################
# bash cmd for split rubberband shuffle
#######################################
def execute_command_split():
    # clean_tmp_files(output_label)
    # subprocess.call(["bash", "-c", "ls -lha"])
    # command = "ls -la"
    command = 'bash zmix_split.sh -i ./load/in.mp3 -d yes -t 1 || echo "failed"'
    # command = "zmix_pitch.sh -i load/in.mp3 -d yes -t 1"
    output = subprocess.check_output(command, shell=True).decode()
    # output_label.config(text=output)
    show_info_dialog("Split files created succesfully")


def execute_command_rubberband():
    # clean_tmp_files()
    command = 'bash zmix_rubberband.sh -i load/in.mp3 -d yes -t 1 || echo "failed"'
    output = subprocess.check_output(command, shell=True).decode()
    # output_label.config(text=output)
    show_info_dialog("Rubberband files created succesfully")


def execute_command_shuffle():
    # clean_tmp_files(output_label)
    command = 'bash zmix_shuffle.sh -i load/in.mp3 -d yes -t * || echo "failed"'
    output = subprocess.check_output(command, shell=True).decode()
    # output_label.config(text=output)
    show_info_dialog("Shuffle files created succesfully")


def button_click():
    label.config(text="Button Clicked!")

# def load_file():
#     file_path = filedialog.askopenfilename()
#     if file_path:
#         # Process the file here
#         print("File selected:", file_path)

# def load_file():
#     file_path = filedialog.askopenfilename()
#     if file_path:
#         # Process the loaded file here
#         save_file(file_path)
#
#
# def save_file(file_path):
#     save_path = filedialog.asksaveasfilename(defaultextension=".txt")
#     if save_path:
#         # Save the file to the specified path
#         with open(save_path, "w") as output_file:
#             #with open(file_path, "rb") as input_file:
#             with open(file_path, encoding="utf8", errors='ignore') as input_file:
#                 output_file.write(input_file.read())
#         print("File saved to:", save_path)
