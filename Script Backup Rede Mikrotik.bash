#!/bin/bash
	#Define váriaveis do ambiente, no caso a data que será usada como parte do nome para criação dos diretórios.
		data=$(date +%d-%m-%Y)
	
	#Define a variavel do diretório principal de Backups
		direoriobackups=/home/Backup/Mikrotik/$data
	
	#Define a variavel do diretório da lista de hosts Mikrotik para Backup
		listahostsmikrotik=/opt/Backup_Script/hostmikrotik.list
	
	#Define a variavel porta ssh
		portassh=2222




	#Cria os Diretórios do dia em questão
		mkdir -p $direoriobackups

	#Modifica as permissões Diretório para que usuários do grupo possam acessar	os backups
		chmod 760 $direoriobackups

	#Acessa o Dispositivo e gera um arquivo de Backup padrão do Mikrotik com o nome sendo seu endereço IP
		for i in $(cat $listahostsmikrotik) ; do
			ssh -p $portassh bkp@$i /system backup save name=Backup_$i--$data.backup &> /dev/null
			echo " Gerando Backup do dispositivo $i" 
		done

	#Acessa o Dispositivo e gera um script de configuração para qualquer dispositivo 
		echo ""
		for i in $(cat $listahostsmikrotik) ; do
				ssh -p $portassh bkp@$i /export file=Script_$i--$data.rsc &> /dev/null
				echo " Gerando Script do dispositivo $i"
		done

	#Acessa o Dispositivo e copia o arquivo .backup da sua file para o servidor
		for i in $(cat $listahostsmikrotik) ; do
			echo "Copiando Backup_$i--$data.backup para o Servidor"
			sftp -P $portassh bkp@$i:Backup_$i--$data.backup &> /dev/null
			echo "Deletando arquivo Backup_$i--$data.backup do Roteador"
			ssh -p $portassh bkp@$i /file remove Backup_$i--$data.backup &> /dev/null
		done

	#Acessa o Dispositivo e copia o arquivo .src (script) da sua file para o servidor
		for i in $(cat $listahostsmikrotik) ; do
			echo "Copiando Script_$i--$data.rsc para o Servidor"
			sftp -P $portassh bkp@$i:Script_$i--$data.rsc &> /dev/null
			echo "Deletando arquivo Script_$i--$data.rsc do Roteador"
			ssh -p $portassh bkp@$i /file remove Script_$i--$data.rsc &> /dev/null
		done

	#Move os arquivos para a pasta correspondente do dia xxx
		###  Arquivos .backup  ###
			echo "Movendo Backups para $direoriobackups"
			mv *.backup $direoriobackups

		###  Arquivos .rsc  ###
			echo "Movendo Scripts para $direoriobackups"
			mv *.rsc $direoriobackups
			echo ""
			echo "Todos os backups dos dispositivos encontram-se no diretorio $direoriobackups"
			echo ""
			echo "Backup Concluido"
			echo ""
			echo "Parabens por manter sua base de Backups Atualizada x)"
			echo ""
	## Echo = Apenas mostra informaçes do processo para o usuário