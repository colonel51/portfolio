# Portfolio Projesi Deployment Rehberi

## 1. Droplet'e Proje Yükleme

### GitHub'dan Clone (Önerilen)
```bash
# Droplet'te
cd /opt
git clone https://github.com/colonel51/portfolio.git Portfolio
cd Portfolio
```

### İlk Deployment (Otomatik Script)
```bash
# Droplet'te deploy.sh script'ini çalıştırın
cd /opt/Portfolio
bash deploy.sh
```

### Manuel Deployment
Eğer script kullanmak istemiyorsanız, aşağıdaki adımları takip edin.

## 2. Python Virtual Environment Kurulumu

```bash
cd /opt/Portfolio
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install django gunicorn
# requirements.txt varsa:
# pip install -r requirements.txt
```

## 3. Settings.py Güncelleme

`portfolio/settings.py` dosyasında şu değişiklikleri yapın:

```python
DEBUG = False
ALLOWED_HOSTS = ['YOUR_DOMAIN_OR_IP', '161.35.207.182']

# Static files
STATIC_ROOT = BASE_DIR / 'staticfiles'
```

## 4. Static Files Toplama

```bash
cd /opt/Portfolio
source venv/bin/activate
python manage.py collectstatic --noinput
```

## 5. Database Migration

```bash
python manage.py migrate
```

## 6. Gunicorn Systemd Service Oluşturma

`/etc/systemd/system/portfolio.service` dosyası oluşturun:

```ini
[Unit]
Description=Portfolio Gunicorn daemon
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=/opt/Portfolio
Environment="PATH=/opt/Portfolio/venv/bin"
ExecStart=/opt/Portfolio/venv/bin/gunicorn \
    --workers 3 \
    --bind unix:/opt/Portfolio/gunicorn.sock \
    --timeout 120 \
    portfolio.wsgi:application

[Install]
WantedBy=multi-user.target
```

Service'i başlatın:
```bash
sudo systemctl daemon-reload
sudo systemctl start portfolio
sudo systemctl enable portfolio
```

## 7. Nginx Yapılandırması

```bash
# Nginx config dosyasını kopyala
sudo cp portfolio_nginx.conf /etc/nginx/sites-available/portfolio

# Domain/IP'yi düzenle
sudo nano /etc/nginx/sites-available/portfolio

# Symlink oluştur
sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/

# Nginx test et
sudo nginx -t

# Nginx restart
sudo systemctl restart nginx
```

## 8. Firewall Ayarları (Gerekirse)

```bash
sudo ufw allow 'Nginx Full'
```

## 9. SSL Sertifikası (Domain varsa)

```bash
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

## 10. Projeyi Güncelleme (GitHub'dan)

### Hızlı Güncelleme (Otomatik Script)
```bash
# Droplet'te
cd /opt/Portfolio
bash update.sh
```

### Manuel Güncelleme
```bash
cd /opt/Portfolio
git pull origin main
source venv/bin/activate
pip install -r requirements.txt --upgrade
python manage.py collectstatic --noinput
python manage.py migrate
systemctl restart portfolio
```

## 11. GitHub'a Değişiklikleri Push Etme

### Lokal Makineden
```bash
git add .
git commit -m "Değişiklik açıklaması"
git push origin main
```

### Droplet'te Güncelleme
```bash
cd /opt/Portfolio
bash update.sh
```
