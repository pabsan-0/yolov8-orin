# This script is meant to be sourced
# Hardcoded completions because default behavior of docker-compose is too slow

# Autocompletes for 
# 
#    docker-compose run   --rm  deepstream 
#                   build       ultralytics 

CONTAINERS="ultralytics deepstream"

_complete_tmuxinator_ls(){
    # echo $COMP_WORDS

    # Main autocompletion
    if [[ ${COMP_WORDS[COMP_CWORD-1]} =~ ^(docker-compose)$ ]]
    then 
        COMPREPLY+=( $(compgen -W "build run" -- "${COMP_WORDS[COMP_CWORD]}") )
        
    elif [[ ${COMP_WORDS[COMP_CWORD-1]} =~ ^(build|run|--rm)$ ]]
    then 
        COMPREPLY+=( $(compgen -W "$CONTAINERS" -- "${COMP_WORDS[COMP_CWORD]}") )
    else 
        : 
    fi

    # Optionally add the --rm argument on run
    if [[ ${COMP_WORDS[COMP_CWORD-1]} =~ ^(run)$ ]]
    then 
        COMPREPLY+=( $(compgen -W "--rm" -- "${COMP_WORDS[COMP_CWORD]}") )
    fi 

    return 0
}

complete -W "docker-compose" -E 
complete  -F _complete_tmuxinator_ls docker-compose