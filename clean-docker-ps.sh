#!/bin/bash

echo "[INFO] begin stop docker ps of AnnotationPress"
docker stop postgres dbmi-annotator elasticsearch annotator-store apache2
echo "[INFO] stop docker ps of AnnotationPress done!"

echo "[INFO] begin remove docker ps of AnnotationPress"
docker rm postgres dbmi-annotator elasticsearch annotator-store apache2
echo "[INFO] remove docker ps of AnnotationPress done!"
