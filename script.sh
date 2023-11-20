#!/bin/bash
#Autor: Aimar Estebanez Gaston
#bash-version:5.2.15(1)-release
#Scrip para la ejecucion de diferentes herramientas.
#FUNCIONES:
#Control de nombre de usuarios
function fun_ctrl_usu(){
	local nombre=$1
	while true; do
		#Comprueba si usuario existe
		if id "$nombre" >/dev/null 2>&1; then
			echo $nombre
			break
		else
			read nombre
		fi
	done
}
#Menu Modificacion de usuarios
function fun_menu_usu_mod(){
	clear
	fun_gen_menu "Modificar usuarios"
	echo -e "${CIAN}1.${ND} Nombre de usuario."	
	echo -e "${CIAN}2.${ND} Cambiar Home."
	echo -e "${CIAN}3.${ND} Fecha de caducidad."
	echo -e "${CIAN}4.${ND} Añadir o eliminar grupos."	
	echo -e "${CIAN}5.${ND} Contrasena."	
	echo -e "${CIAN}6.${ND} Shell."	
	echo -e "${CIAN}7.${ND} Bloquear."	
	echo -e "${CIAN}8.${ND} Desbloquear."	
	echo -e "${ROJO}9.${ND} Volver atras."
}
#Menu Gestion de usuarios
function fun_menu_usu (){
	clear
	fun_gen_menu "Gestion de usuarios"
	echo -e "${CIAN}1.${ND} Crear usuario."
	echo -e "${CIAN}2.${ND} Editar Usuario."
	echo -e "${CIAN}3.${ND} Eliminar usuario."	
	echo -e "${ROJO}4.${ND} Volver atras."
}

#Menu exiftool
function fun_exif (){
	clear
	echo "============================="
	echo -e " ${ROJO}Metadatos con exiftool${ND} "
	echo "============================="
	echo -e "${CIAN}1.${ND} Metadatos de los ficheros de la ruta acutal."
	echo -e "${CIAN}2.${ND} Metadatos de la ruta especifica."
	echo -e "${CIAN}3.${ND} Metadatos de fichero especifico."
	echo -e "${CIAN}4.${ND} The Harvester."
	echo -e "${CIAN}5.${ND} Volver atras."
}

#Menu general
function fun_gen_menu (){
	echo -e "${AZUL}========================${ND}"
	echo -e "----- ${ROJO}$1${ND} ------"
	echo -e "${AZUL}========================${ND}"
}

#Menu principal
 function fun_menu (){	 
	clear
	#Parte bonita menu
	figlet -f Double menu
	echo -e "${AZUL}========================${ND}"
	echo -e "--------- ${AZUL}MENU${ND} ---------"
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} Saludar."
	echo -e "${CIAN}2.${ND} Buscador de ficheros."
	echo -e "${CIAN}3.${ND} Ataque de diccionario."
	echo -e "${CIAN}4.${ND} Fingerprinting."
	echo -e "${CIAN}5.${ND} Footprinting."
	echo -e "${CIAN}6.${ND} Gestion de usuarios."
	echo -e "${CIAN}7.${ND} Ataque con metasploit."
	echo -e "${ROJO}8. Salir.${ND}"
	echo -e "${AZUL}========================${ND}"
}

#Variables para colorear
NARANJA='\033[0;33m'
AZUL='\033[0;34m'
CIAN='\033[0;36m'
ROJO='\033[0;31m'
ND='\033[0m' # nada	


#Script:

#Comprobacion Instalacion de paquetes

#Funcionalidad Principal

