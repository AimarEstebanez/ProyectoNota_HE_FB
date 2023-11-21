#!/bin/bash
#Autor: Aimar Estebanez Gaston
#bash-version:5.2.15(1)-release
#Scrip para la ejecucion de diferentes herramientas.
#FUNCIONES:

#Control de nombre de usuarios
#Problema, no muestra nada si el usuario no existe, si hago un echo lo devuelve en el return
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

#Menu diccionario
function fun_menu_dic(){
	echo 			"Eleccion de Diccionario"
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} password.lst en /usr/share/john."
	echo -e "${CIAN}2.${ND} rockyou en /home/$1."
	echo -e "${CIAN}3.${ND} Otro en otra localizacion."
	echo -e "${ROJO}4.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}

#Menu Modificacion de usuarios
function fun_menu_usu_mod(){
	clear
	fun_gen_menu "Modificar usuarios"
	echo -e "${CIAN}1.${ND} Nombre de usuario."	
	echo -e "${CIAN}2.${ND} Cambiar Home."
	echo -e "${CIAN}3.${ND} Fecha de caducidad."
	echo -e "${CIAN}4.${ND} Añadir a grupos."	
	echo -e "${CIAN}5.${ND} Contrasena."	
	echo -e "${CIAN}6.${ND} Shell."	
	echo -e "${CIAN}7.${ND} Bloquear."	
	echo -e "${CIAN}8.${ND} Desbloquear."	
	echo -e "${ROJO}9.${ND} Volver atras."
	echo -e "${AZUL}========================${ND}"
}
#Menu Gestion de usuarios
function fun_menu_usu (){
	clear
	fun_gen_menu "Gestion de usuarios"
	echo -e "${CIAN}1.${ND} Crear usuario."
	echo -e "${CIAN}2.${ND} Editar Usuario."
	echo -e "${CIAN}3.${ND} Eliminar usuario."	
	echo -e "${ROJO}4.${ND} Volver atras."
	echo -e "${AZUL}========================${ND}"
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
			clear
			fun_gen_menu "ATAQUE DE DICCIONARIO "
			
			read -p "Introduzca el HASH: " vhash
			#Creacion de fichero temporal
			echo $vhash > temp.txt  #Fichero temporal
			
			#Comprobacion del tipo de encriptacion
			hashid -m $vhash
			
			#Control valor variable formato
			read -p "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
			while [[ "$formato" != "md5" && "$formato" != "sha1" && "$formato" != "sha256" && "$formato" != "sha512" ]]
			do
				echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
				read -p "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
			done 
			
			i_dic=0
			while true
			do
				clear
				fun_gen_menu "ATAQUE DE DICCIONARIO"
				fun_menu_dic "$(whoami)"
				read -p "Indique el diccionario que desea emplear: " i_dic
				
				case $i_dic in 
					1)#Password.lst
						if [[ -e /usr/share/john/password.lst ]]
						then
							pathdiccionario="/usr/share/john/password.lst"
							break
						else
							echo "ERROR: No se encuentra el diccionario"
							pause 0.5
							break
						fi
					;;
					2)#rockyou.txt
						if [[ -e /home/$(whoami)/rockyou.txt ]]
						then
							pathdiccionario="/home/$(whoami)/rockyou.txt"
							break
						else
							echo "ERROR: No se encuentra el diccionario"
							pause 0.5
							break
						fi
					;;
					3)#especifica la ruta
						read -p "Introduzca la ruta del diccionario: " pathdiccionario
						until [[ -e $pathdiccionario ]]; do
							read -p "Introduzca la ruta del diccionario: " pathdiccionario
						done
						break
					;;
					4)
						break
					;;
					*)
						echo "Opcion no valia"
						sleep 0.5
					;;
				esac
			done
			#Ataque de diccionario
			john --wordlist=$pathdiccionario --format=Raw-$formato temp.txt 2>&1>/dev/null
			resultado=$(john --show temp.txt --format=Raw-$formato | cut -d ":" -f2) 
			
			#Resultado
			echo "La contrasenia es: $resultado" > $(date '+%F-%H-%S')_resultado.txt
			echo "La contrasenia es: $resultado"
			rm -f temp.txt 2>&1>/dev/null
			#827ccb0eea8a706c4c34a16891f84e7b
			#311020666a5776c57d265ace682dc46d

			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		4) #Fingerprint
			#Menu fingerprint
			fun_gen_menu "Fingerprint"
			read -p "Especifique el objetivo: " objetivo_nmap
			clear
			
			#Llamada a menu
			fun_gen_menu "Fingerprint"
						
			#Control varible parametros
			read -p "Introduzca el algoritmo [ sX, sC, sV  o sN ]: " parametros
			while [[ "$parametros" != "sX" && "$parametros" != "sC" && "$parametros" != "sV" && "$parametros" != "sN" ]]
			do
				echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
				read -p "Introduzca el algoritmo [ sX, sC, sV  o sN ]: " parametros
			done 
			
			echo "Puertos abiertos de la IP: $objetivo_nmap"
			echo "PORT     STATE SERVICE      VERSION"
			#Ejecucion comando nmap
			sudo nmap -$parametros $objetivo_nmap | egrep -e [0-9][0-9]*/ 
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		5) #Footprinting			
			#Bucle while para el submenu 
			i_exif=0
			while true
			do
				fun_exif
				#While para eleccion de opciones
				read -p $'\e[33mElige una opcion\e[0m: ' i_exif
				while [[ $i_exif -lt 1 && $i_exif -gt 4 ]]
				do
					echo "ERROR: OPCION NO CONTEMPLADA"
					read -p $'\e[33mElige una opcion\e[0m: ' i_exif
				done
				#Case para las funcionalidades del menu
				case $i_exif in
					1)#Metadatos de la ruta actual
						echo "Mostrando los metadatos de los archivos de la ruta actual:"
						exiftool *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)#Metadatos de la ruta especifica
						read -p "ESpecifique la ruta de la cual quiera obterner los metadatos: " ruta_metadatos
						exiftool $ruta_metadatos/ *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)#Metadatosm de fichero especifico
						read -p "Especifique el fichero del cual quiera obterner los metadatos: " fichero_metadatos
						exiftool $fichero_metadatos			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)#TheHarvester
						echo "4"
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
						
					;;
					5)#Salida del submenu
						break
					;;
					*)
						echo "ERROR: OPCION NO CONTEMPLADA"
						sleep 0.5
					;;
				esac
			done	
		;;
		
		6) #Gestion de usuarios
			#While para el submenu de usuarios
			i_usu=0
			while true
			do
				fun_menu_usu
				read -p $'\e[33mElige una opcion\e[0m: ' i_usu
				
				#Control de opciones
				while [[ $i_usu -lt 1 && $i_usu -gt 4 ]]
				do
					/dev/null
				done
				
				case $i_usu in
					1)#Creacion de usuario
						fun_gen_menu "Ceracion de usuario"
					
						read -p "Introduzca el nombre de usuario: " nombreusuario
						read -sp "Introduzca la contrasenia: " contrasena
						echo " "
						read -sp "Repita la contrasenia: " contrasena2
						
						#Comprobacion contrasenia
						if [ "$contrasena" = "$contrasena2" ]
						then 
							contrasena=$(openssl passwd $contrasena)
							sudo useradd $nombreusuario --password $contrasena					
						else
							echo "Las contrasenas no coinciden"
						fi
					
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)#Modificar usuario
						fun_gen_menu "modifica usuario"
						i_usu_mod=0
						while true
						do 
							fun_menu_usu_mod
							read -p $'\e[33mElige una opcion\e[0m: ' i_usu_mod
							
							case $i_usu_mod in
							1) #Cambio de nombre 
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreviejo
								
								#Comprovacion si usuario existe
								nombreviejo=$(fun_ctrl_usu "$nombreviejo")
								read -p "Introduzca el nuevo nombre de usuario: " nuevonombre
								
								sudo usermod -l $nuevonombre $nombreviejo
								echo "NOMBRE DE USUARIO ACTUALIZADO"
				
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							2)#Cambiar HOME
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Comprovacion directorio existe
								read -p "Introduzca la ruta del nuevo home del usuario: " nuevohome
								until [[ -n $nuevohome && -d $nuevohome ]]; do
									read -p "Introduzca la ruta del nuevo home del usuario: " nuevohome
								done
								
								#Cambio
								sudo usermod --home $nuevohome $nombreusu
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							3)#Fecha caducidad
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Comprovacion fecha en formato YYYY-MM-DD
								read -p "Introduzca la nueva fecha de caducidad en formato YYYY-MM-DD: " fechacad
								if [[ $fechacad =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$fechacad" >/dev/null 2>&1
								then
									echo "Modificando usuario: "
									sudo usermod --expiredate $fechacad $nombreusu
								else 
									echo "Fecha no valida o en formato incorrecto"
								fi
								#comprobacion con chage -l
								
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							4)#Añadir a grupo
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								read -p "Introduzca los grupos a los que quiere añadir: " grupos 
								sudo usermod -a --groups $grupos $nombreusu
								
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							5)#Contraseña
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Peticion de contraseñas a usuario	
								read -sp "Introduzca la contrasenia: " contrasena
								echo " "
								read -sp "Repita la contrasenia: " contrasena2
								echo ""
								
								#Comprobacion contrasenia
								if [ "$contrasena" = "$contrasena2" ]
								then 
									contrasena=$(openssl passwd $contrasena)
									sudo usermod --password $contrasena $nombreusu					
								else
									echo "Las contrasenas no coinciden"
								fi
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							6)#Cambio de shell

								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Comprovacion de shell correcta
								read -p "Introduzca la nueva shell para el usuario [/bin/bash, /bin/sh, /bin/zsh]: " nuevashell
								while [[ "$nuevashell" != "/bin/bash" && "$nuevashell" != "/bin/sh" && "$nuevashell" != "/bin/zsh" ]]
								do
									echo -e "${ROJO}Opcion incorrecta, introduzca una de los especificados${ND}"
									read -p "Introduzca la nueva shell para el usuario [/bin/bash, /bin/sh, /bin/zsh]: " nuevashell
								done 
								
								sudo usermod --shell $nuevashell $nombreusu 
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							7)#Bloquear	
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								sudo usermod --lock $nombreusu
								
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							8)#Desbloquear	
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								sudo usermod --unlock $nombreusu
						
								# Confirmacion para avanzar
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
					;;
					3)#Eliminacion de usuario
						fun_gen_menu "Eliminar usuario"
						read -p "Introduzca el nombre de usuario que desea eliminar: " nombreusuario
						
						#Confirmacion de eliminacion de usuario
						read -p "CONFIRMACION: realmente quiere eliminar el usuario? (s/n)" confirmacion
						if [ "$confirmacion" = "s" ] || [ "$confirmacion" = "S" ]
						then 
							sudo userdel $nombreusuario
						else
							echo "Operacion abortada"
						fi
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
