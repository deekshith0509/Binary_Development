#!/bin/bash

# Function to encrypt a file
encrypt_file() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <input_file>"
        exit 1
    fi

    input_file=$1
    output_file="${input_file}.enc"

    # Prompt for password
    read -sp "Enter encryption password: " password
    echo

    # Encrypt the file
    if ! openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass "pass:$password"; then
        echo "Encryption failed!"
        exit 1
    fi

    echo "File encrypted successfully as $output_file"
}

# Function to decrypt a file
decrypt_file() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <input_file>"
        exit 1
    fi

    input_file=$1
    output_file="${input_file%.enc}"

    # Prompt for password
    read -sp "Enter decryption password: " password
    echo

    # Decrypt the file
    if ! openssl enc -d -aes-256-cbc -in "$input_file" -out "$output_file" -pass "pass:$password"; then
        echo "Decryption failed!"
        exit 1
    fi

    echo "File decrypted successfully as $output_file"
}

# Main script
if [ $# -lt 2 ]; then
    echo "Usage: $0 <encrypt/decrypt> <input_file>"
    exit 1
fi

action=$1
file=$2

case "$action" in
    encrypt)
        encrypt_file "$file"
        ;;
    decrypt)
        decrypt_file "$file"
        ;;
    *)
        echo "Invalid option: $action"
        echo "Usage: $0 <encrypt/decrypt> <input_file>"
        exit 1
        ;;
esac
