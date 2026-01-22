// Matrix Rain Effect
function initMatrix() {
    const canvas = document.getElementById('matrixCanvas');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    
    const matrix = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789@#$%^&*()*&^%+-/~{[|`]}";
    const matrixArray = matrix.split("");
    
    const fontSize = 14;
    const columns = canvas.width / fontSize;
    
    const drops = [];
    for (let x = 0; x < columns; x++) {
        drops[x] = 1;
    }
    
    let animationFrameId;
    let lastTime = 0;
    const targetFPS = 30;
    const frameInterval = 1000 / targetFPS;
    
    function draw(currentTime) {
        if (!currentTime) currentTime = performance.now();
        const elapsed = currentTime - lastTime;
        
        if (elapsed >= frameInterval) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.04)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            ctx.fillStyle = '#00ff41';
            ctx.font = fontSize + 'px monospace';
            
            for (let i = 0; i < drops.length; i++) {
                const text = matrixArray[Math.floor(Math.random() * matrixArray.length)];
                ctx.fillText(text, i * fontSize, drops[i] * fontSize);
                
                if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                    drops[i] = 0;
                }
                drops[i]++;
            }
            
            lastTime = currentTime - (elapsed % frameInterval);
        }
        
        animationFrameId = requestAnimationFrame(draw);
    }
    
    animationFrameId = requestAnimationFrame(draw);
    
    let resizeTimeout;
    window.addEventListener('resize', () => {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(() => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }, 250);
    });
    
    return () => {
        if (animationFrameId) {
            cancelAnimationFrame(animationFrameId);
        }
    };
}

// Loading Screen Control
document.addEventListener('DOMContentLoaded', function() {
    const loadingScreen = document.getElementById('loadingScreen');
    let stopMatrix;
    
    // Start Matrix animation
    if (loadingScreen) {
        stopMatrix = initMatrix();
    }
    
    // Hide loading screen when page is fully loaded
    window.addEventListener('load', function() {
        // Minimum loading time for better UX (1.5 seconds)
        setTimeout(function() {
            if (loadingScreen) {
                loadingScreen.classList.add('hidden');
                if (stopMatrix) {
                    stopMatrix();
                }
                // Remove from DOM after animation
                setTimeout(function() {
                    if (loadingScreen && loadingScreen.parentNode) {
                        loadingScreen.remove();
                    }
                }, 800);
            }
        }, 1500);
    });
    
    // Fallback: Hide after 3 seconds even if load event doesn't fire
    setTimeout(function() {
        if (loadingScreen && !loadingScreen.classList.contains('hidden')) {
            loadingScreen.classList.add('hidden');
            if (stopMatrix) {
                stopMatrix();
            }
            setTimeout(function() {
                if (loadingScreen && loadingScreen.parentNode) {
                    loadingScreen.remove();
                }
            }, 800);
        }
    }, 3000);
});

// Typewriter Effect
const textElement = document.querySelector('.typewriter-text');
const texts = ['Python & Django Developer', 'Software Architect', 'Full Stack Engineer', 'AI/ML Enthusiast'];
let count = 0;
let index = 0;
let currentText = '';
let letter = '';

(function type() {
    if (textElement) {
        if (count === texts.length) { count = 0; }
        currentText = texts[count];
        letter = currentText.slice(0, ++index);

        textElement.textContent = letter;
        if (letter.length === currentText.length) {
            count++;
            index = 0;
            setTimeout(type, 2000); // Yazı bitince 2 saniye bekle
        } else {
            setTimeout(type, 100); // Yazma hızı
        }
    }
})();

// Navbar scroll effect - hide on scroll down, show on scroll up (throttled)
let lastScrollTop = 0;
let ticking = false;
const navbar = document.getElementById('mainNav');

function updateNavbar() {
    if (!navbar) return;
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    
    // Scrolled class for styling
    if (scrollTop > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
    
    // Hide/show navbar on scroll
    if (scrollTop > lastScrollTop && scrollTop > 100) {
        // Scrolling down - hide navbar
        navbar.style.transform = 'translateY(-100%)';
        navbar.style.transition = 'transform 0.3s ease-in-out';
    } else {
        // Scrolling up - show navbar
        navbar.style.transform = 'translateY(0)';
        navbar.style.transition = 'transform 0.3s ease-in-out';
    }
    
    lastScrollTop = scrollTop;
    ticking = false;
}

window.addEventListener('scroll', function() {
    if (!ticking) {
        window.requestAnimationFrame(updateNavbar);
        ticking = true;
    }
});

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const offsetTop = target.offsetTop - 70;
            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });
        }
    });
});

// Active nav link on scroll
window.addEventListener('scroll', function() {
    let current = '';
    const sections = document.querySelectorAll('section[id]');
    
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (window.pageYOffset >= (sectionTop - 200)) {
            current = section.getAttribute('id');
        }
    });
    
    document.querySelectorAll('.navbar-nav .nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});

// Animate progress bars on scroll
const observerOptions = {
    threshold: 0.5,
    rootMargin: '0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const progressBar = entry.target.querySelector('.progress-bar');
            if (progressBar) {
                const width = progressBar.style.width;
                progressBar.style.width = '0%';
                setTimeout(() => {
                    progressBar.style.width = width;
                }, 100);
            }
        }
    });
}, observerOptions);

