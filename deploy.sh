#!/bin/bash
set -e

echo "🚀 Desplegando gestionIES..."

# ===========================
# 1️⃣ Comprobar .env
# ===========================
if [ ! -f .env ]; then
  echo "❌ ERROR: No se encuentra el archivo .env. Copia .env.example a .env y edítalo."
  exit 1
fi

# ===========================
# 2️⃣ Crear SESSION_SECRET si no existe
# ===========================
if ! grep -q "SESSION_SECRET=" .env; then
  SECRET=$(openssl rand -hex 16)
  echo "SESSION_SECRET=$SECRET" >> .env
  echo "🔑 Se generó SESSION_SECRET automáticamente."
fi

# ===========================
# 3️⃣ Construir y levantar contenedores
# ===========================
docker compose build
docker compose up -d

# ===========================
# 4️⃣ Esperar a que PostgreSQL acepte conexiones
# ===========================
DB_CONTAINER="postgres_gestionIES"
DB_USER=$(grep DB_USER .env | cut -d '=' -f2)
DB_NAME=$(grep DB_NAME .env | cut -d '=' -f2)

echo "⏳ Esperando a que PostgreSQL acepte conexiones..."
MAX_RETRIES=30
TRIES=0
until docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d postgres -c "SELECT 1" > /dev/null 2>&1; do
  ((TRIES++))
  if [ $TRIES -ge $MAX_RETRIES ]; then
    echo "❌ Error: No se pudo conectar a PostgreSQL después de $MAX_RETRIES intentos."
    exit 1
  fi
  echo "⏳ Intentando conectar a PostgreSQL... Intento $TRIES/$MAX_RETRIES"
  sleep 2
done
echo "✅ PostgreSQL completamente operativo."

# ===========================
# 5️⃣ Crear base de datos si no existe
# ===========================
EXISTS=$(docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
if [ "$EXISTS" != "1" ]; then
  echo "📦 Creando base de datos $DB_NAME..."
  docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE \"$DB_NAME\";"
  CREATED_DB=true
else
  echo "ℹ️ La base de datos $DB_NAME ya existe."
  CREATED_DB=false
fi

# ===========================
# 6️⃣ Importar dump inicial si DB recién creada
# ===========================
DUMP_FILE="./db-init/gestionIES.sql"
if [ "$CREATED_DB" = true ]; then
  if [ -f "$DUMP_FILE" ]; then
    echo "📥 Importando dump inicial a $DB_NAME..."
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$DUMP_FILE"
    echo "✅ Dump importado correctamente."
  else
    echo "⚠️ No se encontró el dump $DUMP_FILE, se omite la importación."
  fi
else
  echo "⚠️ Se omite la importación del dump porque la base de datos ya existía."
fi

# ===========================
# 7️⃣ Mensaje final
# ===========================
echo "🎉 gestionIES desplegado con éxito."
