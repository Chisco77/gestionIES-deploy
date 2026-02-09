# 🚀 Instalación Rápida de gestionIES

Guía de despliegue rápido para el sistema de gestión de centros educativos **gestionIES**.


## 📋 Requisitos Previos

Antes de comenzar, asegúrate de cumplir con los siguientes requisitos:
* **SO:** Linux (Debian o Ubuntu recomendados).
* **Permisos:** Acceso de superusuario (sudo).
* **Red:** Acceso a la red LDAP del centro.
* **Seguridad:** Certificados SSL (propios o autofirmados).
* **Herramientas:** Docker y Git instalados. Muy recomendable instalar portainer para gestionar contenedores y pgadmin para la BD.

---

## ⚡ Pasos Rápidos


### 0. Clonar el repositorio
Clona el proyecto y accede al directorio de despliegue:

```
git clone https://github.com/Chisco77/gestionIES-deploy.git
cd gestionIES-deploy
```

### 1. Herramientas
Instalar git, docker, portainer y certificados autofirmados.

Ejecutar permisos de ejecución a los scripts.

Para instalar git, ejecutar 
```
apt-get install -y git
```

Para instalar docker, ejecutar script 
```
./1-docker.sh
```
Para instalar portainer, ejecutar script 
```
./2-portainer.sh
```
Una vez instalado, acceder con https://ip_equipo:9443/


Para instalar certificados autofirmados, ejecutar 
```
./3-certificados.sh
```

### 2. Configurar variables de entorno
Crea el archivo de configuración a partir del ejemplo y edítalo:
```
cp .env.example .env
nano .env
```

> **IMPORTANTE**: Debes editar obligatoriamente los siguientes campos:
> * **DB_PASSWORD** → Contraseña para la base de datos PostgreSQL. Escoge la que quieras.
> * **LDAP_URL** → Dirección IP o URL del servidor LDAP. Por ejemplo ldap://172.16.16.2:389
> * **ALLOWED_ORIGINS** → URL pública del servidor. Por ejemplo, https://172.72.72.72 (respetar HTTPS)
> * **VITE_SERVER_URL** → URL del servidor. Por ejemplo, https://172.72.72.72:5000 (respetar HTTPS)
> * **VITE_*** → Datos específicos del centro.

### 3. Poner logos y planos de tu IES en /public
Lleva el logo de tu centro a logo.png y favicon.ico. Los planos, a PLANTA_BAJA.svg, PLANTA_PRIMERA.svg, PLANTA_SEGUNDA.svg.
IMPORTANTE: Respeta los nombres de los archivos.

### 4 . Fotos de perfil de alumnos (opcional)
Para que al editar un alumno, aparezca su foto de Rayuela:

> Descargad xml de alumnos y ponedlo en /backend, con nombre Alumnos.xml
> Los archivos de las fotos, llevadlos a /backend/uploads/alumnos
> Ejecutad node renameFotos.js (está en /backend). El resultado es que habrá renombrado las fotos de nie.extension a usuario.extension.



### 5. Desplegar la aplicación
Asigna permisos de ejecución al script y lánzalo:

```
chmod +x deploy.sh
./deploy.sh
```

---

## ⚙️ Qué hace el script automáticamente
Al ejecutar deploy.sh, el sistema realiza las siguientes acciones:
1. **Construye** las imágenes Docker.
2. **Levanta** los contenedores (db, backend_app, frontend_nginx).
3. **Genera** el SESSION_SECRET si no existe.
4. **Crea la base de datos** si no existe.
5. **Importa la estructura** inicial desde db-init/gestionIES.sql si la base está vacía.

---

## 🔍 Verificación y Acceso

### Comprobar contenedores activos
Verifica que los servicios estén corriendo correctamente:

```
docker ps
```

**Deberías ver los siguientes contenedores:**
* postgres_gestionIES
* node_gestionIES
* nginx_gestionIES

### URLs de acceso
* **Frontend:** https://TU_SERVIDOR/gestionIES/
* **La primera vez inicia con las credenciales del admin de LDAP**

---

## 🔄 Actualizar aplicación
Para actualizar el backend y el frontend a la última versión sin afectar a los datos de la base de datos, ejecuta:

```
docker compose up -d --build
```

## 🚀 Documentación de despliegue

En esta carpeta encontrarás las guías de instalación y despliegue:

- [Guía de despliegue con Docker](doc/Instalacion.pdf)
- [Manual de usuario](doc/Usuario.pdf)
