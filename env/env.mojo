from python import Python
from pathlib.path import Path, cwd
from os.path.path import exists, os_is_linux, os_is_macos, os_is_windows
from os.env import getenv

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
        self.user = user()
        self.env_name = name

    fn build(inout self : Self, owned env_dir : Path) raises:
        """
        Create a virtual environment in a directory.

        dir: The target directory to create an environment in.

        """
        if self.dotpath == False:
            env_dir = Path(env_dir)
        else:
            env_dir = expandpath(env_dir)
        if mkdir(env_dir):
            var pyos = Python.import_module("os")
            # var mlib = Python.import_module("requests")
            var mojo = "/home/" + self.user + "/.modular/pkg/packages.modular.com_mojo/bin/mojo"
            var lib = env_dir.joinpath("lib/mojo")
            var bin = env_dir.joinpath("bin/mojo")
            pyos.symlink(mojo, str(bin))
            self.script(env_dir)
            print("\nCreated environment in " + str(env_dir) + " successfully...\n")
        else:
            print("could not create in existing directory try deleting the path or creating on a new one")

    fn script(inout self : Self, env_dir : Path) raises:
        """
        Creates a script from the pre-defined script templates.
        """
        var shf = open("./scripts/activate", "r")
        #var psf = open("../scripts/activate.ps1", "r")
        var script = shf.read()
        shf.close()
        script = script.replace('__VENV_DIR__', env_dir)
        script = script.replace('__VENV_PROMPT__','(' +self.env_name+')')
        var sh = open(env_dir.joinpath("/bin/activate"), 'w')
        sh.write(script)
        sh.close()
