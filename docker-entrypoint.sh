#!/bin/bash
set -e

# Wait for MySQL to be ready
while ! nc -z mysql 3306; do
    echo "Waiting for MySQL..."
    sleep 1
done
echo "MySQL is ready!"

cd /var/www/html

# copt .env and configure it
if [ ! -f ".env" ]; then
    cp .env.example .env
    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env
    sed -i 's/DB_DATABASE=example_app/DB_DATABASE=laravel/' .env
    sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel/' .env
    sed -i 's/DB_PASSWORD=/DB_PASSWORD=laravel/' .env
fi

composer install
npm install
npm run build

# run migrations and seed only on php1 service
if [ "$HOSTNAME" == "php1" ]; then
    echo "Running migrations and seeds on php1..."
    php artisan key:generate
    php artisan migrate:fresh --seed
else
    echo "Skipping migrations and seeds on $HOSTNAME..."
fi

php-fpm
