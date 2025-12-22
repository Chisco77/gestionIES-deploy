#!/bin/bash
set -e

echo "🚀 Desplegando gestionIES..."

# Comprobar que existe .env
if [ ! -f .env ]; then
  echo "❌ ERROR: No se encuentra el archivo .env. Copia .env.example a .env y edítalo."
  exit 1
fi

# Crear un SESSION_SECRET si no existe
if ! grep -q "SESSION_SECRET=" .env; then
  SECRET=$(openssl rand -hex 16)
  echo "SESSION_SECRET=$SECRET" >> .env
  echo "🔑 Se generó SESSION_SECRET automáticamente."
fi

# Construir y levantar contenedores
docker compose build
docker compose up -d

echo "✅ gestionIES desplegado correctamente."
