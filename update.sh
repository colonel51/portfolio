#!/bin/bash

# Portfolio Projesi Hızlı Güncelleme Script
# GitHub'dan son değişiklikleri çeker ve servisleri yeniden başlatır

echo "=== Portfolio Güncelleme Başlıyor ==="

cd /opt/Portfolio

# 1. Git pull
echo "1. GitHub'dan güncellemeler çekiliyor..."
git pull origin main

if [ $? -ne 0 ]; then
    echo "Git pull başarısız! Lütfen kontrol edin."
    exit 1
fi

# 2. Virtual environment aktif et
echo "2. Virtual environment aktif ediliyor..."
source venv/bin/activate

# 3. Yeni paketler varsa yükle
echo "3. Paketler kontrol ediliyor..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt --upgrade
fi

# 4. Static files topla
echo "4. Static files toplanıyor..."
python manage.py collectstatic --noinput

# 5. Database migration
echo "5. Database migration yapılıyor..."
python manage.py migrate

# 6. Gunicorn service dosyası güncellenmişse kopyala
if [ -f "portfolio.service" ]; then
    echo "6. Gunicorn service dosyası güncelleniyor..."
    cp portfolio.service /etc/systemd/system/portfolio.service
    systemctl daemon-reload
fi

# 7. Nginx config güncellenmişse kopyala
if [ -f "portfolio_nginx.conf" ]; then
    echo "7. Nginx yapılandırması güncelleniyor..."
    cp portfolio_nginx.conf /etc/nginx/sites-available/portfolio
    nginx -t
    if [ $? -eq 0 ]; then
        systemctl reload nginx
        echo "   Nginx yapılandırması güncellendi!"
    else
        echo "   Nginx yapılandırma hatası! Değişiklikler uygulanmadı."
    fi
fi

# 8. Gunicorn restart
echo "8. Gunicorn yeniden başlatılıyor..."
systemctl restart portfolio

# 9. Durum kontrolü
echo ""
echo "=== Güncelleme Tamamlandı! ==="
echo "Gunicorn durumu:"
systemctl status portfolio --no-pager -l
echo ""
echo "Son güncellemeleri görmek için: git log --oneline -5"
