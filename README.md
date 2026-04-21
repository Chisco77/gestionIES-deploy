# 🚀 Instalación Rápida de gestionIES

Guía de despliegue rápido para el sistema de gestión de centros educativos **gestionIES**.


## 📋 Requisitos Previos

Antes de comenzar, asegúrate de cumplir con los siguientes requisitos:
* **SO:** Linux (Debian o Ubuntu recomendados).
* **Permisos:** Acceso de superusuario (sudo).
* **Red:** Acceso a la red LDAP del centro.
* **Seguridad:** Certificados SSL (propios o autofirmados).
* **Herramientas:** Git.

---

## 🎥 Demos

* **[Instalación](https://www.youtube.com/watch?v=yzqUXrsdyiA)** 
* **[Admin](https://www.youtube.com/watch?v=maE1aAkVNe4&list=PLiPeMVVIvFdqKno4YzVRN8C_RV5Z17ok)** 
* **[Directiva](https://www.youtube.com/watch?v=iAzDGXIDOjo&list=PLiPeMVVIvFdqKno4YzVRN8C_RV5Z17okR)**
* **[Profesores](https://www.youtube.com/watch?v=L-OZSIHGVkI&list=PLiPeMVVIvFdqKno4YzVRN8C_RV5Z17okR)** 
* **[Educadora Social](https://www.youtube.com/watch?v=M-6HC7vFK_o)** 
* **[Ordenanza](https://www.youtube.com/watch?v=Vl9fM3fc7OA)** 



## ⚡ Pasos de instalación


### 0. Clonar el repositorio

Instalar git 
```
apt-get install -y git
```

Clona el proyecto y accede al directorio de despliegue:

```
git clone https://github.com/Chisco77/gestionIES-deploy.git
cd gestionIES-deploy
```

### 1. Poner logos y planos de tu IES en /public (opcional)
Lleva el logo de tu centro a logo.png y favicon.ico. Los planos, a PLANTA_BAJA.svg, PLANTA_PRIMERA.svg, PLANTA_SEGUNDA.svg.
IMPORTANTE: Respeta los nombres de los archivos.

### 2 . Fotos de perfil de alumnos (opcional)
Para que al editar un alumno, aparezca su foto de Rayuela:

> Descargad xml de alumnos y ponedlo en /backend, con nombre Alumnos.xml
> Los archivos de las fotos, llevadlos a /backend/uploads/alumnos
> Ejecutad node renameFotos.js (está en /backend). El resultado es que habrá renombrado las fotos de nie.extension a usuario.extension.


### 3. Despliegue
Accede a la carpeta del proyecto, gestionIES-deploy, da permisos de ejecución al script install.sh y ejecuta.
Instalará docker y portainer si no los tenías previamente instalados.

```
chmod +x install.sh
./install.sh
```


---

## ⚙️ Qué hace el script automáticamente
Al ejecutar install.sh, el sistema realiza las siguientes acciones:
1. **Instala** docker y portainer si no estaban previamente instalados.
2. **Construye** las imágenes Docker.
3. **Levanta** los contenedores (db, backend_app, frontend_nginx).
4. **Genera** el SESSION_SECRET si no existe.
5. **Crea la base de datos** si no existe.
6. **Importa la estructura** inicial desde db-init/gestionIES.sql si la base está vacía.

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
