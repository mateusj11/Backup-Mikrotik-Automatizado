#!/bin/bash
#Define váriaveis do ambiente, no caso a data que será usada como parte do nome para criação dos diretórios.
data=$(date +%d-%m-%Y)
#Define a variavel do diretório principal de Backups
direoriobackups=/home/Backup/Mikrotik/$data
#Define a variavel do diretório da lista de hosts Mikrotik para Backup
listahostsmikrotik=/opt/Backup_Script/hostmikrotik.list

#Cria os Diretórios do dia em questão
	mkdir -p $direoriobackups

#Modifica as permissões Diretório para que usuários do grupo possam acessar	os backups
	chmod 760 $direoriobackups

#Acessa o Dispositivo e gera um arquivo de Backup padrão do Mikrotik com o nome sendo seu endereço IP
	for i in $(cat $listahostsmikrotik) ; do
	ssh bkp@$i /system backup save name=1$i--$data.backup
	done

#Acessa o Dispositivo e gera um script de configuração para qualquer dispositivo 
	for i in $(cat $listahostsmikrotik) ; do
	echo ""
	echo ""
	ssh bkp@$i /export file=1$i--$data.rsc
	done

#Acessa o Dispositivo e copia o arquivo .backup da sua file para o servidor
	for i in $(cat $listahostsmikrotik) ; do
	echo ""
	echo ""
	sftp bkp@$i:1$i--$data.backup
	done

#Acessa o Dispositivo e copia o arquivo .src (script) da sua file para o servidor
	for i in $(cat $listahostsmikrotik) ; do
	echo ""
	echo ""
	sftp bkp@$i:1$i--$data.rsc
	done

#Move os arquivos para a pasta correspondente do dia xxx
	###  Arquivos .backup  ###
	mv *.backup $direoriobackups

	###  Arquivos .rsc  ###
	mv *.rsc $direoriobackups
	echo "Os backups dos dispositivos encontram-se no diretório $direoriobackups"
	echo ""
	echo "Backup De Dispositivos Concluido"
	echo ""
	echo "Parabéns por manter sua base de Backups Atualizada x)"

## Echo = Apenas mostra informaçes do processo para o usuário
