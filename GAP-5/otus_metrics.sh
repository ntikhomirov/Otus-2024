#!/bin/bash

# Генерация метрик в формате Zabbix
if [ "$1" = "discover" ]; then
    # Формирование JSON для LLD
    echo '{"data":['
    echo '{"{#METRIC}":"metric1"},'
    echo '{"{#METRIC}":"metric2"},'
    echo '{"{#METRIC}":"metric3"}'
    echo ']}'
else
    # Генерация случайных значений (0-100)
    METRIC=$1
    echo $((RANDOM % 101))
fi
