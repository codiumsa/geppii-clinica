# geppii
Sistema de stock y facturacion.

Se utiliza docker para poder levantar una versión de desarrollo o producción de 
la aplicación para esto se asume que se tiene instalado [docker](https://docs.docker.com/).

En el directorio *docker* se encuentran los archivos utilizados para levantar la
aplicación en el ambiente seleccionado.


## Setup del volumen para la BD

Tanto para el setup de desarrollo y producción se debe crear un volumen para 
la base de datos.

```
$ docker volume create --name geppii-db
```

## Development

El ambiente de desarrollo levanta la aplicación con *rails s*

```
$ cd path/to/geppii/docker
$ cp docker.env.example docker.env
```

Editar el archivo docker.env para definir el nombre de la base de datos en base
a lo configurado en el archivo database.yml para el entorno development. Luego
construir la imagen:

```
$ cd path/to/geppii
$ docker build --tag=geppii-dev -f docker/dev/Dockerfile .
```

## Production

El ambiente en producción utiliza un servidor nginx + passenger para levantar
geppii, con los assets precompilados.

```
$ cd path/to/geppii/docker
$ cp docker.env.example docker.env
```

Editar el archivo docker.env para definir el nombre de la base de datos en base
a lo configurado en el archivo database.yml para el entorno production. Luego
construir la imagen:

```
$ cd path/to/geppii
$ docker build --tag=geppii-prod -f docker/prod/Dockerfile .
```

## Ejecutar la aplicación

Para levantar la aplicación se utiliza docker-compose:

```
$ cd path/to/geppii/docker/<env>/
$ docker-compose up -d
```

Con esto se tiene la aplicación corriendo en el puerto 3000.

## Inicializar la BD

Una vez levantada la aplicación, se puede inicializar la BD con el siguiente comando:

```
$ cd path/to/geppii/docker/<env>
$ docker-compose run geppii rake db:create db:migrate db:seed
```