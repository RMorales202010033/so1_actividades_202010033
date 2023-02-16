#!/bin/bash

read -p "Usuario Github: " GITHUB_USER
USER_DATA=$(curl -s https://api.github.com/users/"$GITHUB_USER")
USER_ID=$(echo $USER_DATA | jq -r '.id')
CREATED_AT=$(echo $USER_DATA | jq -r '.created_at')
echo "Hola $GITHUB_USER. User ID: $USER_ID. Cuenta fue creada el: $CREATED_AT."
FECHA=$(date +"%Y-%m-%d")
LOG_FILE="/tmp/$FECHA/saludos.log"
mkdir -p "$(dirname "$LOG_FILE")"
echo "Hola $GITHUB_USER. User ID: $ID. Cuenta fue creada el: $CREATED_AT." >> "$LOG_FILE"