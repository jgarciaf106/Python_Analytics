# Python Folder Structure Boilerplate

How to organize your Python data science or reporting project.

## Directory Structure

Here is the Structure overview: everything gets its own place, and all things related to the project should be placed under child directories one directory.

    $ pwd
    /path/to/project/directory/

    $ ls
    |- 01_notebooks/
       |- 01-first-logical-notebook.ipynb
       |- 02-second-logical-notebook.ipynb
       |- prototype-notebook.ipynb
       |- 01_template/
          |- template.ipynb
       |- 02_archive/
    	  |- no-longer-useful.ipynb
    |- 02_projectname/
       |- 01_projectname/
    	  |- __init__.py
    	  |- config.py
    	  |- data.py
    	  |- utils.py
       |- setup.py
    |- README.md
    |- 03_data/
       |- 01_raw/
       |- 02_processed/
       |- 03_cleaned/
    |- 04_scripts/
       |- script1.py
       |- script2.py
       |- 01_archive/
          |- no-longer-useful.py
    |- environment.yml
