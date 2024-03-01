#!/bin/bash

if [ $# -eq 0 ]; then
	echo "a. Mostrar datos de tu equipo"
	echo "b. Mostrar el estado del servicio"
	echo "c. Mostrar un menú para ejecutar acciones"
	read -p "Elige una opción: " opcion
	case $opcion in
		a)
			ip=$(ip addr show | grep -E "inet" |grep -E "\b(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(?:3[0-2]|[12]?[0-9])\b brd" | cut -d" " -f6)
		;;
		b)
			estado=$(systemctl status cron.service | grep -E "Active: " | cut -d" " -f7)
		;;
		c)
			echo "Tu dirección IP es: $ip"
			echo "El estado del servicio en este momento es: $estado"
			printf "\n"
			while true
			do
				echo "1. Instalación del servicio"
				echo "2. Eliminar el servicio"
				echo "3. Activar el servicio"
				echo "4. Parar el servicio"
				echo "5. Configuración"
				echo "6. Salir"
				printf "\n"
				read -p "Elige una opción" opcion
				case $opcion in
					1)
						printf "\n"
						echo "Configuración Interactiva de smb.conf"
						echo "------------------------------------"
						
						# Solicitar el nombre del usuario
						read -p "Nombre del usuario: " usuario
						# Solicitar la contraseña del usuario
						read -p "Contraseña: " contra
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
						# Reiniciar el servicio Samba
						sudo systemctl restart smbd
						while true
						do
							echo "a. Instalar con comandos"
							echo "b. Instalar con Ansible"
							echo "c. Instalar con Docker"
							read -p "Instalar el servicio con: "  instalar
							case $instalar in
								a)
									ssh $user@$ip
									sudo apt update
									sudo apt install samba
									sudo systemctl status smbd
								;;
								b)
									echo "$ip ansible_ssh_user=$usuario ansible_ssh_pass=$contra" >> ./host
									ansible-playbook -v samba.yml --extra-vars "ansible_sudo_pass=$pass"
								;;
								c)
									echo "opcion c"
								;;
								*)
									exit 0
								;;
							esac
						done
						printf "\n"
					;;
					2)
						printf "\n"
						echo "2"
						printf "\n"
					;;
					3)
						printf "\n"
						echo "3"
						printf "\n"
					;;
					4)
						printf "\n"
						echo "4"
						printf "\n"
					;;
					5)
						exit 0
					;;
				esac
			done
		;;
		*)
			echo "Opción no válida"
		;;
	esac
else
	echo "con parametros"
fi
