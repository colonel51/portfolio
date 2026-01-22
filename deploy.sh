#!/bin/bash

# Portfolio Projesi Deployment Script
# Droplet'te çalıştırın: bash deploy.sh

echo "=== Portfolio Deployment Başlıyor ==="

# 1. Git kontrolü
echo "1. Git kontrolü..."
if ! command -v git &> /dev/null; then
    echo "Git yüklü değil, yükleniyor..."
    apt-get update
    apt-get install -y git
fi

# 2. Projeyi GitHub'dan clone veya pull et
echo "2. GitHub'dan proje güncelleniyor..."
if [ -d "/opt/portfolio/.git" ]; then
    echo "   Mevcut repo bulundu, pull yapılıyor..."
    cd /opt/portfolio
    git pull origin main
else
    echo "   Repo bulunamadı, clone yapılıyor..."
    if [ -d "/opt/portfolio" ]; then
        echo "   /opt/portfolio dizini mevcut, yedekleniyor..."
        mv /opt/portfolio /opt/portfolio.backup.$(date +%Y%m%d_%H%M%S)
    fi
    git clone https://github.com/colonel51/portfolio.git /opt/portfolio
fi

# 3. Python ve pip kontrolü
echo "3. Python kontrolü..."
python3 --version
pip3 --version

# 4. Virtual environment oluştur veya kontrol et
echo "4. Virtual environment kontrol ediliyor..."
cd /opt/portfolio
if [ ! -d "venv" ]; then
    echo "   Virtual environment oluşturuluyor..."
    python3 -m venv venv
fi
source venv/bin/activate

# 5. Gerekli paketleri yükle
echo "5. Paketler yükleniyor..."
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    pip install django==3.2.25 gunicorn
fi

# 6. Settings.py kontrolü
echo "6. Settings.py kontrol ediliyor..."
cd /opt/portfolio
source venv/bin/activate

# 7. Static files topla
echo "7. Static files toplanıyor..."
python manage.py collectstatic --noinput

# 8. Database migration
echo "8. Database migration yapılıyor..."
python manage.py migrate

# 9. Log dizini oluştur
echo "9. Log dizini oluşturuluyor..."
mkdir -p /opt/portfolio/logs
chmod 755 /opt/portfolio/logs

# 10. Gunicorn kontrolü
echo "10. Gunicorn kontrol ediliyor..."
if [ ! -f "/opt/portfolio/venv/bin/gunicorn" ]; then
    echo "   Gunicorn bulunamadı, yeniden yükleniyor..."
    pip install gunicorn
fi
echo "   Gunicorn yolu: $(which gunicorn)"
/opt/portfolio/venv/bin/gunicorn --version

# 11. Gunicorn service dosyasını kopyala
echo "11. Gunicorn service dosyası oluşturuluyor..."
cp portfolio.service /etc/systemd/system/portfolio.service
systemctl daemon-reload
systemctl enable portfolio

# 12. Service'i başlat ve kontrol et
echo "12. Gunicorn service başlatılıyor..."
systemctl start portfolio
sleep 2
systemctl status portfolio --no-pager -l

# 13. Nginx yapılandırması
echo "13. Nginx yapılandırması..."
cp portfolio_nginx.conf /etc/nginx/sites-available/portfolio
ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/

# 14. Nginx test ve restart
echo "14. Nginx test ediliyor..."
nginx -t
if [ $? -eq 0 ]; then
    systemctl restart nginx
    echo "Nginx başarıyla yeniden başlatıldı!"
else
    echo "Nginx yapılandırma hatası! Lütfen kontrol edin."
    exit 1
fi

# 15. Firewall (gerekirse)
echo "15. Firewall kontrolü..."
ufw allow 8080/tcp

echo ""
echo "=== Deployment Tamamlandı! ==="
echo "Portfolio projesi: http://161.35.207.182:8080"
echo ""
echo "Gunicorn durumu: systemctl status portfolio"
echo "Nginx durumu: systemctl status nginx"
echo "Loglar: journalctl -u portfolio -f"
