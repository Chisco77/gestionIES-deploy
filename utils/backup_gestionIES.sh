#!/bin/bash

# Datos
docker exec -i postgres_gestionIES pg_dump -U postgres -d gestionIES -F p > gestionIES_full.sql

# Esquema
docker exec -t postgres_gestionIES pg_dump -U postgres -d gestionIES --schema-only --no-owner --no-privileges  > esquema_gestionIES.sql