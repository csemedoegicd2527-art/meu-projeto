
#!/bin/bash

DATA=$(date +%F)
ARQUIVO="relatorio_$DATA.txt"
./relatorio.sh 10000.log

echo "Relatório gerado automaticamente: $ARQUIVO"
