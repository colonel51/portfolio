#!/bin/bash

# Nginx Routing Debug Script

echo "=== Nginx Routing Debug ==="
echo ""

# 1. Aktif config'leri listele
echo "1. Aktif nginx config'leri (yükleme sırasına göre):"
ls -1 /etc/nginx/sites-enabled/ | sort
echo ""

# 2. Her config'in server_name'ini göster
echo "2. Server_name'ler:"
for config in $(ls -1 /etc/nginx/sites-enabled/ | sort); do
    echo "--- $config ---"
    grep "server_name" /etc/nginx/sites-available/$(readlink -f /etc/nginx/sites-enabled/$config | xargs basename) 2>/dev/null | head -1
    grep "listen" /etc/nginx/sites-available/$(readlink -f /etc/nginx/sites-enabled/$config | xargs basename) 2>/dev/null | grep "listen 80" | head -1
    echo ""
done

# 3. Portfolio config'inin tamamını göster
echo "3. Portfolio config (ilk 10 satır):"
head -10 /etc/nginx/sites-available/portfolio
echo ""

# 4. Test istekleri
echo "4. Test istekleri:"
echo "ramazankarsanba.com:"
curl -s -H 'Host: ramazankarsanba.com' http://161.35.207.182 | head -20
echo ""
echo "kardesdemirlastik.com.tr:"
curl -s -H 'Host: kardesdemirlastik.com.tr' http://161.35.207.182 | head -20
echo ""

# 5. Nginx error log kontrolü
echo "5. Son nginx error logları:"
tail -20 /var/log/nginx/error.log 2>/dev/null || echo "Log bulunamadı"
echo ""

# 6. Nginx access log kontrolü
echo "6. Son nginx access logları:"
tail -10 /var/log/nginx/access.log 2>/dev/null || echo "Log bulunamadı"
