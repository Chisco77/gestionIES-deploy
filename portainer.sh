#!/bin/bash
set -e

echo "🐳 Comprobando instalación de Portainer CE..."

# ===========================
# 1️⃣ Comprobar Docker
# ===========================
if ! command -v docker &> /dev/null; then
  echo "❌ Docker no está instalado. Instálalo antes de continuar."
  exit 1
fi

# ===========================
# 2️⃣ Comprobar si Portainer ya existe
# ===========================
if docker ps -a --format '{{.Names}}' | grep -q '^portainer$'; then
  echo "ℹ️ Portainer ya está instalado."
  echo "➡️ No se realiza ninguna acción."
  exit 0
fi

# ===========================
# 3️⃣ Crear volumen si no existe
# ===========================
if ! docker volume inspect portainer_data >/dev/null 2>&1; then
  echo "📦 Creando volumen portainer_data..."
  docker volume create portainer_data
else
  echo "ℹ️ El volumen portainer_data ya existe."
fi

# ===========================
# 4️⃣ Lanzar Portainer
# ===========================
echo "🚀 Instalando Portainer CE..."
docker run -d \
  --name portainer \
  --restart=always \
  -p 9000:9000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

# ===========================
# 5️⃣ Información final
# ===========================
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ Portainer instalado correctamente."
echo "🌐 Accede desde el navegador:"
echo "   👉 https://$IP:9443"
echo ""
echo "🔐 En el primer acceso:"
echo "   - Crea el usuario administrador"
echo "   - Selecciona: Local Docker"
echo ""