#Bucle principal del programa
i=0
while true
do
	fun_menu
	
	#Bucle control valor variable i dentro de parametros
		read -p $'\e[33mElige una opcion\e[0m: ' i
	while [[ $i -lt 1 && $i -gt 8 ]]
	do 
		/dev/null
	done
	
	case $i in
		1) #Saludar
			# Elige una de las dos condiciones de manera aleatoria	
			if (( RANDOM % 2 )); 
			then 
				figlet -f Fuzzy Hola campeon
			else 
				figlet -f maxiwi Deja de tocar pesao
			fi
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		2) #Busqueda de ficheros
			
			#Busqueda con find
			echo "BUSCANDO CON FIND: "
			read -p "Intrduzca el nombre del fichero que desea encontrar: " nombrefichero
			find / -name *$nombrefichero* 2>/dev/null
			
			#Busqueda con ...
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		3) #Ataque de diccionario
			
			#Añadir Menu Diccionario
			echo "ATAQUE DE DICCIONARIO: "
			
			read -p "Introduzca el HASH: " vhash
			echo $vhash > temp.txt  #Fichero temporal
			hashid -m $vhash
			
			#Control valor variable formato
			read -p "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
			while [[ "$formato" != "md5" && "$formato" != "sha1" && "$formato" != "sha256" && "$formato" != "sha512" ]]
			do
				echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
				read -p "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
			done 
			
			#Ataque de diccionario
			john --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-$formato temp.txt 2>&1>/dev/null
			resultado=$(john --show temp.txt --format=Raw-$formato | cut -d ":" -f2) 
			
			#Resultado
			echo "La contrasenia es: $resultado" > $(date '+%F-%H-%S')_resultado.txt
			echo "La contrasenia es: $resultado"
			rm -f temp.txt 2>&1>/dev/null
			#827ccb0eea8a706c4c34a16891f84e7b
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		4) #Fingerprint
			fun_gen_menu "Fingerprint"
			read -p "Especifique el objetivo: " objetivo_nmap
			clear
			
			#Control varible parametros
			fun_finger
			read -p "Introduzca el algoritmo [ sX, sC, sV  o sn ]: " parametros
			while [[ "$parametros" != "sX" && "$parametros" != "sC" && "$parametros" != "sV" && "$parametros" != "sn" ]]
			do
				echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
				read -p "Introduzca el algoritmo [ sX, sC, sV  o sn ]: " parametros
			done 
			sudo nmap -$parametros $objetivo_nmap | egrep -e [0-9][0-9]*/ | cut -d " " -f1,2,4
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		5) #Footprinting			
			i_exif=0
			while true
			do
				fun_exif
				read -p $'\e[33mElige una opcion\e[0m: ' i_exif
				while [[ $i_exif -lt 1 && $i_exif -gt 4 ]]
				do
					echo "ERROR: OPCION NO CONTEMPLADA"
					read -p $'\e[33mElige una opcion\e[0m: ' i_exif
				done
				case $i_exif in
					1)
						echo "Mostrando los metadatos de los archivos de la ruta actual:"
							exiftool *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)
					
						read -p "ESpecifique la ruta de la cual quiera obterner los metadatos: " ruta_metadatos
						exiftool $ruta_metadatos/ *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)
						read -p "ESpecifique la ruta de la cual quiera obterner los metadatos: " fichero_metadatos
						exiftool $fichero_metadatos			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)
						echo "4"
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
						
					;;
					5)
						break
					;;
					*)
						echo "ERROR: OPCION NO CONTEMPLADA"
					sleep 0.5
					;;
				esac
			done
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		6) #Gestion de usuarios
			i_usu=0
			while true
			do
				fun_menu_usu
				read -p $'\e[33mElige una opcion\e[0m: ' i_usu
				
				while [[ $i_usu -lt 1 && $i_usu -gt 4 ]]
				do
					echo ""
				done
				
				case $i_usu in
					1)
						echo "crea usuario"
						read -p "Introduzca el nombre de usuario: " nombreusuario
						read -p "Introduzca la contrasenia: " contrasena
						contrasena=$(openssl passwd $contrasena)
						echo $contrasena
						sudo useradd $nombreusuario --password $contrasena					
						# Confirmacion para avanzarsudo
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)
						echo "modifica usuario"
						i_usu_mod=0
						while true
						do 
							fun_menu_usu_mod
							read -p $'\e[33mElige una opcion\e[0m: ' i_usu_mod
				
							while [[ $i_usu_mod -lt 1 && $i_usu_mod -gt 4 ]]
							do
							echo ""
							done
							
							case $i_usu_mod in
							1)
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreviejo
								
								nombreviejo=$(fun_ctrl_usu "$nombreviejo")
								read -p "Introduzca el nuevo nombre de usuario: " nuevonombre
								nuevonombre=$(fun_ctrl_usu "$nuevonombre")
								sudo usermod -l $nuevonombre $nombreviejo
								echo "NOMBRE DE USUARIO ACTUALIZADO"
				
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							2)
								echo -e "${CIAN}2.${ND} Cambiar Home."
								
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							3)
								echo -e "${CIAN}3.${ND} Fecha de caducidad."
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							4)
								echo -e "${CIAN}4.${ND} Añadir o eliminar grupos."	
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							5)
								echo -e "${CIAN}5.${ND} Contrasena."
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							6)
								echo -e "${CIAN}6.${ND} Shell."	
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							7)
								echo -e "${CIAN}7.${ND} Bloquear."	
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							8)
								echo -e "${CIAN}8.${ND} Desbloquear."	
								# Confirmacion para avanzarsudo
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							9)
								break
							;;
							*)
								echo "ERROR: OPCION NO CONTEMPLADA"
								sleep 0.5
							;;
							esac
						done
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)
						echo "Elimina usuario"
						read -p "Introduzca el nombre de usuario que desea eliminar: " nombreusuario
						sudo userdel $nombreusuario
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)
						break
					;;
					*)
						echo "ERROR: OPCION NO CONTEMPLADA"
						sleep 0.5
					;;
				esac
			done		
		;;
		
		7) #Ataque con metasploit
			echo "7"
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		8) #Salir
			exit
		;;
		
		*)
			echo "Opcion no valida"
			sleep 0.5
		;;
	esac
done
