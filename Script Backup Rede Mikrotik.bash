#!/bin/bash
#Define váriaveis do ambiente, no caso a data que será usada como parte do nome para criação dos diretórios.
data=$(date +%d-%m-%Y)

#Cria os Diretórios do dia em questão
		mkdir -p /home/Backup/Mikrotik/$data

#Modifica as permissões Diretório para que usuários do grupo possam acessar	os backups
	chmod 760 /home/Backup/Mikrotik/$data

#Acessa o Dispositivo e gera um arquivo de Backup padrão
	for i in $(cat /opt/Backup_Script/hostmikrotik.list) ; do
	ssh bkp@$i /system backup save name=1$i--$data.backup
	done

#Acessa o Dispositivo e gera um script de configuração para qualquer dispositivo 
	for i in $(cat /opt/Backup_Script/hostmikrotik.list) ; do
	echo ""
	echo ""
	ssh bkp@$i /export file=1$i--$data.rsc
	done

#Acessa o Dispositivo e copia o arquivo .backup da sua file para o servidor
	for i in $(cat /opt/Backup_Script/hostmikrotik.list) ; do
	echo ""
	echo ""
	sftp bkp@$i:1$i--$data.backup
	done

#Acessa o Dispositivo e copia o arquivo .src (script) da sua file para o servidor
	for i in $(cat /opt/Backup_Script/hostmikrotik.list) ; do
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
