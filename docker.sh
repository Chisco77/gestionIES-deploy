#!/bin/bash
set -e

echo "============================================="
echo "🚀 Instalando Docker (si no está presente)..."
echo "============================================="

# ============================
# 1️⃣ Comprobar si Docker ya está instalado
# ============================
if command -v docker &> /dev/null; then
    echo "✅ Docker ya está instalado. Saliendo..."
    exit 0
fi

# ============================
# 2️⃣ Actualizar índices y dependencias
# ============================
echo "🔄 Actualizando paquetes base..."
apt update -y
apt install -y apt-transport-https ca-certificates curl lsb-release gnupg

# ============================
# 3️⃣ Instalar software-properties-common (con fallback manual)
# ============================
echo "🔍 Comprobando software-properties-common..."
if apt-cache show software-properties-common > /dev/null 2>&1; then
    echo "✅ Disponible en repositorios. Instalando..."
    apt install -y software-properties-common
else
    echo "⚠️ No disponible en repositorios. Instalando manualmente..."
    TMPDIR=$(mktemp -d)
    cd "$TMPDIR"

    SPC="software-properties-common_0.99.30-4.1~deb12u1_all.deb"
    PSP="python3-software-properties_0.99.30-4.1~deb12u1_all.deb"

    URL_SPC="https://ftp.debian.org/debian/pool/main/s/software-properties/${SPC}"
    URL_PSP="https://ftp.debian.org/debian/pool/main/s/software-properties/${PSP}"

    echo "⬇️ Descargando $PSP"
    wget -q "$URL_PSP" -O "$PSP"

    echo "⬇️ Descargando $SPC"
    wget -q "$URL_SPC" -O "$SPC"

    echo "📦 Instalando paquetes manualmente..."
    apt install -y "./$PSP" "./$SPC"

    cd -
    rm -rf "$TMPDIR"
fi

# ============================
# 4️⃣ Añadir repositorio oficial de Docker
# ============================
echo "📝 Añadiendo repositorio oficial de Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

# ============================
# 5️⃣ Instalar Docker y componentes
# ============================
echo "🔄 Actualizando índices y instalando Docker..."
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ============================
# 6️⃣ Comprobación final
# ============================
echo "✅ Docker instalado correctamente:"
docker --version
docker compose version
