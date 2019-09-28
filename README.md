# Backup Mikrotik Automatizado
##Alterado por Matheus J, ultilizando como base um código encontrado na internet em:
#https://thiagoferreira.net/index.php/2015/06/17/backup-automatico-de-mikrotik-em-maquina-com-linux-backup-local/#
#Todo o crédito da ideia Inicial a Thiago Ferreira por postar na internet seu código para que a todas pudessem ultilizar.
#Paz

##Inicio##
	O código tem como objeitvo inicial gerar backups de Roteadores Mikrotik (http://mikrotik.com) de forma automaziada,
no qual o administrador de redes tenha apenas que adicionar o usuário 'bkp' em uma nova rb, e adicionar seu ip no arquivo
de endereços que o script usa como base.

##Ambiente##
	Para a homologação desse script ele foi testado ultilizando os seguintes recursos:
*Servidor de Backup*
• Debian 8.5 
• 2GB de Ram
• 50 GB de HD
• VM Emulada pelo VMWare Pro

*Routerboar Mikrotik*
• RouterBOARD 941-2nD
• Firmware 3.29
• RouterOS v6.43.4
• Arquitetura smips

##1ª Passo##
	Para o inicio, deve ser necessário criar o usuário 'bkp' em sua Mikrotik, para isso pode se ultilizar o ambiente 
gráfico disponibilizado pelo Winbox, ou colar o comando abaixo no terminal do router:
	
	/user add name=bkp password=SUASENHAAQUI comment="Usuario de Backup do Sistema" group=full
	
	Vale ressaltar que a permissão do usuário deve ser full para que o mesmo tenha os privilégios necessários para gerar os arquivos de backup.
	
##2ª Passo##
	Em seu servidor Linux que vai ser adicionado o script, baixe o mesmo e o mova para o diretório:
		/opt/Backup_Script/
	Esse foi o diretório usado como base para o desenvolvimento do script.
	
##3ª Passo##
	Caso você ainda não possua instalado, instale o serviço ssh em seu servidor, em distribuições Debian pode ser usado com permissões de root, o seguinte comando:
		apt install ssh -y
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

