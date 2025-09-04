FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd

RUN a2enmod rewrite

COPY . /var/www/html

WORKDIR /var/www/html/public

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev --optimize-autoloader

EXPOSE 80

CMD ["apache2-foreground"]
