#!/bin/bash
set -e

echo "============================================="
echo "   Instalación de Docker (si no está presente)"
echo "============================================="

# ===========================
# 1️⃣ Comprobar Docker
# ===========================
if command -v docker &> /dev/null; then
  echo "✅ Docker ya está instalado. No se hace nada."
  exit 0
fi

# ===========================
# 2️⃣ Actualizar e instalar dependencias básicas
# ===========================
echo "🔄 Actualizando índices de paquetes..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl lsb-release gnupg

# ===========================
# 3️⃣ Comprobar software-properties-common
# ===========================
echo "🔍 Verificando 'software-properties-common'..."
if ! dpkg -s software-properties-common >/dev/null 2>&1; then
  echo "📦 Instalando software-properties-common..."
  sudo apt-get install -y software-properties-common || {
    echo "⚠️ No se pudo instalar 'software-properties-common'."
    exit 1
  }
else
  echo "✅ software-properties-common ya instalado."
fi

# ===========================
# 4️⃣ Añadir repositorio oficial de Docker
# ===========================
echo "🔑 Añadiendo clave GPG de Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "📄 Añadiendo repositorio de Docker a APT..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# ===========================
# 5️⃣ Instalar Docker
# ===========================
echo "🔄 Actualizando índice de paquetes con el repositorio de Docker..."
sudo apt-get update -y

echo "📦 Instalando Docker y componentes..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ===========================
# 6️⃣ Comprobar instalación
# ===========================
echo "✅ Docker instalado correctamente."
docker --version
docker compose version
