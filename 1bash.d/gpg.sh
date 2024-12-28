# Generate a new GPG key
generate_gpg_key() {
    gpg --full-generate-key
}

# Delete a GPG key by key ID
delete_gpg_key() {
    local key_id=$1
    gpg --delete-secret-keys $key_id
    gpg --delete-keys $key_id
}

# Export a public key to a file
export_gpg_public_key() {
    local key_id=$1
    gpg --export -a $key_id
}

# Export a private key to a file
export_gpg_private_key() {
    local key_id=$1
    gpg --export-secret-keys -a $key_id
}

# List all GPG keys
list_gpg_keys() {
    gpg --list-keys
}

# List all secret GPG keys
list_secret_gpg_keys() {
    gpg --list-secret-keys
}

# Import a GPG key from a file
import_gpg_key() {
    local input_file=$1
    gpg --import $input_file
}
