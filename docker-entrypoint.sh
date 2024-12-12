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


# Run composer and npm only on php1
if [ "$HOSTNAME" == "php1" ]; then
    echo "Installing dependencies on php1..."
    composer install
    npm install
    npm run build

    # Create a file to signal the completion of dependancy installation
    touch /var/www/html/.dependencies_installed
    echo "Dependencies installed and flag file created."
else
    echo "Waiting for php1 to install dependencies..."
    while [ ! -f /var/www/html/.dependencies_installed ]; do
        sleep 1
    done
    echo "Dependencies installation complete!"
fi

# run migrations and seed only on php1 service
if [ "$HOSTNAME" == "php1" ]; then
    echo "Running migrations and seeds on php1..."
    php artisan key:generate
    php artisan migrate:fresh --seed
else
    echo "Skipping migrations and seeds on $HOSTNAME..."
fi

php-fpm
