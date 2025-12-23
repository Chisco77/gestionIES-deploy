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
# 4️⃣ Esperar a que la base de datos esté lista
# ===========================
DB_CONTAINER="postgres_gestionIES"
DB_USER=$(grep DB_USER .env | cut -d '=' -f2)
DB_NAME=$(grep DB_NAME .env | cut -d '=' -f2)

echo "⏳ Esperando a que PostgreSQL acepte conexiones reales..."

until docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d postgres -c "SELECT 1" > /dev/null 2>&1; do
  sleep 2
done

echo "✅ PostgreSQL completamente operativo."


# ===========================
# 5️⃣ Crear base de datos si no existe
# ===========================
echo "📦 Creando base de datos $DB_NAME si no existe..."
docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';" | grep -q 1 \
  || docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE \"$DB_NAME\";"
echo "✅ Base de datos lista."

# ===========================
# 6️⃣ Importar dump inicial si DB recién creada
# ===========================
DUMP_FILE="./db-init/gestionIES.sql"
if [ -f "$DUMP_FILE" ]; then
  # Solo importa si la DB está vacía
  COUNT=$(docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT count(*) FROM information_schema.tables;" | tr -d '[:space:]')
  if [ "$COUNT" = "0" ]; then
    echo "📥 Importando dump inicial a $DB_NAME..."
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$DUMP_FILE"
    echo "✅ Dump importado correctamente."
  else
    echo "⚠️ La base de datos ya contiene tablas, se omite la importación del dump."
  fi
else
  echo "⚠️ No se encontró el dump $DUMP_FILE, se omite la importación."
fi

echo "🎉 gestionIES desplegado con éxito."
