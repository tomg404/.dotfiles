#!/bin/sh

help_text="Usage:
  $0 OPTIONS

OPTIONS
  -m    show current memory usage
  -p    show current memory usage as percentage
  -t    show temperature in degree celsius
  -f    show temperature in degree fahrenheit
  -h    show this help message
"

if [[ $# == 0 ]]; then
  printf "%s" "$help_text"
fi

show_memory=false
show_temperature=false
show_memory_as_percentage=false
show_temperature_as_fahrenheit=false

while getopts "mtpfh" opt; do
  case $opt in
    m)
      show_memory=true
      ;;
    p)
      show_memory=true
      show_memory_as_percentage=true
      ;;
    t)
      show_temperature=true
      ;;
    f)
      show_temperature=true
      show_temperature_as_fahrenheit=true
      ;;
    h)
      printf "%s" "$help_text"
      exit 0
      ;;
    \?)
      exit 1
      ;;
    :)
      exit 1
      ;;
  esac
done

if $show_memory; then
  if $show_memory_as_percentage; then
    used_mem=$(nvidia-smi --query-gpu "memory.used" --format csv,noheader,nounits)
    total_mem=$(nvidia-smi --query-gpu "memory.total" --format csv,noheader,nounits)
    used_percentage=$(($used_mem / $total_mem))
    echo "$used_percentage%"
  else
    used_mem=$(nvidia-smi --query-gpu "memory.used" --format csv,noheader)
    total_mem=$(nvidia-smi --query-gpu "memory.total" --format csv,noheader)
    echo "$used_mem / $total_mem"
  fi
elif $show_temperature; then
  gpu_temp=$(nvidia-smi --query-gpu "temperature.gpu" --format csv,noheader)
  if $show_temperature_as_fahrenheit; then
    gpu_temp=$(( (gpu_temp * 9/5) + 32 )) 
    echo "$gpu_temp°F"
  else
    echo "$gpu_temp°C"
  fi
fi

