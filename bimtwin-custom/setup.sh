#!/bin/bash

docker exec -it snipe php artisan migrate:fresh

docker exec -it snipe php artisan snipeit:create-admin --first_name=Andrew --last_name=Beveridge \
  --email=admin@bimtwin.ml --username=admin --password=bimtwin123

mysql -h 127.0.0.1 -u snipe -psnipemysqlpassword snipe < ./bimtwin-custom/settings.sql

docker exec -it snipe php artisan cache:clear

docker exec -it snipe php artisan passport:install
