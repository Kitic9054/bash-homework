# Решения домашнего задания «Скриптинг на Bash»

Скрипты рассчитаны на Bash 5.2+ (Ubuntu 24.04 подходит).

## Состав
- `01-extrasens.sh` — задача 1, «Экстрасенс»
- `bulls-and-cows` — задача 2, «Быки и коровы»
- `15puzzle` — задача 3, «Игра в 15»
- `tower-of-hanoi` — задача 4, «Ханойская башня»
- `mkarch` — задача 5, создание самораспаковывающегося архива
- `massexec.sh` — задача 6, параллельная обработка файлов
- `chsuf` — задача 7, замена суффикса
- `stsuf` — задача 8, статистика суффиксов
- `addline` — задача 9, добавление строки в начало `.txt`

## Запуск
```bash
chmod +x *
./01-extrasens.sh
./bulls-and-cows
./15puzzle
./tower-of-hanoi
./mkarch -d ./example -n example-archive
./massexec.sh --path ./example --mask '*.txt' --number 2 /usr/bin/gzip
./chsuf ./example .txt .bak
./stsuf ./example
./addline ./example
```


