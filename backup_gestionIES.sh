#!/bin/bash
docker exec -i postgres_gestionIES pg_dump -U postgres -d gestionIES -F p > gestionIES_full.sql
