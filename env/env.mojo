from os.path.path import os_is_macos, os_is_linux, os_is_windows, PathLike, exists
from pathlib.path import cwd, Path, listdir

fn abspath(path: Path) raises -> String:
    """
    Return the absolute path to the given path.
    """
    return cwd().joinpath(path)

fn mkdir(path: Path) raises:
    """
    Create a directory at the given path.
    """
    if not exists(path):
        var f = open(path.joinpath("/.init"), "w")
        f.close()
    else:
        print("Directory already exists")

struct envbuider:
    """
    This struct exists to allow virtual environment creation to be customized.

    path : The path to the virtual environment.
    system_site_packages : If True, the system (global) site-packages dir is available to created environments.
    with_mlib : If True, ensure mlib is installed in the virtual environment.

    """
    var path : String
    var with_mlib : Bool
    var dotpath : Bool
    var sys_site_packages : Bool
    var os_type : String

    fn __init__(inout self, path: String, with_mlib: Bool = True, sys_site_packages: Bool = False):
        self.path = path
        if self.path.startswith("."):
            self.dotpath = True
        self.dotpath = False
        self.with_mlib = with_mlib
        self.sys_site_packages = sys_site_packages
        if os_is_linux():
            self.os_type = "linux"
        if os_is_macos():
            self.os_type = "macos"
        if os_is_windows():
            self.os_type = "windows"
        else:
            self.os_type = "unknown"
    
    fn build(inout self, owned env_dir : Path) raises:
        """
        Create a virtual environment in a directory.

        dir: The target directory to create an environment in.

        """
        if self.dotpath == False:
            env_dir = Path(env_dir)
        else:
            env_dir = abspath(env_dir)
        if exists(env_dir):
            print("Path already exists try another path.")
    
    fn make_dirs(self, dir : Path) raises:
        if not exists(dir):
            mkdir(dir)

            

fn main() raises :
    var path = Path("environ")