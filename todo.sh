#!/bin/bash

TODO_FILE="$HOME/.todo_list"

if [ $# -eq 0 ]; then
    echo "Usage: todo [add <task> | list | remove <task_number> | clear]"
    exit 1
fi

if [ "$1" == "add" ]; then
    shift
    if [ -z "$@" ]; then
        echo "Error: Task description cannot be empty."
        exit 1
    fi
    echo "$@" >> "$TODO_FILE"
    echo "Task added: $@"
elif [ "$1" == "list" ]; then
    if [ -f "$TODO_FILE" ]; then
        echo "To-Do List:"
        awk '{print "\033[32m" NR ".\033[0m", $0}' "$TODO_FILE"
    else
        echo "No tasks found."
    fi
elif [ "$1" == "remove" ]; then
    shift
    if [ $# -eq 0 ]; then
        echo "Error: Please specify the task number to remove."
        exit 1
    fi
    if [ -f "$TODO_FILE" ]; then
        sed -i "${1}d" "$TODO_FILE"
        echo "Task removed."
    else
        echo "No tasks found."
    fi
elif [ "$1" == "clear" ]; then
    rm -f "$TODO_FILE"
    echo "To-Do list cleared."
else
    echo "Usage: todo [add <task> | list | remove <task_number> | clear]"
    exit 1
fi
