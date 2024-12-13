# Automatización de Instalación y Configuración de Spark mediante Ansible

Este repositorio está creado para el proyecto grupal de la asignatura Configuración, Implementación y Mantenimiento de Sistemas Informáticos del Grado en Ingeniería Informática: Tecnologías Informáticas de la Universidad de Sevilla. Los integrantes del grupo son:

- Sara Fernández Malvido
- Fernando Francisco Moya Rangel
- Pablo Diego Acosta
- Nicolás Martínez Van der Looven
- María de la Paloma Bas Fernández
- Andrés Rubio Ramos
- Pablo Martín Berna
- Lucía García Salido



## Contenido del repositorio

El repositorio contiene todo lo necesario para el despliegue, instalación y configuración de manera (semi)automática de una plataforma de procesamiento distribuido de Big Data usando tecnologías de código abierto como Hadoop HDFS, YARN y Spark.
Además, se incluye un pequeño script de ejemplo donde se realiza un tarea de Word2Vec sobre los textos de ejemplo incluidos.

## Despliegue de la plataforma

Se incluyen varios scripts donde se automatiza el proceso:

+ modify_hostfile.sh : Añade las lineas necesarias a los ficheros /etc/hosts y /etc/ansible/hosts.

+ full_deploy.sh : Levanta las VMs y ejecuta el playbook de Ansible para instalar y configurar la plataforma. Opcionalmente ejecuta también la tarea Spark de ejemplo.

+ spark_task.sh : Ejecuta la tarea Spark de ejemplo.

##

La plataforma está pensada para ser ejecutado en una máquina Linux con Vagrant y Ansible instalado. Todas las pruebas se han realizado en una máquina con 24Gb de RAM y la CPU AMD Opteron 6174. La configuración de las VMs y los nodos de YARN y Spark se ha hecho teniendo estas especificaciones en cuenta.