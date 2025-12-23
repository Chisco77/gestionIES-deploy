#!/bin/bash
set -e

echo "🐳 Instalando Docker en Debian/Ubuntu..."

# ===========================
# 1️⃣ Comprobar si Docker ya está instalado
# ===========================
if command -v docker &> /dev/null; then
  echo "✅ Docker ya está instalado. No se hace nada."
  docker --version
  exit 0
fi

# ===========================
# 2️⃣ Actualizar paquetes e instalar dependencias
# ===========================
echo "🔄 Actualizando índices de paquetes..."
sudo apt-get update -y

echo "📦 Instalando dependencias necesarias..."
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  software-properties-common

# ===========================
# 3️⃣ Añadir clave GPG oficial de Docker
# ===========================
echo "🔑 Añadiendo clave GPG de Docker..."
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# ===========================
# 4️⃣ Añadir repositorio de Docker
# ===========================
echo "📥 Añadiendo repositorio oficial de Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# ===========================
# 5️⃣ Instalar Docker
# ===========================
echo "🔄 Actualizando índices de paquetes..."
sudo apt-get update -y

echo "📦 Instalando Docker y complementos..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ===========================
# 6️⃣ Verificar instalación
# ===========================
echo "✅ Docker instalado correctamente."
docker --version
docker compose version
