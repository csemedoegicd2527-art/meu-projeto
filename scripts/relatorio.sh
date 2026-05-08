#!/bin/bash
#LOG_FILE="10000.log"
LOG_FILE=$1
USER_FILTER=$2
ACTION_FILTER=$3

# validar ficheiro

if [ ! -f "$LOG_FILE" ]; then
 echo "Ficheiro não existe"

 exit 1
fi
echo "ficheiro encontrado"


# Filtro por utilizador
# se for passado um argumento user=userX,o script vai fitrar o ficheiro.
# e usar apenas as linhas desse utilizador para gerar o relatorio.
# se nao for passado nenhum user ,o script usa o ficheiro inteiro.
# FILTERED_FILE É UM ficheiro temporario que guarda apenas os dados que queremos analisar
# Em vez de alterar o ficheiro original original de logs , o scripts cria um novo ficheiro chamado filtred.log
#se o utilizador escolher um filtro  por exemplo user=user 13 esse ficheiro vai conter apenas as linhas desse utilizador.


FILTERED_FILE="filtered.log"

if [ -n "$USER_FILTER" ]; then
   USER=$(echo "$USER_FILTER" | cut -d "=" -f2)
   grep "$USER" "$LOG_FILE" > "$FILTERED_FILE"

else
   cp "$LOG_FILE" "$FILTERED_FILE"
fi


# filtro por tipo de ação(dowland,upload,error,login
if [ -n "$ACTION_FILTER" ]; then 
   ACTION=$(echo "$ACTION_FILTER" | cut -d "=" -f2)
   grep "$ACTION" "$FILTERED_FILE" > temp.log
   FILTERED_FILE="temp.log"
fi


# Funçoes criadas apartir das funcionalidades
# As funcoes usam o ficheiro FILTERED_FILE para fazer calculos.
total_linhas() {
  wc -l "$FILTERED_FILE"
}

total_erros() {
 grep ERROR "$FILTERED_FILE" | wc -l 

}

ips_unicos() {
 cut -d " " -f2 "$FILTERED_FILE" | sort | uniq | wc -l 

}

top_ip() {
  cut -d " " -f2 "$FILTERED_FILE"| sort | uniq -c | sort -nr | head -n1 | awk '{print $2}'

}
downloads() {
  grep DOWNLOAD "$FILTERED_FILE" | wc -l
}
top5_ips() {
 awk '{print $2}' "$FILTERED_FILE" | sort | uniq -c | sort -nr | head -n 5
}

gerar_relatorio() {

      DATA=$(date +%F)
      ARQUIVO="relatorio_$DATA.txt"
      
      
      
      TOTAL_LINHAS=$(awk 'END {print NR}' "$FILTERED_FILE" ) 
      TOTAL_ERROS=$(grep -c "ERROR" "$FILTERED_FILE" ) 
      IP_UNICOS=$(awk '{print $2}' "$FILTERED_FILE" | sort | uniq | wc -l)
      IP_FREQUENTE=$(awk '{print $2}' "$FILTERED_FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}') 
      NUM_DOWNLOADS=$(grep -c "DOWNLOAD" "$FILTERED_FILE") 
      
      UPLOADS=$(grep -c "UPLOAD" "$FILTERED_FILE")
      ERROS_500=$(awk '$4=="ERROR" && $6=="500"' "$FILTERED_FILE" | wc -l)
      
      USER_ATIVO=$(awk '{print $2}' "$FILTERED_FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
      RECURSO=$(awk '{print $5}' "$FILTERED_FILE" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
      TOP5_IPS=$(awk '{print $2}' "$FILTERED_FILE" | sort | uniq -c | sort -nr | head -n 5)
      {
        echo "Relatório do Log:"
        echo "----------------"
        echo "Total de linhas: $TOTAL_LINHAS" 
        echo "Total de erros: $TOTAL_ERROS"
        echo "IPs únicos: $IP_UNICOS" 
        echo "IP mais frequente: $IP_FREQUENTE" 
        echo "Número de downloads: $NUM_DOWNLOADS"
      
        echo "Uploads: $UPLOADS"
        echo "Erros 500: $ERROS_500"
        echo "Utilizador mais ativo: $USER_ATIVO"
        echo "Recurso mais acedido: $RECURSO"
        echo "Top 5 IPs:"
        echo "$TOP5_IPS"
      }  > "$ARQUIVO"
        echo "relatorio criado em $ARQUIVO" 
}     

gerar_relatorio
exit 0







