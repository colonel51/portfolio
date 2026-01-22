#!/bin/bash

# Domain Routing Düzeltme Script'i

echo "=== Domain Routing Düzeltiliyor ==="
echo ""

# 1. Tüm listen ayarlarını kontrol et
echo "1. Listen ayarları:"
echo ""
echo "--- Portfolio ---"
grep "listen" /etc/nginx/sites-available/portfolio
echo ""

echo "--- Kardeslastik ---"
grep "listen" /etc/nginx/sites-available/kardeslastik
echo ""

echo "--- Ozermetal ---"
grep "listen" /etc/nginx/sites-available/ozermetal
echo ""

# 2. Config dosyalarının yüklenme sırası
echo "2. Config dosyalarının yüklenme sırası (alfabetik):"
ls -1 /etc/nginx/sites-enabled/ | sort
echo ""

# 3. Portfolio'yu öncelikli yap
echo "3. Portfolio config'ini öncelikli yapılıyor..."
cd /etc/nginx/sites-enabled

# Mevcut portfolio symlink'ini kaldır
if [ -L "portfolio" ]; then
    rm portfolio
fi

# Öncelikli symlink oluştur (00- ile başlayarak)
ln -s /etc/nginx/sites-available/portfolio 00-portfolio
echo "   Portfolio öncelikli hale getirildi: 00-portfolio"
echo ""

# 4. Nginx test
echo "4. Nginx yapılandırması test ediliyor..."
nginx -t
if [ $? -eq 0 ]; then
    echo "   Nginx yapılandırması geçerli!"
    systemctl reload nginx
    echo "   Nginx yeniden yüklendi!"
else
    echo "   HATA: Nginx yapılandırma hatası!"
    exit 1
fi

echo ""
echo "=== Test Komutları ==="
echo "curl -H 'Host: ramazankarsanba.com' http://161.35.207.182"
echo "curl -H 'Host: kardesdemirlastik.com.tr' http://161.35.207.182"
