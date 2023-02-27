# SOLUCIÓN
## PROBLEMA
Al momento de cargar una URL específca la página tiraba un error 404, esto se debe a que no se ha configurado el nginx el cual determina cómo se comportará el servidor web.
<br/>

## SOLUCIÓN
Para solucionar este problema fue necesario agregar el archivo ```nginx.conf``` ya se tiene un archivo nginx.Dockerfile, ya que el archivo ```nginx.conf``` contiene la configuración de Nginx, que determina cómo se comportará el servidor web.

A la hora que se ejecute el contenedor basado en la imagen, el archivo ```nginx.conf``` se utilizará para configurar el servidor web dentro del contenedor.

Además, el archivo ```nginx.conf``` puede contener configuraciones específicas del proyecto o de la aplicación que se ejecutará en el servidor web.

A continuación se muestra el archivo ```nginx.Dockerfile``` corregido:

```Dockerfile
## BUILD
# docker build -t mifrontend:0.1.0-nginx-alpine -f nginx.Dockerfile .
## RUN
# docker run -d -p 3000:80 mifrontend:0.1.0-nginx-alpine
FROM node:18.14.0-buster-slim as compilacion

LABEL developer="jesus guzman" \
      email="susguzman@gmail.com"

ENV REACT_APP_BACKEND_BASE_URL=http://localhost:3800

# Copy app
COPY . /opt/app

WORKDIR /opt/app

# Npm install
RUN npm install

RUN npm run build

# Fase 2
FROM nginx:1.22.1-alpine as runner

COPY --from=compilacion /opt/app/build /usr/share/nginx/html

# Configuración de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para ejecutar nginx
CMD ["nginx", "-g", "daemon off;"]

```

Lo único que se agregó fueron los últimos 3 comandos:

```Dockerfile
# Configuración de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
```
Esta línea copia el archivo nginx.conf del directorio local al contenedor en la ruta /etc/nginx/conf.d/default.conf. Este archivo es necesario para configurar correctamente el servidor web Nginx para que sirva los archivos estáticos generados por la aplicación React.

```Dockerfile
# Exponer el puerto 80
EXPOSE 80
```
Esta línea indica al sistema Docker que el contenedor expone el puerto 80. Esto no hace que el puerto esté disponible públicamente, solo indica al sistema que el contenedor está escuchando en el puerto 80.

```Dockerfile
# Comando para ejecutar nginx
CMD ["nginx", "-g", "daemon off;"]
```
Esta línea indica qué comando se debe ejecutar cuando el contenedor se inicie. En este caso, el comando nginx -g 'daemon off;' se utiliza para iniciar el servidor web Nginx. La opción -g 'daemon off;' evita que el servidor web se ejecute en segundo plano, lo que permitiría que el contenedor se detenga inmediatamente después de iniciarse.

En su lugar, al usar daemon off;, el servidor web se ejecutará en primer plano y el contenedor seguirá ejecutándose mientras el servidor web esté activo.

<br/>

Ahora bien como se creó el archivo ```nginx.conf``` en el mismo directorio donde se encuentra nuestro Dockerfile y nginx.Dockerfile, el código que se le agregó fue el siguiente:

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```
Esta configuración indica a Nginx que escuche en el puerto 80 y sirva los archivos estáticos que se encuentran en /usr/share/nginx/html. También indica que si se solicita una URL que no existe, se debe devolver el archivo index.html.