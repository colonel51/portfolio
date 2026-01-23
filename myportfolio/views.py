from django.shortcuts import render
from django.http import HttpResponse
from django.conf import settings
from django.templatetags.static import static

def home(request):
    """Ana sayfa - Tek sayfalık portfolio"""
    base_url = "https://ramazankarsanba.com"
    context = {
        'profile_image_url': f"{base_url}{static('images/ramazan.jpg')}",
        'favicon_url': f"{base_url}{static('images/python.webp')}",
        'og_image_url': f"{base_url}{static('images/ramazan.jpg')}",
        'twitter_image_url': f"{base_url}{static('images/ramazan.jpg')}",
    }
    return render(request, 'myportfolio/index.html', context)

def robots_txt(request):
    """robots.txt dosyası - Arama motorları için"""
    lines = [
        "User-agent: *",
        "Allow: /",
        "Disallow: /admin/",
        "",
        f"Sitemap: https://ramazankarsanba.com/sitemap.xml",
    ]
    return HttpResponse("\n".join(lines), content_type="text/plain")

def sitemap_xml(request):
    """sitemap.xml dosyası - Site haritası"""
    from datetime import datetime
    
    # Ana sayfa için sitemap
    sitemap = """<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">
    <url>
        <loc>https://ramazankarsanba.com/</loc>
        <lastmod>{}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>1.0</priority>
    </url>
</urlset>""".format(datetime.now().strftime('%Y-%m-%d'))
    
    return HttpResponse(sitemap, content_type="application/xml")
