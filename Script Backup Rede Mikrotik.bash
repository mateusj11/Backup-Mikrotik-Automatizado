#!/bin/bash
data=$(date +%d-%m-%Y)

#Cria os Diretórios do dia em questão
		mkdir -p /var/www/html/bkp/mikrotik/$data

#Modifica as permissões DiretÃ³rio para que todos possam acessar	
	chmod 770 /var/www/html/bkp/mikrotik/$data

#Acessa o Dispositivo e gera um arquivo de Backup padrão
	for i in $(cat /var/www/html/bkp/script/host.list) ; do
	ssh bkp@$i /system backup save name=1$i--$data.backup
	done

#Acessa o Dispositivo e gera um script de configuração para qualquer dispositivo 
	for i in $(cat /var/www/html/bkp/script/host.list) ; do
	echo ""
	echo ""
	ssh bkp@$i /export file=1$i--$data.rsc
	done

#Acessa o Dispositivo e copia o arquivo .backup da sua file para o servidor
	for i in $(cat /var/www/html/bkp/script/host.list) ; do
	echo ""
	echo ""
	sftp bkp@$i:1$i--$data.backup
	done

#Acessa o Dispositivo e copia o arquivo .src (script) da sua file para o servidor
	for i in $(cat /var/www/html/bkp/script/host.list) ; do
	echo ""
	echo ""
	sftp bkp@$i:1$i--$data.rsc
	done

#Move os arquivos para a pasta correspondente do dia xxx
	###  Arquivos .backup  ###
	mv *.backup /var/www/html/bkp/mikrotik/$data/

	###  Arquivos .rsc  ###
	mv *.rsc /var/www/html/bkp/mikrotik/$data/
	echo "Os backups dos dispositivos encontram-se no diretório /var/www/html/bkp/mikrotik/"
	echo ""
	echo "Backup De Dispositivos Concluido"

## Echo = Apenas mostra informaçes do processo para o usuário
