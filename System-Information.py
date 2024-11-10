#!/usr/bin/env python3

import subprocess
import time
import os
import sys
import pkg_resources
from rich.console import Console
from rich.table import Table
from rich.panel import Panel

# Initialize console for rich output
console = Console()

def run_command(command, use_sudo=False):
    """Run a command in the shell and return the output."""
    try:
        if use_sudo and os.geteuid() != 0:
            command = f"sudo {command}"
        
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        result.check_returncode()  # Raise an error if command failed
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return f"Error running command '{command}': {e}"
    except FileNotFoundError:
        return f"Command not found: {command}"

def command_exists(command):
    """Check if a command exists."""
    return subprocess.call(f"which {command}", shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0

def clear_screen():
    """Clear the terminal screen."""
    os.system('clear' if os.name == 'posix' else 'cls')

def install_python_package(package):
    """Install a Python package using pip."""
    try:
        console.print(f"Installing Python package: {package}", style="bold yellow")
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])
        console.print(f"Successfully installed {package}.", style="bold green")
    except subprocess.CalledProcessError as e:
        console.print(f"Failed to install {package}: {e}", style="bold red")

def install_system_package(package):
    """Install a system package using the appropriate package manager."""
    try:
        if os.path.exists('/system/bin/sh'):  # Termux
            subprocess.check_call(['pkg', 'install', '-y', package])
        elif os.path.exists('/usr/bin/apt'):  # Debian/Ubuntu
            subprocess.check_call(['sudo', 'apt-get', 'install', '-y', package])
        elif os.path.exists('/usr/bin/dnf'):  # Fedora/RHEL
            subprocess.check_call(['sudo', 'dnf', 'install', '-y', package])
        elif os.path.exists('/usr/bin/yum'):  # Older Fedora/RHEL
            subprocess.check_call(['sudo', 'yum', 'install', '-y', package])
        else:
            console.print(f"Unsupported package manager for {package}. Please install manually.", style="bold red")
    except subprocess.CalledProcessError as e:
        console.print(f"Failed to install system package {package}: {e}", style="bold red")

def install_required_packages():
    """Install required Python packages."""
    required_packages = [
        "rich==13.4.1",
        "speedtest-cli==2.1.3"
    ]
    
    installed_packages = {pkg.key for pkg in pkg_resources.working_set}
    
    for pkg in required_packages:
        pkg_name = pkg.split('==')[0]
        if pkg_name not in installed_packages:
            install_python_package(pkg)
        else:
            console.print(f"Python package {pkg_name} is already installed.", style="bold green")

def install_system_dependencies():
    """Install required system utilities."""
    system_packages = [
        "figlet",
        "smartmontools",
        "sysstat",
        "iproute2",
        "python3-pip"
    ]
    
    try:
        console.print("Updating package list...", style="bold yellow")
        if os.path.exists('/system/bin/sh'):
            subprocess.check_call(['pkg', 'update'])
        elif os.path.exists('/usr/bin/apt'):
            subprocess.check_call(['sudo', 'apt-get', 'update'])
        elif os.path.exists('/usr/bin/dnf'):
            subprocess.check_call(['sudo', 'dnf', 'makecache'])
        elif os.path.exists('/usr/bin/yum'):
            subprocess.check_call(['sudo', 'yum', 'makecache'])
        
        for pkg in system_packages:
            if not command_exists(pkg):
                install_system_package(pkg)
            else:
                console.print(f"System package {pkg} is already installed.", style="bold green")
    except subprocess.CalledProcessError as e:
        console.print(f"Failed to update package list or install a system package: {e}", style="bold red")

def setup_environment():
    """Setup the environment by installing all required dependencies."""
    try:
        install_system_dependencies()
        install_required_packages()
    except Exception as e:
        console.print(f"Error during environment setup: {e}", style="bold red")

def get_cpu_info():
    return run_command("lscpu")

def get_system_info():
    return run_command("uname -a")

def get_memory_info():
    return run_command("free -h")

def get_disk_usage():
    return run_command("df -h")

def get_network_info():
    return run_command("ip a")

def get_gpu_info():
    """Retrieve GPU information using lshw."""
    return run_command("sudo lshw -C display", use_sudo=True)

def get_realtime_disk_speed():
    if command_exists("iostat"):
        return run_command("iostat -dx 1")  # Requires `sysstat` package
    return "iostat command not found, install `sysstat` package."

def get_smart_info(device):
    """Retrieve SMART info for a specified device."""
    if command_exists("smartctl"):
        if not os.path.exists(device):
            return f"Device {device} does not exist."
        return run_command(f"sudo smartctl -a -T permissive {device}", use_sudo=True)
    return "smartctl command not found."

def get_installed_packages():
    return run_command("dpkg --list")

def get_system_services():
    return run_command("systemctl list-units --type=service")

def get_open_ports():
    return run_command("ss -tuln")

def get_uptime():
    return run_command("uptime -p")

def get_disk_health(device):
    """Retrieve SMART health info for a specified device."""
    if command_exists("smartctl"):
        if not os.path.exists(device):
            return f"Device {device} does not exist."
        return run_command(f"sudo smartctl --health {device}", use_sudo=True)
    return "smartctl command not found."

