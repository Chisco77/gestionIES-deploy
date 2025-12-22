# 🚀 Instalación Rápida de gestionIES

Guía de despliegue rápido para el sistema de gestión de centros educativos **gestionIES**.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de cumplir con los siguientes requisitos:
* **SO:** Linux (Debian o Ubuntu recomendados).
* **Permisos:** Acceso de superusuario (sudo).
* **Red:** Acceso a la red LDAP del centro.
* **Seguridad:** Certificados SSL (propios o autofirmados).
* **Herramientas:** Docker y Git instalados.

---

## ⚡ Pasos Rápidos

### 0. Herramientas
Instalar docker, portainer y git

Crear certificados autofirmados:

```
mkdir -p /etc/nginx/ssl
```
```
cd /etc/nginx/ssl
```

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt
```

### 1. Clonar el repositorio
Clona el proyecto y accede al directorio de despliegue:

```
git clone https://github.com/Chisco77/gestionIES-deploy.git
cd gestionIES-deploy
```

### 2. Configurar variables de entorno
Crea el archivo de configuración a partir del ejemplo y edítalo:
```
cp .env.example .env
nano .env
```

> **IMPORTANTE**: Debes editar obligatoriamente los siguientes campos:
> * **DB_PASSWORD** → Contraseña para la base de datos PostgreSQL.
> * **LDAP_URL** → Dirección IP o URL del servidor LDAP.
> * **ALLOWED_ORIGINS** → URL pública del servidor.
> * **VITE_*** → Datos específicos del centro.

### 3. Montar certificados SSL
Asegúrate de colocar tus archivos de certificado y clave privada en las siguientes rutas:
* /etc/nginx/ssl/nginx.crt
* /etc/nginx/ssl/nginx.key

### 4. Desplegar la aplicación
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
* **Backend API:** https://TU_SERVIDOR/api/

---

## 🔄 Actualizar aplicación
Para actualizar el backend y el frontend a la última versión sin afectar a los datos de la base de datos, ejecuta:ç

```
docker compose pull
docker compose build
docker compose up -d
```