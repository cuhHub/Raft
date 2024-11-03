# // ---------------------------------------------------------------------
# // ------- [cuhHub] Sync Tool
# // ---------------------------------------------------------------------

"""
A tool for syncing all files in a directory from one place to the other.
Repo: https://github.com/cuhHub/cuhHub

Copyright (C) 2024 Cuh4

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

# ---- // Imports
import click
import os

# ---- // Classes
class Synchronizer():
    """
    A class used to synchronize all files in a directory into another.
    """

    def __init__(self, directory: str, destination: str, ignore: list[str] = []):
        """
        A class used to synchronize all files in a directory into another.

        Args:
            directory (str): The directory containing files to synchronize.
            destination (str): The destination that all of the synced files will be cloned to.
            ignore (list[str]): The files/directories to ignore when synchronizing.
            
        Raises:
            ValueError: If the directory does not exist.
        """
        
        if not os.path.exists(directory):
            raise ValueError("Directory does not exist.")
        
        self.directory = directory
        self.destination = destination
        self.ignore = ignore
        self.ignore.extend(destination)
        
    def synchronize(self):
        """
        Synchronizes all files in a directory from one place to the other.
        """
        
        if os.path.isfile(self.directory):
            self._copy_file(self.directory)
            return
        
        for root, dirs, files in os.walk(self.directory):
            for dir in dirs:
                path = os.path.join(root, dir)
                
                if path in self.ignore:
                    continue
                
                self._copy_file(path)
            
            for file in files:
                path = os.path.join(root, file)
                
                if path in self.ignore:
                    continue
                
                self._copy_file(path)
                
    def _copy_file(self, path: str):
        """
        Copies a file from one place to the other.

        Args:
            path (str): The path of the file to copy.
        """
        
        relative = os.path.relpath(path, self.directory)
        target = os.path.join(self.destination, relative) if os.path.isdir(self.directory) else self.destination + os.path.basename(path)

        if os.path.isdir(path):
            os.makedirs(target, exist_ok = True)
        else:
            os.makedirs(os.path.basename(target), exist_ok = True)
            
            with open(path, "rb") as f:
                content = f.read()
                
            with open(target, "wb") as f:
                f.write(content)

# ---- // Main
@click.command()
@click.option("--directory", "-d", "-p", "--path", type = str, required = True, help = "The directory containing files/directories to synchronize.")
@click.option("--destination", "-de", type = str, required = True, help = "The destination that all of the synced files/directories will be cloned to.")
@click.option("--ignore", "-ip", type = list, default = [], multiple = True, help = "The files/directories to ignore when synchronizing.")
def sync_tool(directory: str, destination: str, ignore: list[str]):
    """
    Clones all files and directories in a directory to a destination directory.

    Args:
        directory (str): The directory containing files/directories to synchronize.
        destination (str): The destination that all of the synced files/directories will be cloned to.
        ignore (list[str]): The files/directories to ignore when synchronizing.
    """    
    
    ignore = list(ignore) # `ignore` is a tuple for some reason
    ignore.extend([__file__])

    Synchronizer(
        directory = directory,
        destination = destination,
        ignore = ignore
    ).synchronize()

    click.secho(f"[Done] Sucessfully synced `{directory}` to `{destination}`.", fg = "green", underline = True, bold = True)
    
if __name__ == "__main__":
    sync_tool()