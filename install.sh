#!/bin/bash
set -e

# Colores para la terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}🚀 ASISTENTE DE INSTALACIÓN GESTION-IES 🚀${NC}"
echo -e "${BLUE}=============================================${NC}"

# =============================================
# 1️⃣ INSTALACIÓN DE DOCKER (Tu script integrado)
# =============================================
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}🔄 Instalando Docker y dependencias...${NC}"
    apt update -y && apt install -y apt-transport-https ca-certificates curl lsb-release gnupg
    
    if ! apt-cache show software-properties-common > /dev/null 2>&1; then
        echo "⚠️ Instalando software-properties-common manualmente..."
        TMPDIR=$(mktemp -d) && cd "$TMPDIR"
        wget -q "https://ftp.debian.org/debian/pool/main/s/software-properties/python3-software-properties_0.99.30-4.1~deb12u1_all.deb"
        wget -q "https://ftp.debian.org/debian/pool/main/s/software-properties/software-properties-common_0.99.30-4.1~deb12u1_all.deb"
        apt install -y ./*.deb && cd - && rm -rf "$TMPDIR"
    else
        apt install -y software-properties-common
    fi

    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo -e "${GREEN}✅ Docker instalado.${NC}"
else
    echo -e "${GREEN}✅ Docker ya está presente.${NC}"
fi

# =============================================
# 2️⃣ INSTALACIÓN DE PORTAINER (Tu script integrado)
# =============================================
if ! docker ps -a --format '{{.Names}}' | grep -q '^portainer$'; then
    echo -e "${YELLOW}🐳 Instalando Portainer CE...${NC}"
    docker volume create portainer_data > /dev/null
    docker run -d --name portainer --restart=always -p 9000:9000 -p 9443:9443 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
    echo -e "${GREEN}✅ Portainer listo en puerto 9443.${NC}"
else
    echo -e "${GREEN}✅ Portainer ya está en ejecución.${NC}"
fi

# =============================================
# 3️⃣ CERTIFICADOS SSL (Interactivo)
# =============================================
SSL_DIR="./nginx/ssl" # Ruta relativa para el montaje de Docker

if [ ! -f "$SSL_DIR/nginx.crt" ]; then
    echo -e "${YELLOW}🔐 Generando certificados autofirmados...${NC}"
    echo -e "${BLUE}Por favor, introduce los datos de tu centro cuando se te soliciten:${NC}"
    
    mkdir -p "$SSL_DIR"
    
    # Hemos quitado el flag -subj para que sea interactivo
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout "$SSL_DIR/nginx.key" \
      -out "$SSL_DIR/nginx.crt"

    echo -e "${GREEN}✅ Certificados generados correctamente en $SSL_DIR.${NC}"
else
    echo -e "${GREEN}✅ Los certificados SSL ya existen en $SSL_DIR.${NC}"
fi

# =============================================
# 4️⃣ CONFIGURACIÓN DE LA APLICACIÓN (.env)
# =============================================
echo -e "\n${BLUE}--- Configuración de GestionIES ---${NC}"
[ ! -f .env ] && cp .env.example .env

update_env() {
    # Eliminamos la línea si existe y la añadimos limpia al final
    sed -i "/^$1=/d" .env
    echo "$1=$2" >> .env
}

# 1. Contraseña de Base de Datos
read -p "🔑 Contraseña de la BD de miIES (elige una): " DB_PASS
update_env "DB_PASSWORD" "$DB_PASS"

# 2. Datos del Centro (VITE)
echo -e "\n${YELLOW}🏫 Datos del Instituto:${NC}"
read -p "   🔹 Nombre del Centro (ej. IES Francisco de Quevedo): " IES_NAME
update_env "VITE_IES_NAME" "$IES_NAME"

read -p "   🔹 Dirección (Calle, Avenida, nº...): " DIR_1
update_env "VITE_DIRECCION_LINEA_1" "$DIR_1"

read -p "   🔹 Población y Código Postal (ej. Madrid 28001): " DIR_2
update_env "VITE_DIRECCION_LINEA_2" "$DIR_2"

read -p "   🔹 Teléfono / Fax (ej. Teléfono: xxxx  Fax: xxxx): " DIR_3
update_env "VITE_DIRECCION_LINEA_3" "$DIR_3"

# 3. LDAP (IP)
echo -e "\n${YELLOW}🌐 Configuración de Red:${NC}"
read -p "   🔹 IP del servidor LDAP (ej. 172.16.16.2): " LDAP_IP
LDAP_URL="ldap://${LDAP_IP}:389"
update_env "LDAP_URL" "$LDAP_URL"

# 4. URL del Servidor (IP)
read -p "   🔹 IP del equipo en el que instalas miIES (ej. 172.72.72.72): " SERVER_IP
FULL_SERVER_URL="https://${SERVER_IP}"

# 5. ALLOWED_ORIGINS
LOCAL_ORIGINS="http://localhost:5173,https://localhost:5173"
ALLOWED_ORIGINS="${LOCAL_ORIGINS},${FULL_SERVER_URL}"

update_env "ALLOWED_ORIGINS" "$ALLOWED_ORIGINS"
update_env "VITE_SERVER_URL" "$FULL_SERVER_URL"

# 6. Secreto de Sesión
if ! grep -q "SESSION_SECRET=" .env; then
    update_env "SESSION_SECRET" "$(openssl rand -hex 16)"
fi

echo -e "${GREEN}✅ Configuración del .env finalizada.${NC}"

# =============================================
# 5️⃣ LOGOS Y PLANOS
# =============================================
echo -e "\n${YELLOW}📂 ¿Deseas copiar logos y planos desde una carpeta? (s/n)${NC}"
read -r COPY_FILES
if [[ "$COPY_FILES" =~ ^[Ss]$ ]]; then
    read -p "Indica la ruta de la carpeta: " FOLDER_PATH
    [ -d "$FOLDER_PATH" ] && cp "$FOLDER_PATH"/* ./public/ && echo "✅ Archivos copiados."
fi

# =============================================
# 6️⃣ DESPLIEGUE FINAL
# =============================================
echo -e "${YELLOW}🏗️ Levantando aplicación con Docker Compose...${NC}"
docker compose build
docker compose up -d

# Espera a DB y creación de tablas (Lógica anterior)
DB_USER=$(grep "^DB_USER=" .env | cut -d '=' -f2)
DB_NAME=$(grep "^DB_NAME=" .env | cut -d '=' -f2)

echo "⏳ Esperando a PostgreSQL..."
until docker exec -i postgres_gestionIES pg_isready -U "$DB_USER" > /dev/null 2>&1; do sleep 2; done

EXISTS=$(docker exec -i postgres_gestionIES psql -U "$DB_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
if [ "$EXISTS" != "1" ]; then
    docker exec -i postgres_gestionIES psql -U "$DB_USER" -c "CREATE DATABASE \"$DB_NAME\";"
    [ -f "./db-init/gestionIES.sql" ] && docker exec -i postgres_gestionIES psql -U "$DB_USER" -d "$DB_NAME" < "./db-init/gestionIES.sql"
fi

echo -e "\n${GREEN}🎉 ¡INSTALACIÓN COMPLETADA!${NC}"
echo "-------------------------------------------------------"
echo "🌐 miIES: $FULL_SERVER_URL/gestionIES/"
echo "🐳 Portainer: https://$(hostname -I | awk '{print $1}'):9443"
echo "-------------------------------------------------------"