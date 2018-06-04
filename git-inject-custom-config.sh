# Based on git-profiles from https://github.com/sudoforge/git-profiles

git() {

    local gitprofile1=$GIT_CUSTOM_CONFIG1
    local gitprofile2=$GIT_CUSTOM_CONFIG2

    # Add the profile path to the global [include] section
    local added_path1=false
    if [ ! -z "${gitprofile1}" ]; then
        local check=$(command git config --global --get-all include.path | grep "${gitprofile1}")

        if [ "${check}" != "${gitprofile1}" ]; then
            local added_path1=true
            command git config --global --add include.path $gitprofile1
        fi
    fi

    local added_path2=false
    if [ ! -z "${gitprofile2}" ]; then
        local check=$(command git config --global --get-all include.path | grep "${gitprofile2}")

        if [ "${check}" != "${gitprofile2}" ]; then
            local added_path2=true
             command git config --global --add include.path $gitprofile2
        fi
    fi

    # Execute the commands passed into this function
    command git $@

    # Clean up the global [include] section
    if [ "${added_path1}" = true ]; then
        command git config --global --unset include.path $gitprofile1
    fi

    if [ "${added_path2}" = true ]; then
       command git config --global --unset include.path $gitprofile2
    fi

    if [[ "${added_path1}" -eq true ]] || [[ "${added_path2}" -eq true ]]; then
        local paths=$(command git config --global --get-all include.path)
        if [ "${paths}" = "" ]; then
           command git config --global --remove-section include
        fi
    fi
}