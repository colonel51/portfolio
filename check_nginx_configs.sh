#!/bin/bash

# Nginx Config Kontrol Script'i

echo "=== Nginx Config Kontrolü ==="
echo ""

# 1. Tüm aktif config'leri listele
echo "1. Aktif nginx config'leri:"
ls -la /etc/nginx/sites-enabled/
echo ""

# 2. Her config'in server_name'ini göster
echo "2. Server_name'ler:"
echo ""
echo "--- Portfolio ---"
if [ -f "/etc/nginx/sites-available/portfolio" ]; then
    grep "server_name" /etc/nginx/sites-available/portfolio
    grep "listen" /etc/nginx/sites-available/portfolio | head -1
else
    echo "Portfolio config bulunamadı!"
fi
echo ""

echo "--- Kardeslastik ---"
if [ -f "/etc/nginx/sites-available/kardeslastik" ]; then
    grep "server_name" /etc/nginx/sites-available/kardeslastik
    grep "listen" /etc/nginx/sites-available/kardeslastik | head -1
    echo ""
    echo "   Tam config (ilk 30 satır):"
    head -30 /etc/nginx/sites-available/kardeslastik
else
    echo "Kardeslastik config bulunamadı!"
fi
echo ""

echo "--- Ozermetal ---"
if [ -f "/etc/nginx/sites-available/ozermetal" ]; then
    grep "server_name" /etc/nginx/sites-available/ozermetal
    grep "listen" /etc/nginx/sites-available/ozermetal | head -1
else
    echo "Ozermetal config bulunamadı!"
fi
echo ""

# 3. Nginx test
echo "3. Nginx yapılandırma testi:"
nginx -t
echo ""

# 4. Test önerileri
echo "=== Test Komutları ==="
echo "curl -H 'Host: ramazankarsanba.com' http://161.35.207.182"
echo "curl -H 'Host: kardesdemirlastik.com.tr' http://161.35.207.182"
