# Based on git-profiles from https://github.com/sudoforge/git-profiles

which_func() {
    local filename=$1 path_to_check
    for path_to_check in $(echo $PATH | sed 's/:/ /g'); do
        if [ -x "$path_to_check/$filename" ]; then
            echo "$path_to_check/$filename"
            return 0
        fi
    done
    return 1
}

GIT_PROFILES_GIT_COMMAND=""
if which_func git > /dev/null 2>&1; then
    GIT_PROFILES_GIT_COMMAND=$(which_func git)
fi

git() {
    if [ ! -e "${GIT_PROFILES_GIT_COMMAND}" ]; then
        echo "Git does not seem to be installed. Exiting."
        exit 1
    fi

    local gitprofile1=$GIT_CUSTOM_CONFIG1
    local gitprofile2=$GIT_CUSTOM_CONFIG2

    # Add the profile path to the global [include] section
    local added_path1=false
    if [ ! -z "${gitprofile1}" ]; then
        local check=$("${GIT_PROFILES_GIT_COMMAND}" config --global --get-all include.path | grep "${gitprofile1}")

        if [ "${check}" != "${gitprofile1}" ]; then
            local added_path1=true
            eval "${GIT_PROFILES_GIT_COMMAND} config --global --add include.path ${gitprofile1}"
        fi
    fi

    local added_path2=false
    if [ ! -z "${gitprofile2}" ]; then
        local check=$("${GIT_PROFILES_GIT_COMMAND}" config --global --get-all include.path | grep "${gitprofile2}")

        if [ "${check}" != "${gitprofile2}" ]; then
            local added_path2=true
            eval "${GIT_PROFILES_GIT_COMMAND} config --global --add include.path ${gitprofile2}"
        fi
    fi

    # Execute the commands passed into this function
    eval "${GIT_PROFILES_GIT_COMMAND} ${@}"

    # Clean up the global [include] section
    if [ "${added_path1}" = true ]; then
        eval "${GIT_PROFILES_GIT_COMMAND} config --global --unset include.path ${gitprofile1}"
    fi

    if [ "${added_path2}" = true ]; then
        eval "${GIT_PROFILES_GIT_COMMAND} config --global --unset include.path ${gitprofile2}"
    fi

    #if [[ "${added_path1}" -eq true ]] || [[ "${added_path2}" -eq true ]]; then 
    #    local paths=$("${GIT_PROFILES_GIT_COMMAND}" config --global --get-all include.path)
    #    if [ "${paths}" = "" ]; then
    #        eval "${GIT_PROFILES_GIT_COMMAND} config --global --remove-section include"
    #    fi
    #fi
}