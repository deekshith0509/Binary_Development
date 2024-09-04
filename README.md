
<<<<<<< HEAD
# Binaries Development Repository

Welcome to the Binaries Development Repository! This repository contains various tools and scripts used for creating binaries from shell scripts and Python code using SHC, PyInstaller, Nuitka, and more.


## Introduction

This repository provides resources and tools to compile and package shell scripts and Python scripts into standalone binaries. This can be useful for deploying scripts in environments where dependencies need to be minimized or for distributing tools to users who may not have the required runtime environments installed.

## SHC

**SHC (Shell Script Compiler)** is a tool used to convert shell scripts into binary executables. This provides a way to protect the source code and makes it easier to distribute shell scripts.

### Installation

You can download SHC from its [official website](https://github.com/neurobin/shc). To install SHC, follow these steps:
```sh
 git clone https://github.com/neurobin/shc.git
 cd shc
 make
```
### To compile a shell script using SHC, run:
```sh
./shc -f yourscript.sh
```


This will generate a binary file yourscript.sh.x which can be executed directly.


## PyInstaller

PyInstaller is a popular tool for packaging Python applications into standalone executables. It supports Python 2.7 and Python 3.5+, and can be used to bundle Python scripts along with their dependencies.
Installation

You can install PyInstaller using pip:

```sh
pip install pyinstaller
```
### Usage

To create a standalone executable from a Python script, use the following command:

```sh
pyinstaller --onefile yourscript.py
```
This will generate an executable file in the dist directory.
## Nuitka

Nuitka is a Python compiler that translates Python code into C++ code, which is then compiled into machine code. This often results in faster execution and smaller file sizes compared to other tools.
### Installation

You can install Nuitka using pip:

```sh

pip install nuitka
```
### Usage

To compile a Python script using Nuitka, run:

```sh
nuitka --standalone yourscript.py
```
This will create an executable along with all necessary dependencies.
Shell Scripting

This repository also includes various shell scripts for automating the process of creating and managing binaries. The scripts provided can be used as is or modified to fit your specific needs.
Examples

    build.sh: A script to automate the compilation of Python scripts using PyInstaller or Nuitka.
    deploy.sh: A script to deploy binaries to a remote server.

# Usage

To use the provided shell scripts:

##### Make the script executable:

```sh
     chmod +x script.sh
```
### Run the script:

```sh
    ./script.sh
```
## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. Make sure to follow the coding standards and include appropriate tests.
## License

This project is licensed under the MIT License. See the LICENSE file for more details.
Contact

For questions or feedback, please contact deekshith.bh0509@gmail.com.

This formatting ensures that code blocks are properly displayed and the commands are easily distinguishable. Feel free to adjust the content as needed for your specific project!

=======
# Bash Scripting

This repository includes various miscellaneous bash(UNIX) based shell Scripts.

## Acknowledgements

 - [Termux](https://f-droid.org/en/packages/com.termux/)
 - [check my other Repos](https://github.com/deekshith0509/)


## Deployment

To deploy this project run

```bash
  echo 'export PATH="$PATH:$HOME/bin"' >> ~/.bashrc

  mv .bashrc /data/data/com.termux/files/home/.bashrc
>>>>>>> main
