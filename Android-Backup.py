import os
import subprocess
import sys
from datetime import datetime

# Configuration
BACKUP_DIR = "/sdcard/termux-backup"
LOG_FILE = os.path.join(BACKUP_DIR, "backup_log.txt")
APK_DIR = "/data/app"
DATA_DIR = "/data/data"
SU_REQUIRED = "su" in os.getenv("SHELL", "")

def run_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error executing command: {command}\n{result.stderr}")
    return result.stdout

def backup():
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = os.path.join(BACKUP_DIR, f"backup_{timestamp}.tar.gz")

    # Create backup directory if it does not exist
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR)

    if SU_REQUIRED:
        # Backup APKs and their data
        tar_command = f"tar -czf {backup_path} -C / {APK_DIR} {DATA_DIR}"
        print(f"Running command with su: {tar_command}")
        run_command(f"su -c '{tar_command}'")
    else:
        # Backup only APKs
        tar_command = f"tar -czf {backup_path} -C / {APK_DIR}"
        print(f"Running command: {tar_command}")
        run_command(tar_command)
    
    # Log the backup
    with open(LOG_FILE, "a") as log_file:
        log_file.write(f"{timestamp}: Backup created at {backup_path}\n")

    print(f"Backup completed and stored at {backup_path}")

def restore(backup_file):
    if not os.path.exists(backup_file):
        print(f"Backup file {backup_file} does not exist.")
        return

    if SU_REQUIRED:
        # Restore APKs and their data
        restore_command = f"tar -xzf {backup_file} -C /"
        print(f"Running command with su: {restore_command}")
        run_command(f"su -c '{restore_command}'")
    else:
        # Restore only APKs (print message for manual data restoration)
        restore_command = f"tar -xzf {backup_file} -C / {APK_DIR}"
        print(f"Running command: {restore_command}")
        run_command(restore_command)
        print("APK files restored. For full restoration, please run the script with superuser privileges.")

    print(f"Restore completed from {backup_file}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python main.py --backup | --restore <backup_file>")
        sys.exit(1)

    action = sys.argv[1]

    if action == "--backup":
        backup()
    elif action.startswith("--restore"):
        backup_file = sys.argv[2] if len(sys.argv) > 2 else None
        if backup_file:
            restore(backup_file)
        else:
            print("Please provide the backup file to restore from.")
    else:
        print("Invalid argument. Use --backup to backup or --restore <backup_file> to restore.")

if __name__ == "__main__":
    main()
