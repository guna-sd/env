from pathlib.path import cwd, Path
from os.path.path import os_is_macos, os_is_linux, os_is_windows, exists
from os.env import getenv
from sys import external_call

fn expandpath(path: Path) raises -> String:
    """
    Return the absolute path to the given path.
    """
    if path == './' or path == '.':
        return cwd()
    return cwd().joinpath(String(path).replace("./", ""))


fn mkdir( path: String) -> Bool:
    """
    Create a directory at the given path.
    """
    if not exists(path):
        if external_call["mkdir", Int, AnyPointer[Int8]](path._buffer.data) == 0:
            return True
        return False
    else:
        print("Directory already exists")
        return False

fn rmdir(path: String) -> Bool:
    """
    Remove a directory at the given path.
    """
    if exists(path):
        if external_call["rmdir", Int, AnyPointer[Int8]](path._buffer.data) == 0:
            return True
        return False
    else:
        print("Directory not exists")
        return False        

fn user() -> String:
    return getenv("USER")


fn main():
    var path : String = "/home/guna/sdg"
    print(rmdir(path))