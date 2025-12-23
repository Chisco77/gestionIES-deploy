#!/bin/bash
set -e

echo "🔐 Creando certificados autofirmados para Nginx..."

# Carpeta donde se guardarán los certificados
SSL_DIR="/etc/nginx/ssl"

# Crear la carpeta si no existe
mkdir -p "$SSL_DIR"
cd "$SSL_DIR"

# Generar certificado autofirmado
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$SSL_DIR/nginx.key" \
  -out "$SSL_DIR/nginx.crt"

echo "✅ Certificados generados correctamente en $SSL_DIR"
echo "   - Clave privada: nginx.key"
echo "   - Certificado: nginx.crt"
echo ""
echo "💡 Puedes usar estos certificados en tu configuración de Nginx."
