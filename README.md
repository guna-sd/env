### env
env is a virtual enviroment tool for mojo.
env (for mojo🔥) allows you to manage separate package installations for different projects. It creates a “virtual” isolated mojo🔥 installation. When you switch projects, you can create a new virtual environment which is isolated from other virtual environments.

## prerequisites

Make sure you have installed and [configured mojo on your environment](https://docs.modular.com/mojo/manual/get-started/index.html)

once mojo is installed and configured open bash and run

```bash
git clone https://github.com/mojolibs/env.git && cd env/env
```

```bash
guna@anug:~/projects/gitu/env/env$ mojo env.mojo

Usage: mojo env.mojo <path-to-env>

Example: mojo env.mojo /home/sam/mojoenv
```
<p>
  <img src="assets/mojo_env.png" alt="mojo env usage">
</p>