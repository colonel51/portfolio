#!/bin/bash

# Dynamic Projesini Kaldırma Script'i

echo "=== Dynamic Projesi Kaldırılıyor ==="

# 1. Dynamic service'i durdur ve kaldır
echo "1. Dynamic Gunicorn service durduruluyor..."
if systemctl is-active --quiet dynamic; then
    systemctl stop dynamic
    systemctl disable dynamic
    echo "   Dynamic service durduruldu."
else
    echo "   Dynamic service zaten çalışmıyor."
fi

# Service dosyasını kaldır
if [ -f "/etc/systemd/system/dynamic.service" ]; then
    rm /etc/systemd/system/dynamic.service
    systemctl daemon-reload
    echo "   Dynamic service dosyası kaldırıldı."
fi

# 2. Dynamic nginx config'ini kaldır
echo "2. Dynamic nginx yapılandırması kaldırılıyor..."
if [ -f "/etc/nginx/sites-enabled/dynamic" ]; then
    rm /etc/nginx/sites-enabled/dynamic
    echo "   Dynamic nginx symlink kaldırıldı."
fi

if [ -f "/etc/nginx/sites-available/dynamic" ]; then
    rm /etc/nginx/sites-available/dynamic
    echo "   Dynamic nginx config dosyası kaldırıldı."
fi

# 3. Dynamic proje dizinini yedekle (isteğe bağlı)
echo "3. Dynamic proje dizini kontrol ediliyor..."
if [ -d "/opt/Dynamic" ]; then
    read -p "   /opt/Dynamic dizinini silmek istiyor musunuz? (y/n): " delete_dir
    if [ "$delete_dir" = "y" ]; then
        echo "   /opt/Dynamic dizini yedekleniyor..."
        mv /opt/Dynamic /opt/Dynamic.backup.$(date +%Y%m%d_%H%M%S)
        echo "   Dizin yedeklendi: /opt/Dynamic.backup.*"
    else
        echo "   Dizin korundu: /opt/Dynamic"
    fi
fi

# 4. Nginx test ve restart
echo "4. Nginx yapılandırması test ediliyor..."
nginx -t
if [ $? -eq 0 ]; then
    systemctl reload nginx
    echo "   Nginx başarıyla yeniden yüklendi!"
else
    echo "   Nginx yapılandırma hatası! Lütfen kontrol edin."
    exit 1
fi

echo ""
echo "=== Dynamic Projesi Kaldırıldı ==="
echo "Portfolio artık port 80'de çalışacak."
