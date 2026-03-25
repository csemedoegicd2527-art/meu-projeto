#!/bin/bash
LOG_FILE="10000.log"
TOTAL_LINHAS=$(awk 'END {print NR}' "$LOG_FILE")
TOTAL_ERROS=$(grep -c "ERROR" "$LOG_FILE")
IP_UNICOS=$(awk '{print $2}' "$LOG_FILE" | sort | uniq | wc -l)
IP_FREQUENTE=$(awk '{print $2}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
NUM_DOWNLOADS=$(grep -c "DOWNLOAD" "$LOG_FILE")

echo "Relatório do Log:"
echo "----------------"
echo "Total de linhas: $TOTAL_LINHAS"
echo "Total de erros: $TOTAL_ERROS"
echo "IPs únicos: $IP_UNICOS"
echo "IP mais frequente: $IP_FREQUENTE"
echo "Número de downloads: $NUM_DOWNLOADS"

