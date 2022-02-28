import os

# get root working directory
path = os.getcwd()
root = os.path.abspath(os.path.join(path, os.pardir))

"""
Set variables for the project
Sets paths to specific locations, input, output, queries
"""

# Set database connection variables
db = {
    "type": "mssql",
    "database": "hrods",
    "user": "AUTH\\garciand",
    "passwordd": "KalBri,04",
}

# Set paths to input, load, output, queries
path = {
    "input": root + "\\03_data\\01_raw\\",
    "load": root + "\\03_data\\02_processed\\",
    "output": root + "\\03_data\\03_cleaned\\",
    "queries": root + "\\03_data\\04_queries\\",
}

# set cmd colors
CMD_Colors = {
    "HEADER": "\033[95m",
    "OKBLUE": "\033[94m",
    "OKCYAN": "\033[96m",
    "OKGREEN": "\033[92m",
    "WARNING": "\033[93m",
    "FAIL": "\033[91m",
    "ENDC": "\033[0m",
    "BOLD": "\033[1m",
    "UNDERLINE": "\033[4m",
}

# set formatting options
file_format = {
    "font_name": "HP Simplified Light",
    "header_font_size": 13,
    "header_font_color": 0xFFFFFF,
    "header_bg_color": (0, 150, 214),
    "content_font_size": 12,
    
}

