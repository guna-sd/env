from sys.arg import argv
from env import envbuider

fn main() raises :
    var path : String = ""
    var name : String = ""
    var args = argv()
    if (args.__len__() == 1):
        print("\nUsage: mojo env.mojo <path-to-env>")
        print('\nExample: mojo env.mojo /home/sam/mojoenv\n')
    else:
            for i in range(1, args.__len__()):
                path = path.__add__(str(args[i]))
            var names = path.split("/")
            names.reverse()
            name = names[0]
            var env = envbuider(path,name,True)
            env.build(path)