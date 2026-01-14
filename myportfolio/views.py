from django.shortcuts import render

def home(request):
    """Ana sayfa - Tek sayfalık portfolio"""
    return render(request, 'myportfolio/index.html')
