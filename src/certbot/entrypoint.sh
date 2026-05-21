#!/bin/bash
set -e

# Функция корректного завершения при остановке контейнера
_term() {
    echo "Завершение работы контейнера Certbot..."
    exit 0
}
trap _term SIGTERM SIGINT

echo "=== Старт контейнера Certbot для DuckDNS ==="

# 1. Динамическая генерация безопасного ini-файла для плагина
INI_FILE="/tmp/duckdns.ini"
echo "dns_duckdns_token = ${DUCKDNS_TOKEN}" > "$INI_FILE"
chmod 600 "$INI_FILE"

# Формируем имена доменов
DOMAIN="${DUCKDNS_SUBDOMAIN}.duckdns.org"
WILDCARD_DOMAIN="*.${DUCKDNS_SUBDOMAIN}.duckdns.org"

# Бесконечный цикл проверки и обновления сертификатов
while true; do
    echo "Проверка наличия сертификата для ${DOMAIN}..."
    
    # Если сертификата еще нет, запрашиваем первоначальный выпуск
    if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
        echo "Сертификат не найден. Запуск первичного выпуска..."
        certbot certonly --non-interactive \
            --agree-tos \
            --email "${LE_EMAIL}" \
            --authenticator dns-duckdns \
            --dns-duckdns-credentials "$INI_FILE" \
            --dns-duckdns-propagation-seconds 60 \
            -d "$DOMAIN" \
            -d "$WILDCARD_DOMAIN"
    else
        echo "Сертификат существует. Проверка необходимости обновления..."
        certbot renew --non-interactive
    fi

    echo "Ожидание 12 часов перед следующей проверкой..."
    # Спим 12 часов в бэкграунде, чтобы корректно перехватывать сигналы Docker
    sleep 12h &
    wait $!
done
