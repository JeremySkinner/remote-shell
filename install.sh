if [[ ! -d "${HOME}/.remote-shell" ]]; then
    git clone --recurse-submodules https://github.com/JeremySkinner/remote-shell.git ~/.remote-shell
else
    echo 'Updating remote shell.'
    # Make sure we're running the latest
    git --git-dir ~/.remote-shell/.git --work-tree ~/.remote-shell pull origin master
    # Submodule update doesn't support --work-tree, so cd in there using a subshell
    (cd ~/.remote-shell && git submodule update)
fi

# Prompt for name.
name=
while [[ ! $name ]]; do
    echo "What's your name? This will be used to create your custom profile"
    echo "(eg enter 'jeremy' and '.bashrc_jeremy' will be created')"
    echo "If this file exists it will not be overwritten."

    read name
done

# If the custom bashrc doesn't exist, create it.
# The default template is to source the common profile
# as well as any custom profile that's checked in.
if [[ ! -f "${HOME}/.bashrc_$name" ]]; then
    template_common="${HOME}/.remote-shell/bashrc_common.sh"
    template_custom="${HOME}/.remote-shell/bashrc_$name.sh"

    echo "Creating .bashrc_$name"
    echo -e "# Update these variables to point to your custom git config
export GIT_CUSTOM_CONFIG1='~/.gitconfig_$name'
export GIT_CUSTOM_CONFIG2='~/.remote-shell/.gitconfig_$name'

source \"${template_common}\"
[[ -f \"${template_custom}\" ]] && source \"${template_custom}\"

" >> "${HOME}/.bashrc_$name"
else
    echo ".bashrc_$name already exists. Skipping."
fi

# Create git customizations if they don't exist.
if [[ ! -f "${HOME}/.gitconfig_$name" ]]; then
    echo "Creating .gitconfig_$name"
    echo "# Place your custom git config in here" > "${HOME}/.gitconfig_$name"
fi

# Ask the user for their IP.
# If provided, inject it into the bashrc along with the call
# to source the custom bashrc.
echo "Enter your static IP. Leave blank if you don't have one."
read ip

if [[ $ip ]]; then
    # If ~/.bashrc doesn't exist, create it.
    if [ ! -f "${HOME}/.bashrc" ]; then
        echo 'Creating bashrc.'
        echo > ~/.bashrc
    fi

    # Check if the IP exists in the bashrc file.
    if grep -q $ip ~/.bashrc; then
        echo 'This IP has already been loaded.'
    else
        echo "
if [ \"\${SSH_CLIENT%% *}\" == \"$ip\" ]; then
  source ~/.bashrc_$name
fi

" >> ~/.bashrc
    fi
fi

source "${HOME}/.bashrc_$name"