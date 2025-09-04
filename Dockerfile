FROM php:8.2-apache

# Atualiza repositórios e instala dependências do sistema para extensões PHP
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    unzip \
    zip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd

# Habilita o mod_rewrite do Apache para URLs amigáveis no Laravel
RUN a2enmod rewrite

# Copia todos os arquivos do projeto para o diretório padrão do Apache
COPY . /var/www/html

# Define a pasta pública como diretório raiz do servidor web
WORKDIR /var/www/html/public

# Ajusta permissões das pastas storage e bootstrap/cache para permitir escrita pelo servidor
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copia o Composer da imagem oficial para este container
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instala as dependências PHP do Laravel, otimizando autoloader para produção
RUN composer install --no-dev --optimize-autoloader

# Expõe a porta 80 para acesso HTTP
EXPOSE 80

# Comando para iniciar o Apache no foreground (manter container rodando)
CMD ["apache2-foreground"]
