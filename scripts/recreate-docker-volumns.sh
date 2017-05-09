#!/bin/bash

echo "[INFO] begin remove docker volumes of AnnotationPress"
docker volume rm postgres-volume
docker volume rm elastic-snapshot-volume
docker volume rm elasticsearch-volume

echo "[INFO] begin create docker volumes of AnnotationPress"
docker volume create --name postgres-volume -d local
docker volume create --name elasticsearch-volume -d local
docker volume create --name elastic-snapshot-volume -d local

echo "[INFO] docker volumes recreate done!"
