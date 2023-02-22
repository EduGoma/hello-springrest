# Hello Spring REST
Este es un ejemplo básico de una aplicación Spring REST que devuelve un mensaje de saludo. Este repositorio incluye configuraciones para diferentes herramientas de automatización y despliegue, como Jenkins, Docker Compose, Dockerfile multistage y Elastic Beanstalk.

## Jenkins
El archivo Jenkinsfile incluido en este repositorio define un pipeline de integración continua que automatiza las tareas de construcción y test de la aplicación. El pipeline se divide en diferentes etapas la ejecución de pruebas unitarias, la generación de informes y construcción de la imagen.

Además, el pipeline también incluye una etapa de despliegue, que utiliza la herramienta Elastic Beanstalk para desplegar la aplicación en un entorno de producción. jenkins recibe un hook cada vez que hay un push a la rama principal main y despliega las actualizaciones.

## Docker Compose
El archivo docker-compose.yaml incluido en este repositorio define le contenedor de Docker que se ejecuta para proporcionar un entorno de desarrollo local para la aplicación.

Para ejecutar la aplicación localmente con Docker Compose, es necesario tener Docker y Docker Compose instalados en el equipo. Luego, se puede ejecutar el siguiente comando en la carpeta del proyecto:
docker-compose up

## Dockerfile multistage
El archivo Dockerfile incluido en este repositorio utiliza el enfoque de multistage para construir una imagen Docker de la aplicación. Este enfoque utiliza múltiples etapas para separar la construcción de la aplicación y la generación de la imagen final en diferentes contenedores.

La primera etapa utiliza la imagen de Gradle para construir la aplicación y generar un archivo JAR. La segunda etapa utiliza una imagen más liviana de Amazoncorretto para copiar el archivo JAR generado en la primera etapa y ejecutar la aplicación.

El uso de multistage en el Dockerfile permite reducir el tamaño final de la imagen de Docker y mejorar la seguridad al no incluir herramientas de compilación y dependencias innecesarias.

## Elastic Beanstalk
La carpeta .ebextensions incluida en este repositorio contiene archivos de configuración para desplegar la aplicación en Elastic Beanstalk. Elastic Beanstalk es un servicio de AWS que permite desplegar y escalar aplicaciones web y servicios web de manera sencilla y rápida.

Para desplegar la aplicación en Elastic Beanstalk, es necesario tener una cuenta de AWS y configurar Elastic Beanstalk en la consola de AWS. Luego, se debe crear una aplicación y un entorno de Elastic Beanstalk.
