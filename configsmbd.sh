#!/bin/bash

mostrar_datos_red() {
	echo "Datos de red del equipo:"
	ip addr show | grep -E "inet" |grep -E "\b(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(?:3[0-2]|[12]?[0-9])\b brd" | cut -d" " -f6

}
estado_servicio(){
	echo "El estado del servicio actualmente es: "
	systemctl status smbd | grep -E "Active: " | cut -d" " -f7-

}
# Función para instalar el servicio Samba en un equipo remoto
instalacion_remoto() {
    read -p "Ingrese el nombre de usuario del equipo remoto: " user
    read -p "Ingrese la dirección IP del equipo remoto: " ip
    read -p "Contraseña sudo: " sudo

    echo "Instalando el servicio Samba en el equipo remoto..."
    ssh "$user@$ip" "echo $sudo | sudo -S apt update && echo $sudo | sudo -S apt install -y samba && echo $sudo | sudo -S systemctl status smbd" < /dev/null
}
eliminar_servicio() {
    read -p "Ingrese el nombre de usuario del equipo remoto: " user
    read -p "Ingrese la dirección IP del equipo remoto: " ip
    read -p "Contraseña sudo: " sudo

    echo "Eliminando el servicio Samba en el equipo remoto..."
    ssh "$user@$ip" "echo $sudo | sudo -S sudo apt-get -y remove samba" < /dev/null
}
parar_servicio() {
    read -p "Ingrese el nombre de usuario del equipo remoto: " user
    read -p "Ingrese la dirección IP del equipo remoto: " ip
    read -p "Contraseña sudo: " sudo

    echo "Parando el servicio Samba en el equipo remoto..."
    ssh "$user@$ip" "echo $sudo | sudo -S systemctl stop smbd.service" < /dev/null
}
iniciar_servicio() {
    read -p "Ingrese el nombre de usuario del equipo remoto: " user
    read -p "Ingrese la dirección IP del equipo remoto: " ip
    read -p "Contraseña sudo: " sudo

    echo "Parando el servicio Samba en el equipo remoto..."
    ssh "$user@$ip" "echo $sudo | sudo -S systemctl start smbd.service" < /dev/null
}
if [ $# -eq 0 ]; then
	while true
	do
	echo "a. Mostrar datos de tu equipo"
	echo "b. Mostrar el estado del servicio"
	echo "c. Mostrar un menú para ejecutar acciones"
	echo "d. Salir"
	read -p "Elige una opción: " opcion
	case $opcion in
		a)
			printf "\n"
			mostrar_datos_red
			printf "\n"
		;;
		b)
			printf "\n"
			estado_servicio
			printf "\n"
		;;
		c)
			printf "\n"
			mostrar_datos_red
			printf "\n"
			estado_servicio

			printf "\n"
			while true
			do
				echo "-----------------------------------------"
				echo "1. Instalación del servicio"
				echo "2. Eliminar el servicio"
				echo "3. Activar el servicio"
				echo "4. Parar el servicio"
				echo "5. Salir"
				echo "-----------------------------------------"
				printf "\n"
				read -p "Elige una opción: " opcion
				case $opcion in
					1)
						printf "\n"
						echo "Configuración Interactiva de smb.conf"
						echo "------------------------------------"

						# Crear el directorio /etc/samba si no existe
						sudo mkdir -p /etc/samba

						# Solicitar el nombre del usuario
						read -p "Nombre del usuario: " usuario
						# Solicitar la contraseña del usuario
						read -p "Contraseña: " pass
						# Solicitar la dirección IP
						read -p "Dirección IP: " ip
						# Solicitar el nombre del grupo de trabajo
						read -p "Nombre del Grupo de Trabajo: " workgroup
						# Solicitar el nombre NetBIOS
						read -p "Nombre NetBIOS del Servidor: " netbios_name
						# Solicitar la descripción del servidor
						read -p "Descripción del Servidor: " server_string
						# Solicitar el nombre del directorio compartido
						read -p "Nombre del Directorio Compartido: " share_name
						# Solicitar la ruta del directorio compartido
						read -p "Ruta del Directorio Compartido: " share_path
						# Solicitar la lista de usuarios válidos
						read -p "Usuarios Válidos (separados por comas): " valid_users
						# Crear el archivo smb.conf
						cat <<EOL | sudo tee /etc/samba/smb.conf
[global]
   workgroup = $workgroup
   netbios name = $netbios_name
   server string = $server_string

[$share_name]
   path = $share_path
   browseable = yes
   writable = yes
   valid users = $valid_users
EOL
						echo "Configuración completada. Se ha creado /etc/samba/smb.conf con la configuración proporcionada."
						mkdir "$share_path"
						sudo smbpasswd -a "$usuario"
						# Reiniciar el servicio Samba
						sudo systemctl restart smbd
						while true
						do
							echo "-----------------------------------------"
							echo "a. Instalar con comandos"
							echo "b. Instalar con Ansible"
							echo "c. Instalar con Docker"
							echo "d. Cancelar"
							echo "-----------------------------------------"
							read -p "Instalar el servicio con: "  instalar
							case $instalar in
								a)
									instalacion_remoto
								;;
								b)
									echo "$ip ansible_ssh_user=$usuario ansible_ssh_pass=$pass" >> ./host
									ansible-playbook -v samba.yml --extra-vars "ansible_sudo_pass=$pass"
								;;
								c)
									echo "opcion c"
									mkdir ./sambadocker
									cd sambadocker
									# Crear el archivo Dockerfile
									cat <<EOL | sudo tee Dockerfile
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y samba

CMD smbd --foreground --no-process-group
EOL

								docker build -t sambaiso .
								docker run -p 139:139 -p 445:445 -v $share_path:/$share_name --name sambacon -d sambaiso

								;;
								d)
									exit 0
								;;
							esac
						done
						printf "\n"
					;;
					2)
						printf "\n"
						eliminar_servicio
						printf "\n"
					;;
					3)
						printf "\n"
						iniciar_servicio
						printf "\n"
					;;
					4)
						printf "\n"
						parar_servicio
						printf "\n"
					;;
					5)
						exit 0
					;;
				esac
			done
		;;
		d)
			exit 0
		;;
		*)
			echo "Opción no válida"
		;;
	esac
	done
else
	echo "con parametros"
fi
