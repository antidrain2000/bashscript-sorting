#!/bin/bash

bubble_sort() {
    local array=("$@")
    local n=${#array[@]}
    for ((i = 0; i < n-1; i++)); do
        for ((j = 0; j < n-i-1; j++)); do
            if ((array[j] > array[j+1])); then
                local temp=${array[j]}
                array[j]=${array[j+1]}
                array[j+1]=$temp
            fi
        done
    done
    echo "${array[@]}"
}

insertion_sort() {
    local array=("$@")
    local n=${#array[@]}
    for ((i = 1; i < n; i++)); do
        local key=${array[i]}
        local j=$((i-1))
        while ((j >= 0 && array[j] > key)); do
            array[j+1]=${array[j]}
            j=$(j-1)
        done
        array[j+1]=$key
    done
    echo "${array[@]}"
}

quick_sort() {
    local array=("$@")
    if (( ${#array[@]} <= 1 )); then
        echo "${array[@]}"
    else
        local pivot=${array[0]}
        local less=()
        local greater=()
        for ((i = 1; i < ${#array[@]}; i++)); do
            if ((array[i] <= pivot)); then
                less+=(${array[i]})
            else
                greater+=(${array[i]})
            fi
        done
        local sorted_less=($(quick_sort "${less[@]}"))
        local sorted_greater=($(quick_sort "${greater[@]}"))
        echo "${sorted_less[@]}" "$pivot" "${sorted_greater[@]}"
    fi
}

while getopts "t:" opt; do
    case $opt in
        t) type=$OPTARG ;;
        *) echo "Usage: $0 -t {bubble|insertion|quick}" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

read -a array

echo "Input array: ${array[@]}" >&2

case $type in
    bubble) sorted_array=$(bubble_sort "${array[@]}") ;;
    insertion) sorted_array=$(insertion_sort "${array[@]}") ;;
    quick) sorted_array=$(quick_sort "${array[@]}") ;;
    *) echo "Invalid sort type: $type" >&2; exit 1 ;;
esac

echo "Sorted array: $sorted_array" >&2




#chmod +x my-sort.sh
#echo 7 2 4 3 6 1 -100 | ./my-sort.sh -t quick