def get_virtual_memory():
    return run_command("vmstat -s")

def get_process_statistics():
    return run_command("top -b -n 1")

def continuous_disk_speed():
    """Continuously monitor disk speed."""
    if not command_exists("iostat"):
        console.print("iostat command not found, install `sysstat` package.", style="bold red")
        return
    try:
        while True:
            console.print(run_command("iostat -dx 1"))
            time.sleep(1)
    except KeyboardInterrupt:
        console.print("\nStopped monitoring disk speed.", style="bold green")

def continuous_network_speed():
    """Run network speed test using speedtest-cli only once."""
    if command_exists("speedtest-cli"):
        try:
            console.print(run_command("speedtest-cli"))
        except Exception as e:
            console.print(f"Error running speedtest-cli: {e}", style="bold red")
    else:
        console.print("speedtest-cli command not found. Please install it first.", style="bold red")

def print_menu():
    """Print the main menu with options."""
    clear_screen()
    name = "Deekshith"  # Replace with your name
    figlet_output = run_command(f"figlet {name}")
    console.print(Panel(figlet_output, title="Welcome", title_align="left", subtitle="System Information Tool"))

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Index", style="dim", width=6)
    table.add_column("Category", style="bold cyan")

    options = [
        ("1", "CPU Information"),
        ("2", "System Information"),
        ("3", "Memory Information"),
        ("4", "Disk Usage"),
        ("5", "Network Information"),
        ("6", "GPU Information"),
        ("7", "Real-Time Network Speed"),
        ("8", "Real-Time Disk Speed"),
        ("9", "SMART Info"),
        ("10", "Installed Packages"),
        ("11", "System Services"),
        ("12", "Open Network Ports"),
        ("13", "Uptime"),
        ("14", "Disk Health"),
        ("15", "Virtual Memory"),
        ("16", "Process Statistics"),
        ("0", "Exit")
    ]

    for index, category in options:
        table.add_row(index, category)

    console.print(table)


def main():
    try:
        # Use a hidden file in the user's home directory
        home_dir = os.path.expanduser("~")
        flag_file_path = os.path.join(home_dir, ".environment_setup_done")
        
        if not os.path.exists(flag_file_path):
            setup_environment()
            with open(flag_file_path, "w") as f:
                f.write("Environment setup complete.\n")
        else:
            console.print("Environment already set up.", style="bold green")

        while True:
            print_menu()
            choice = input("\nEnter your choice: ")

            if choice == "1":
                console.print("CPU Information:\n", style="bold blue")
                console.print(get_cpu_info())
            elif choice == "2":
                console.print("System Information:\n", style="bold blue")
                console.print(get_system_info())
            elif choice == "3":
                console.print("Memory Information:\n", style="bold blue")
                console.print(get_memory_info())
            elif choice == "4":
                console.print("Disk Usage:\n", style="bold blue")
                console.print(get_disk_usage())
            elif choice == "5":
                console.print("Network Information:\n", style="bold blue")
                console.print(get_network_info())
            elif choice == "6":
                console.print("GPU Information:\n", style="bold blue")
                console.print(get_gpu_info())
            elif choice == "7":
                console.print("Real-Time Network Speed:\n", style="bold blue")
                continuous_network_speed()
            elif choice == "8":
                console.print("Real-Time Disk Speed:\n", style="bold blue")
                continuous_disk_speed()
            elif choice == "9":
                device = input("Enter the device (e.g., /dev/sda): ")
                console.print(f"SMART Info for {device}:\n", style="bold blue")
                console.print(get_smart_info(device))
            elif choice == "10":
                console.print("Installed Packages:\n", style="bold blue")
                console.print(get_installed_packages())
            elif choice == "11":
                console.print("System Services:\n", style="bold blue")
                console.print(get_system_services())
            elif choice == "12":
                console.print("Open Network Ports:\n", style="bold blue")
                console.print(get_open_ports())
            elif choice == "13":
                console.print("Uptime:\n", style="bold blue")
                console.print(get_uptime())
            elif choice == "14":
                device = input("Enter the device (e.g., /dev/sda): ")
                console.print(f"Disk Health for {device}:\n", style="bold blue")
                console.print(get_disk_health(device))
            elif choice == "15":
                console.print("Virtual Memory:\n", style="bold blue")
                console.print(get_virtual_memory())
            elif choice == "16":
                console.print("Process Statistics:\n", style="bold blue")
                console.print(get_process_statistics())
            elif choice == "0":
                console.print("Exiting... Goodbye!", style="bold green")
                sys.exit(0)
            else:
                console.print("Invalid choice, please try again.", style="bold red")

            input("\nPress Enter to return to the menu...")

    except KeyboardInterrupt:
        console.print("\nExited by user.", style="bold green")
        sys.exit(0)
    except Exception as e:
        console.print(f"An unexpected error occurred: {e}", style="bold red")
        sys.exit(1)


if __name__ == "__main__":
    main()
