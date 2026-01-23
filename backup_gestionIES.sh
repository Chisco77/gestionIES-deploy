#!/bin/bash
docker exec -t postgres_gestionIES pg_dump -U postgres gestionIES > gestionIES_dump.sql
