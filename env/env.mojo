from os.path.path import os_is_macos, os_is_linux, os_is_windows, exists
from pathlib.path import cwd, Path
from python import Python
from os.env import getenv
from sys.arg import argv

fn abspath(path: Path) raises -> String:
    """
    Return the absolute path to the given path.
    """
    return cwd().joinpath(String(path).replace("./", ""))

fn mkdir(path: Path) raises -> Bool:
    """
    Create a directory at the given path.
    """
    if not exists(path):
        var f = open(path.joinpath("/.init"), "w")
        f.close()
        f = open(path.joinpath("/bin/.init"), "w")
        f.close()
        f = open(path.joinpath("/lib/mojo/.init"), "w")
        f.close()
        return True
    else:
        print("Directory already exists")
        return False

struct envbuider:
    """
    This struct exists to allow virtual environment creation to be customized.

    path : The path to the virtual environment.
    system_site_packages : If True, the system (global) site-packages dir is available to created environments.
    with_mlib : If True, ensure mlib is installed in the virtual environment.

    """
    var env_name : String
    var path : String
    var with_mlib : Bool
    var dotpath : Bool
    var os_type : String
    var user : String

    fn __init__(inout self : Self, path: String,name : String, with_mlib: Bool = True):
        self.path = path
        if self.path.startswith("."):
            self.dotpath = True
        self.dotpath = False
        self.with_mlib = with_mlib
        if os_is_linux():
            self.os_type = "linux"
        if os_is_macos():
            self.os_type = "macos"
        if os_is_windows():
            self.os_type = "windows"
        else:
            self.os_type = "unknown"
        self.user = getenv("USER")
        self.env_name = name

    fn build(inout self : Self, owned env_dir : Path) raises:
        """
        Create a virtual environment in a directory.

        dir: The target directory to create an environment in.

        """
        if self.dotpath == False:
            env_dir = Path(env_dir)
        else:
            env_dir = abspath(env_dir)
        if mkdir(env_dir):
            var pyos = Python.import_module("os")
            # var mlib = Python.import_module("requests")
            var mojo = "/home/" + self.user + "/.modular/pkg/packages.modular.com_mojo/bin/mojo"
            var lib = env_dir.joinpath("lib/mojo")
            var bin = env_dir.joinpath("bin/mojo")
            pyos.symlink(mojo, str(bin))
            self.script(env_dir)
        else:
            print("could not create in existing directory try deleting the path or creating on a new one")

    fn script(inout self : Self, env_dir : Path) raises:
        """
        Creates a script from the pre-defined script templates.
        """
        var shf = open("../scripts/activate", "r")
        #var psf = open("../scripts/activate.ps1", "r")
        var script = shf.read()
        shf.close()
        script = script.replace('__VENV_DIR__', env_dir)
        script = script.replace('__VENV_PROMPT__',self.env_name)
        var sh = open(env_dir.joinpath("/bin/activate"), 'w')
        sh.write(script)
        sh.close()

fn main() raises :
    var path : String = ""
    var name : String = ""
    var args = argv()
    if (args.__len__() == 1):
        print("\nUsage: mojo env.mojo <path-to-env> [options]")
        print('\nExample: mojo env.mojo /home/sam/mojoenv')
        print("\nOptions:")
        print("\nNone")
    else:
            for i in range(1, args.__len__()):
                path = path.__add__(str(args[i]))
            var names = path.split("/")
            names.reverse()
            name = names[0]
            var env = envbuider(path,name,True)
            env.build(path)