document.querySelectorAll('.skill-item').forEach(item => {
    observer.observe(item);
});

// WhatsApp Form submission
const contactForm = document.getElementById('contactForm');
if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Form verilerini al
        const name = document.getElementById('contactName').value.trim();
        const email = document.getElementById('contactEmail').value.trim();
        const subject = document.getElementById('contactSubject').value.trim();
        const message = document.getElementById('contactMessage').value.trim();
        
        // Validasyon
        if (!name || !email || !subject || !message) {
            Swal.fire({
                icon: 'warning',
                title: 'Eksik Bilgi',
                text: 'Lütfen tüm alanları doldurun.',
                confirmButtonColor: '#0d6efd',
                confirmButtonText: 'Tamam'
            });
            return;
        }
        
        // WhatsApp mesaj formatı (emoji'ler kaldırıldı - encoding sorunu nedeniyle)
        const whatsappMessage = `Merhaba Ramazan,

Portfolio sitenizden iletişim formu:

Ad Soyad: ${name}
E-posta: ${email}
Konu: ${subject}

Mesaj:
${message}`;
        
        // WhatsApp link formatı (telefon numarası: +905338452360)
        const phoneNumber = '905338452360'; // +90 kodu olmadan
        // Emoji'leri düzgün encode etmek için önce UTF-8'e çeviriyoruz
        const encodedMessage = encodeURIComponent(whatsappMessage);
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodedMessage}`;
        
        // WhatsApp Web'i yeni sekmede aç
        window.open(whatsappUrl, '_blank');
        
        // Formu temizle
        contactForm.reset();
        
        // Kullanıcıya modern bilgi mesajı
        Swal.fire({
            icon: 'success',
            title: 'WhatsApp Açılıyor!',
            html: 'Mesajınız hazırlandı. WhatsApp\'ta <strong>"Gönder"</strong> butonuna tıklayarak mesajınızı gönderebilirsiniz.',
            confirmButtonColor: '#25D366',
            confirmButtonText: 'Tamam',
            timer: 5000,
            timerProgressBar: true
        });
    });
}

// Add fade-in animation on scroll
const fadeElements = document.querySelectorAll('.service-card, .portfolio-card, .info-card');
const fadeObserver = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, {
    threshold: 0.1
});

fadeElements.forEach(element => {
    element.style.opacity = '0';
    element.style.transform = 'translateY(30px)';
    element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    fadeObserver.observe(element);
});

// Teklif Al Form submission
const quoteForm = document.getElementById('quoteForm');
const submitQuoteBtn = document.getElementById('submitQuoteBtn');

if (submitQuoteBtn && quoteForm) {
    submitQuoteBtn.addEventListener('click', function(e) {
        e.preventDefault();
        
        // Form verilerini al
        const name = document.getElementById('quoteName').value.trim();
        const email = document.getElementById('quoteEmail').value.trim();
        const phone = document.getElementById('quotePhone').value.trim();
        const company = document.getElementById('quoteCompany').value.trim();
        const projectType = document.getElementById('quoteProjectType').value;
        const budget = document.getElementById('quoteBudget').value;
        const timeline = document.getElementById('quoteTimeline').value;
        const description = document.getElementById('quoteDescription').value.trim();
        const agree = document.getElementById('quoteAgree').checked;
        
        // Validasyon
        if (!name || !email || !phone || !projectType || !budget || !timeline || !description) {
            Swal.fire({
                icon: 'warning',
                title: 'Eksik Bilgi',
                text: 'Lütfen zorunlu alanları doldurun.',
                confirmButtonColor: '#0d6efd',
                confirmButtonText: 'Tamam'
            });
            return;
        }
        
        if (!agree) {
            Swal.fire({
                icon: 'warning',
                title: 'Onay Gerekli',
                text: 'Lütfen gizlilik politikasını kabul edin.',
                confirmButtonColor: '#0d6efd',
                confirmButtonText: 'Tamam'
            });
            return;
        }
        
        // WhatsApp mesaj formatı
        let whatsappMessage = `Merhaba Ramazan,

Portfolio sitenizden proje teklifi formu:

*İletişim Bilgileri:*
Ad Soyad: ${name}
E-posta: ${email}
Telefon: ${phone}${company ? `\nŞirket: ${company}` : ''}

*Proje Detayları:*
Proje Türü: ${projectType}
Bütçe Aralığı: ${budget}
Zaman Çerçevesi: ${timeline}

*Proje Açıklaması:*
${description}

