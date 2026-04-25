#!/bin/bash
#LOG_FILE="10000.log"
LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
 echo "Ficheiro não existe"

 exit 1
fi
echo "ficheiro encontrado"

#errors=$(grep -c "ERROR" "$LOG_FILE")
#echo "total de erros: $errors"


while true
do
  echo ""
  echo "MENU"
  echo "1- Total linhas"
  echo "2- Total erros" 
  echo "3- IPs únicos" 
  echo "4- Top IP" 
  echo "5- Downloads" 
  echo "6- sair"
  echo "7- gerar relatorio"
  
  
  read option
  
  case $option in 
   1) 
     wc -l "$LOG_FILE" 
      ;; 
    2) 
      grep ERROR "$LOG_FILE" | wc -l 
       ;; 
    3) 
      cut -d " " -f2 "$LOG_FILE" | sort | uniq | wc -l 
      ;; 
    
    4) 
      cut -d " " -f2 "$LOG_FILE" | sort | uniq -c | sort -nr | head -n1 
      ;; 
    5)
      grep DOWNLOAD "$LOG_FILE" | wc -l
      ;;
    6) 
      exit 0 
      ;; 
    7)
      TOTAL_LINHAS=$(awk 'END {print NR}' "$LOG_FILE") 
      TOTAL_ERROS=$(grep -c "ERROR" "$LOG_FILE") 
      IP_UNICOS=$(awk '{print $2}' "$LOG_FILE" | sort | uniq | wc -l)
      IP_FREQUENTE=$(awk '{print $2}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}') 
      NUM_DOWNLOADS=$(grep -c "DOWNLOAD" "$LOG_FILE") 
       
      { 
        echo "Relatório do Log:"
        echo "----------------"
        echo "Total de linhas: $TOTAL_LINHAS" 
        echo "Total de erros: $TOTAL_ERROS"
        echo "IPs únicos: $IP_UNICOS" 
        echo "IP mais frequente: $IP_FREQUENTE" 
        echo "Número de downloads: $NUM_DOWNLOADS"
      }  > relatorio.txt
       echo "relatorio criado em relatorio.txt" 
       ;;
    *) echo "opcao invalida" 
        ;; 
  esac 
 done
