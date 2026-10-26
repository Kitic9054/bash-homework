#!/usr/bin/env bash
# Задача 1. Экстрасенс
RED=$'\033[31m'
GREEN=$'\033[32m'
RESET=$'\033[0m'

hits=0
misses=0
step=1
declare -a history_numbers=()
declare -a history_hits=()

while :; do
    printf 'Step: %d\n' "$step"
    read -r -p 'Please enter number from 0 to 9 (q - quit): ' answer

    if [[ $answer == q ]]; then
        break
    fi
    if [[ ! $answer =~ ^[0-9]$ ]]; then
        echo "Invalid input. Enter one digit from 0 to 9, or q."
        continue
    fi

    secret=$((RANDOM % 10))
    if [[ $answer == "$secret" ]]; then
        echo "Hit! My number: $secret"
        ((hits += 1))
        history_hits+=(1)
    else
        echo "Miss! My number: $secret"
        ((misses += 1))
        history_hits+=(0)
    fi
    history_numbers+=("$secret")

    total=$((hits + misses))
    hit_percent=$((hits * 100 / total))
    miss_percent=$((misses * 100 / total))
    printf 'Hit: %d%% Miss: %d%%\n' "$hit_percent" "$miss_percent"

    printf 'Numbers:'
    start=0
    if ((${#history_numbers[@]} > 10)); then
        start=$((${#history_numbers[@]} - 10))
    fi
    for ((i=start; i<${#history_numbers[@]}; i++)); do
        if [[ ${history_hits[i]} == 1 ]]; then
            printf ' %s%s%s' "$GREEN" "${history_numbers[i]}" "$RESET"
        else
            printf ' %s%s%s' "$RED" "${history_numbers[i]}" "$RESET"
        fi
    done
    printf '\n'
    ((step += 1))
done
echo "Bye."