Teşekkürler!`;
        
        // WhatsApp link formatı
        const phoneNumber = '905338452360';
        const encodedMessage = encodeURIComponent(whatsappMessage);
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodedMessage}`;
        
        // WhatsApp Web'i yeni sekmede aç
        window.open(whatsappUrl, '_blank');
        
        // Formu temizle
        quoteForm.reset();
        
        // Modal'ı kapat
        const quoteModal = bootstrap.Modal.getInstance(document.getElementById('quoteModal'));
        if (quoteModal) {
            quoteModal.hide();
        }
        
        // Kullanıcıya bilgi mesajı
        Swal.fire({
            icon: 'success',
            title: 'Teklif Formu Gönderildi!',
            html: 'Mesajınız hazırlandı. WhatsApp\'ta <strong>"Gönder"</strong> butonuna tıklayarak teklif talebinizi gönderebilirsiniz.',
            confirmButtonColor: '#25D366',
            confirmButtonText: 'Tamam',
            timer: 5000,
            timerProgressBar: true
        });
    });
}

// Mobile menu close on link click
document.querySelectorAll('.navbar-nav .nav-link').forEach(link => {
    link.addEventListener('click', function() {
        const navbarCollapse = document.querySelector('.navbar-collapse');
        if (navbarCollapse.classList.contains('show')) {
            const bsCollapse = new bootstrap.Collapse(navbarCollapse);
            bsCollapse.hide();
        }
    });
});

// Theme Toggle Functionality
(function() {
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const html = document.documentElement;
    
    // Get saved theme or detect system preference
    function getInitialTheme() {
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            return savedTheme;
        }
        // Check system preference
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) {
            return 'light';
        }
        return 'dark'; // Default to dark
    }
    
    // Apply theme
    function setTheme(theme) {
        html.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        
        // Update icon
        if (themeIcon) {
            if (theme === 'light') {
                themeIcon.classList.remove('bi-moon-fill');
                themeIcon.classList.add('bi-sun-fill');
            } else {
                themeIcon.classList.remove('bi-sun-fill');
                themeIcon.classList.add('bi-moon-fill');
            }
        }
    }
    
    // Initialize theme on page load (only if not already set by inline script)
    if (!html.getAttribute('data-theme')) {
        const initialTheme = getInitialTheme();
        setTheme(initialTheme);
    } else {
        // Theme already set by inline script, just update icon
        const currentTheme = html.getAttribute('data-theme');
        if (themeIcon) {
            if (currentTheme === 'light') {
                themeIcon.classList.remove('bi-moon-fill');
                themeIcon.classList.add('bi-sun-fill');
            } else {
                themeIcon.classList.remove('bi-sun-fill');
                themeIcon.classList.add('bi-moon-fill');
            }
        }
    }
    
    // Toggle theme on button click
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            const currentTheme = html.getAttribute('data-theme');
            const newTheme = currentTheme === 'light' ? 'dark' : 'light';
            setTheme(newTheme);
        });
    }
    
    // Listen for system theme changes
    if (window.matchMedia) {
        const mediaQuery = window.matchMedia('(prefers-color-scheme: light)');
        mediaQuery.addEventListener('change', function(e) {
            // Only auto-switch if user hasn't manually set a preference
            if (!localStorage.getItem('theme')) {
                setTheme(e.matches ? 'light' : 'dark');
            }
        });
    }
})();

// Scroll to Top Button
(function() {
    const scrollToTopBtn = document.getElementById('scrollToTop');
    
    if (!scrollToTopBtn) return;
    
    // Show/hide button based on scroll position
    function toggleScrollButton() {
        if (window.pageYOffset > 300) {
            scrollToTopBtn.classList.add('show');
        } else {
            scrollToTopBtn.classList.remove('show');
        }
    }
    
    // Throttled scroll event
    let ticking = false;
    window.addEventListener('scroll', function() {
        if (!ticking) {
            window.requestAnimationFrame(function() {
                toggleScrollButton();
                ticking = false;
            });
            ticking = true;
        }
    });
    
    // Scroll to top on click
    scrollToTopBtn.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
    
    // Initial check
    toggleScrollButton();
})();

// Parallax Effect for Hero Section
(function() {
    const heroSection = document.querySelector('.hero-section');
    const heroContent = document.querySelector('.hero-content');
    const heroImage = document.querySelector('.hero-image');
    
    if (!heroSection || !heroContent) return;
    
    // Only enable parallax on desktop (performance)
    if (window.innerWidth < 768) return;
    
    let ticking = false;
    
    function updateParallax() {
        const scrolled = window.pageYOffset;
        const heroHeight = heroSection.offsetHeight;
        
        // Only apply parallax when hero is in view
        if (scrolled < heroHeight) {
            const parallaxSpeed = 0.5;
            const contentOffset = scrolled * parallaxSpeed;
            const imageOffset = scrolled * 0.3;
            
            if (heroContent) {
                heroContent.style.transform = `translateY(${contentOffset}px) translateZ(0)`;
            }
            
            if (heroImage) {
                heroImage.style.transform = `translateY(${imageOffset}px) translateZ(0)`;
            }
        }
        
        ticking = false;
    }
    
    window.addEventListener('scroll', function() {
        if (!ticking) {
            window.requestAnimationFrame(updateParallax);
            ticking = true;
        }
    });
    
    // Reset on resize
    let resizeTimeout;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(function() {
            if (window.innerWidth < 768) {
                if (heroContent) heroContent.style.transform = '';
                if (heroImage) heroImage.style.transform = '';
            }
        }, 250);
    });
})();
