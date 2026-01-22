#!/bin/bash

# Portfolio Projesi Restart Script
# Kullanım: sudo bash restart.sh

echo "=== Portfolio Servisi Yeniden Başlatılıyor ==="

# 1. Proje dizinine git
cd /opt/portfolio || exit 1

# 2. Virtual environment'ı aktif et
source venv/bin/activate

# 3. Static dosyaları topla (eğer değişiklik varsa)
echo "1. Static dosyalar toplanıyor..."
python manage.py collectstatic --noinput

# 4. Gunicorn servisini restart et
echo "2. Gunicorn servisi yeniden başlatılıyor..."
systemctl restart portfolio

# 5. Servis durumunu kontrol et
echo "3. Servis durumu kontrol ediliyor..."
sleep 2
systemctl status portfolio --no-pager -l

# 6. Nginx'i reload et (gerekirse)
echo "4. Nginx reload ediliyor..."
nginx -t && systemctl reload nginx

echo ""
echo "=== Restart Tamamlandı ==="
echo "Servis durumunu kontrol etmek için: sudo systemctl status portfolio"
echo "Logları görmek için: sudo journalctl -u portfolio -f"