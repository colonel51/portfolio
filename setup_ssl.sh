#!/bin/bash

# SSL Sertifikası Kurulum Script'i
# Domain: ramazankarsanba.com

echo "=== SSL Sertifikası Kurulumu ==="
echo "Domain: ramazankarsanba.com"
echo ""

# 1. Certbot yüklü mü kontrol et
echo "1. Certbot kontrolü..."
if ! command -v certbot &> /dev/null; then
    echo "   Certbot yüklü değil, yükleniyor..."
    apt-get update
    apt-get install -y certbot python3-certbot-nginx
else
    echo "   Certbot zaten yüklü."
fi

# 2. Nginx config'inin doğru olduğundan emin ol
echo "2. Nginx yapılandırması kontrol ediliyor..."
if [ ! -f "/etc/nginx/sites-available/portfolio" ]; then
    echo "   HATA: Nginx config dosyası bulunamadı!"
    exit 1
fi

# 3. Nginx test
echo "3. Nginx yapılandırması test ediliyor..."
nginx -t
if [ $? -ne 0 ]; then
    echo "   HATA: Nginx yapılandırma hatası! Lütfen düzeltin."
    exit 1
fi

# 4. Domain DNS kontrolü
echo "4. Domain DNS kontrolü..."
echo "   Lütfen domain'in DNS ayarlarını kontrol edin:"
echo "   - A Record: ramazankarsanba.com -> 161.35.207.182"
echo "   - A Record: www.ramazankarsanba.com -> 161.35.207.182"
echo ""
read -p "   DNS ayarları tamamlandı mı? (y/n): " dns_ready

if [ "$dns_ready" != "y" ]; then
    echo "   Lütfen önce DNS ayarlarını yapın!"
    exit 1
fi

# 5. SSL sertifikası kurulumu
echo "5. SSL sertifikası kuruluyor..."
certbot --nginx -d ramazankarsanba.com -d www.ramazankarsanba.com --non-interactive --agree-tos --email rkarsanba0@gmail.com

if [ $? -eq 0 ]; then
    echo ""
    echo "=== SSL Sertifikası Başarıyla Kuruldu! ==="
    echo "Site artık https://ramazankarsanba.com adresinden erişilebilir."
    echo ""
    echo "Sertifika otomatik yenileme kontrolü:"
    systemctl status certbot.timer
    echo ""
    echo "Manuel yenileme testi: certbot renew --dry-run"
else
    echo ""
    echo "=== SSL Kurulumu Başarısız! ==="
    echo "Lütfen hata mesajlarını kontrol edin."
    exit 1
fi
