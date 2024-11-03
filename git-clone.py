import os
import subprocess
import requests

# Define the GitHub username and the directory to clone repos into
github_username = "deekshith0509"
clone_directory = "C:\\Users\\deeks\\Desktop\\Projects\\GIT"

# Ensure the clone directory exists
os.makedirs(clone_directory, exist_ok=True)

# Get the list of repositories for the user
response = requests.get(f"https://api.github.com/users/{github_username}/repos")
repos = response.json()

# Clone each repository
for repo in repos:
    repo_name = repo["name"]
    repo_clone_url = repo["clone_url"]
    repo_clone_path = os.path.join(clone_directory, repo_name)
    
    if not os.path.exists(repo_clone_path):
        print(f"Cloning {repo_name} into {repo_clone_path}")
        subprocess.run(["git", "clone", repo_clone_url, repo_clone_path])
    else:
        print(f"Repository {repo_name} already exists in {repo_clone_path}")

print("All repositories have been cloned.")
