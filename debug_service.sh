#!/bin/bash

# Gunicorn Service Debug Script

echo "=== Portfolio Service Debug ==="
echo ""

# 1. Dizin kontrolü
echo "1. Dizin kontrolü:"
echo "   /opt/portfolio var mı: $([ -d /opt/portfolio ] && echo 'EVET' || echo 'HAYIR')"
echo "   /opt/portfolio/venv var mı: $([ -d /opt/portfolio/venv ] && echo 'EVET' || echo 'HAYIR')"
echo ""

# 2. Gunicorn kontrolü
echo "2. Gunicorn kontrolü:"
if [ -f "/opt/portfolio/venv/bin/gunicorn" ]; then
    echo "   Gunicorn dosyası: EVET"
    ls -la /opt/portfolio/venv/bin/gunicorn
    echo "   Gunicorn versiyonu:"
    /opt/portfolio/venv/bin/gunicorn --version
else
    echo "   Gunicorn dosyası: HAYIR - Yükleniyor..."
    cd /opt/portfolio
    source venv/bin/activate
    pip install gunicorn
fi
echo ""

# 3. Service dosyası kontrolü
echo "3. Service dosyası kontrolü:"
if [ -f "/etc/systemd/system/portfolio.service" ]; then
    echo "   Service dosyası: EVET"
    echo "   İçerik:"
    cat /etc/systemd/system/portfolio.service
else
    echo "   Service dosyası: HAYIR"
fi
echo ""

# 4. Service durumu
echo "4. Service durumu:"
systemctl status portfolio --no-pager -l
echo ""

# 5. Log kontrolü
echo "5. Son loglar:"
journalctl -u portfolio -n 20 --no-pager
echo ""

# 6. Manuel test
echo "6. Manuel gunicorn testi:"
cd /opt/portfolio
source venv/bin/activate
echo "   Working directory: $(pwd)"
echo "   Python: $(which python)"
echo "   Gunicorn: $(which gunicorn)"
echo ""
echo "   Manuel başlatma testi (5 saniye):"
timeout 5 /opt/portfolio/venv/bin/gunicorn --bind 127.0.0.1:8001 portfolio.wsgi:application || echo "   Manuel test tamamlandı"
echo ""

# 7. Öneriler
echo "=== Öneriler ==="
echo "1. Eğer gunicorn yüklü değilse: cd /opt/portfolio && source venv/bin/activate && pip install gunicorn"
echo "2. Service dosyasını yeniden yüklemek için: systemctl daemon-reload"
echo "3. Service'i yeniden başlatmak için: systemctl restart portfolio"
echo "4. Detaylı loglar için: journalctl -u portfolio -f"
