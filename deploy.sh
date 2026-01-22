#!/bin/bash

# Portfolio Projesi Deployment Script
# Droplet'te çalıştırın: bash deploy.sh

echo "=== Portfolio Deployment Başlıyor ==="

# 1. Dizin oluştur
echo "1. /opt/Portfolio dizini oluşturuluyor..."
mkdir -p /opt/Portfolio

# 2. Python ve pip kontrolü
echo "2. Python kontrolü..."
python3 --version
pip3 --version

# 3. Virtual environment oluştur
echo "3. Virtual environment oluşturuluyor..."
cd /opt/Portfolio
python3 -m venv venv
source venv/bin/activate

# 4. Gerekli paketleri yükle
echo "4. Paketler yükleniyor..."
pip install --upgrade pip
pip install django==3.2.25 gunicorn

# 5. Proje dosyalarının buraya kopyalanması gerekiyor
echo "5. Proje dosyalarını /opt/Portfolio/ altına kopyalayın!"
echo "   Lokal makineden: scp -r . root@161.35.207.182:/opt/Portfolio/"
read -p "Proje dosyaları kopyalandı mı? (y/n): " files_copied

if [ "$files_copied" != "y" ]; then
    echo "Lütfen önce proje dosyalarını kopyalayın!"
    exit 1
fi

# 6. Settings.py kontrolü
echo "6. Settings.py kontrol ediliyor..."
cd /opt/Portfolio
source venv/bin/activate

# 7. Static files topla
echo "7. Static files toplanıyor..."
python manage.py collectstatic --noinput

# 8. Database migration
echo "8. Database migration yapılıyor..."
python manage.py migrate

# 9. Gunicorn service dosyasını kopyala
echo "9. Gunicorn service dosyası oluşturuluyor..."
cp portfolio.service /etc/systemd/system/portfolio.service
systemctl daemon-reload
systemctl enable portfolio
systemctl start portfolio

# 10. Nginx yapılandırması
echo "10. Nginx yapılandırması..."
cp portfolio_nginx.conf /etc/nginx/sites-available/portfolio
ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/

# 11. Nginx test ve restart
echo "11. Nginx test ediliyor..."
nginx -t
if [ $? -eq 0 ]; then
    systemctl restart nginx
    echo "Nginx başarıyla yeniden başlatıldı!"
else
    echo "Nginx yapılandırma hatası! Lütfen kontrol edin."
    exit 1
fi

# 12. Firewall (gerekirse)
echo "12. Firewall kontrolü..."
ufw allow 8080/tcp

echo ""
echo "=== Deployment Tamamlandı! ==="
echo "Portfolio projesi: http://161.35.207.182:8080"
echo ""
echo "Gunicorn durumu: systemctl status portfolio"
echo "Nginx durumu: systemctl status nginx"
echo "Loglar: journalctl -u portfolio -f"
