#!/usr/bin/env bash
# Задача 6. Параллельная обработка файлов без GNU Parallel.
set -u
path=$PWD
mask='*'
number=$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
usage() { echo "Использование: $0 [--path dirpath] [--mask mask] [--number number] command" >&2; exit 2; }

while (($#)); do
    case $1 in
        --path) (($# >= 2)) || usage; path=$2; shift 2 ;;
        --mask) (($# >= 2)) || usage; mask=$2; shift 2 ;;
        --number) (($# >= 2)) || usage; number=$2; shift 2 ;;
        --) shift; break ;;
        -*) usage ;;
        *) break ;;
    esac
done
(($# == 1)) || usage
command_path=$1
[[ -d $path ]] || { echo "Ошибка: каталог не существует: $path" >&2; exit 2; }
[[ $mask ]] || { echo "Ошибка: маска не должна быть пустой." >&2; exit 2; }
[[ $number =~ ^[0-9]+$ ]] && ((number > 0)) || { echo "Ошибка: number должен быть целым числом > 0." >&2; exit 2; }
[[ -f $command_path && -x $command_path ]] || command -v "$command_path" >/dev/null || { echo "Ошибка: команда не найдена или не исполняема." >&2; exit 2; }

# Преобразуем относительный путь каталога в абсолютный.
path=$(cd -- "$path" && pwd -P)
declare -a files=()
shopt -s nullglob
for file in "$path"/$mask; do
    [[ -f $file && ! -L $file ]] && files+=("$file")
done
shopt -u nullglob

if ((${#files[@]} == 0)); then
    echo "Нет регулярных файлов, подходящих под маску."
    exit 0
fi

declare -A active=()
next=0
running=0
failed=0
while ((next < ${#files[@]} || running > 0)); do
    while ((next < ${#files[@]} && running < number)); do
        "$command_path" "${files[next]}" &
        pid=$!
        active[$pid]=1
        ((running += 1))
        ((next += 1))
    done
    finished_pid=""
    wait -n -p finished_pid
    status=$?
    [[ $status == 0 ]] || failed=1
    if [[ -n $finished_pid && -n ${active[$finished_pid]+x} ]]; then
        unset 'active[$finished_pid]'
        ((running -= 1))
    fi
done
exit "$failed"
