# 🔁 SERVICIO SAMBA
<br><br>

## 📍 INTRODUCCIÓN
<div align="justify">
  Este proyecto contiene un script que permite la instalación mediante diversas formas del servicio samba en linux en equipos remotos.
  <br><br>
  El proyecto contiene múltiples archivos aparte del script principal, ya que nos permite instalar el servicio samba de distintas formas.
</div>

<br>

## 📍 CONTENIDO
<div align="justify">
  El proyecto contiene múltiples archivos de configuración:
  <br><br>
  🔸 <b>Ansible.cfg</b>: Este archivo contiene algunas configuraciones de ansible, necesarias para instalar el servicio mediante ansible.
  La principal línea que tendremos que tener en cuenta es la que contiene la ruta del archivo hosts, ya que en dicho fichero estarán las
  IP's de los destinatarios donde querremos instalar samba.
  <br><br>
  🔸 <b>Host</b>: Este archivo contiene las IP's y un usuario con su respectiva contraseña del equipo destinatario, ya que ansible intentará
  establecer la conexión con los destinatarios mediante acceso ssh, por lo que necesita unas credenciales del equipo destino.
  Podemos agrupar varios destinatarios en un mismo grupo, en este ejemplo hay un grupo llamado "clientes".
  <br><br>
  🔸 <b>Samba.yml</b>: Este archivo es el que contiene las instrucciones para la instalación del servicio en cuestión mediante ansible,
  en este caso del servicio samba. Es importante tener en cuenta las tabulaciones a la hora de usar archivos YAML.
  <br><br>
  🔸 <b>Dockersambabuena.yml</b>: Este archivo contiene las instrucciones para una instalación básica y rápida de Samba en Docker, si no
  requieres de docker-compose esta instalación es suficiente.
  <br><br>
  🔸 <b>Dockersamba.yml</b>: Este archivo contiene al igual que el anterior las instrucciones para instalar Samba en Docker, pero de forma
  más completa, incluye la configuración de Docker Compose para facilitar la gestión de contenedores e instrucciones para conectarse
  desde un cliente Samba.
  <br><br>
  🔸 <b>Configsmbd</b>: Este archivo es el script principal que contiene los comandos para instalar de la forma que queramos, ya sea por
  comandos, ansible o docker.
</div>
