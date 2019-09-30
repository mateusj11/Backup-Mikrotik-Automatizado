#!/bin/bash
	#Define váriaveis do ambiente, no caso a data que será usada como parte do nome para criação dos diretórios.
		data=$(date +%d-%m-%Y)
	#Define a variavel do diretório principal de Backups
		direoriobackups=/home/Backup/Mikrotik/$data
	#Define a variavel do diretório da lista de hosts Mikrotik para Backup
		listahostsmikrotik=/opt/Backup_Script/hostmikrotik.list
	#Define a variavel porta ssh
		portassh=2222
	#Define nome do arquivo .backup que será salvo
		nomebackup=Backup_$i--$data.backup
	#Define nome do arquivo .rsc (script) do Mikrotik
		nomerscscript=Script_$i--$data.rsc
	#Define Comando do Mikrotik para Save do Backup juntamente com o nome
		backupmikrotik="/system backup save name=$nomebackup"
	#Define Comando do Mikrotik para Save do Backup juntamente com o nome
		scriptmikrotik="/export file=$nomerscscript"


	#Cria os Diretórios do dia em questão
		echo "Iniciando rotina do dia $data "
		mkdir -p $direoriobackups
	#Limpa arquivo de log sucess e fail
	echo "Os seguintes dispositivos tiveram sucesso na execucao da rotina de Backup" > sucess.txt
	echo "Os seguintes dispositivos tiveram falha na execucao da rotina de Backup" > fail.txt
	
	#Modifica as permissões Diretório para que usuários do grupo possam acessar	os backups
		chmod 760 $direoriobackups
	echo "Iniciando rotina de Backups"
		for i in $(cat $listahostsmikrotik) ; do
			if ssh -p $portassh bkp@$i $backupmikrotik &> /dev/null;
				then
					echo ""
					echo "$i - Gerado arquivo de Backup" >> sucess.txt
					if sftp -P $portassh bkp@$i:$nomebackup &> /dev/null;
						then
							if ssh -p $portassh bkp@$i /file remove $nomebackup &> /dev/null;
							then
								echo ""
								echo "$i - Arquivo deletado do roteador" >> sucess.txt
								if mv *.backup $direoriobackups;
									then
										echo ""
										echo "O Backup de $i se encontra em $direoriobackups" 
									else
										echo ""
										echo "$i - Falha ao mover backup para $direoriobackups" >> fail.txt
								fi
							else
								echo ""
								echo "$i - Falha ao tentar remover Backup_$i--$data.backup do Roteador" >> fail.txt
							fi
						else
							echo ""
							echo "$i - Falha ao transferir o arquivo Backup_$i--$data.backup para o servidor " >> fail.txt
					fi
					
						else
				echo ""
				echo "$i - Falha ao gerar Backup" >> fail.txt
			 
			fi
		done
	varfail=$(wc -l fail.txt | cut -c1)
		if  [ $varfail -gt 1 ]
		then
			cp fail.txt $direoriobackups/Falha-$data.txt
			echo "No $direoriobackups se encontra um arquivo com os dispositivos que falharam"
		else
			echo "Ops" > /dev/null
	fi
	echo ""
	cat sucess.txt
	echo ""
	cat fail.txt
	echo ""
	echo "Fim da Rotina de Backups"
	echo ""
	echo "Parabens por manter sua base de Backups Atualizada x)"
	echo ""