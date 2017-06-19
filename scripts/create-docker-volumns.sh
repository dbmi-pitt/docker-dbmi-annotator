#!/bin/bash

echo "[INFO] begin create docker volumes of AnnotationPress"

docker volume create --name postgres-volume -d local
docker volume create --name elasticsearch-volume -d local
docker volume create --name elastic-snapshot-volume -d local
docker volume create --name article-list-volume -d local
docker volume create --name annotation-resources-volume -d local

echo "[INFO] docker volumes are created!"
