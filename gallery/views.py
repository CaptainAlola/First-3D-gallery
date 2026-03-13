#from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.contrib import messages
from .forms import AssetForm
# request — это "письмо" от браузера с данными о пользователе
#def home(request):
    # Мы пока не используем HTML-шаблоны, просто вернем строку.
#    return HttpResponse("<h1>Добро пожаловать в 3D Хранилище</h1><p>Система работает.</p>")
def about(request):
    faker = [
        {'id': 1, 'name': 'Буторин Матвей'},
]
    context_data = {
        'page_title': 'О проекте',
        'assets': faker, # Передаем весь список
    }
    return render(request, 'gallery/about.html', context_data)

#def home(request):
    # Имитация данных из базы (список словарей)
 #   fake_database = [
  #      {'id': 1, 'name': 'Sci-Fi Helmet', 'file_size': '15 MB'},
   #     {'id': 2, 'name': 'Old Chair', 'file_size': '2 MB'},
    #    {'id': 3, 'name': 'Cyber Truck', 'file_size': '10 MB'},
     #   {'id': 3, 'name': 'Fake Faker', 'file_size': '15 MB'},
#]
   # context_data = {
    #    'page_title': 'Главная Галерея',
     #   'assets': fake_database, # Передаем весь список
    #}
    #return render(request, 'gallery/index.html', context_data)

from django.shortcuts import render
from .models import Asset
from django.db.models import Q
from django.core.paginator import Paginator
from django.http import QueryDict

def home(request):
    # 1. Получаем параметры из URL (GET-запроса)
    search_query = request.GET.get('q', '').strip()
    ordering = request.GET.get('ordering', 'new')
    
    # 2. Базовый запрос: Берем ВСЕ
    assets = Asset.objects.all()
    
    # 3. Применяем поиск (если пользователь что-то ввел)
    if search_query:
        # icontains = Case Insensitive Contains (содержит, без учета регистра)
        assets = assets.filter(title__icontains=search_query)
    
    # 4. Применяем сортировку
    if ordering == 'old':
        assets = assets.order_by('created_at')  # От старых к новым
    elif ordering == 'name':
        assets = assets.order_by('title')  # По алфавиту
    else:
        # По умолчанию (new) - свежие сверху
        assets = assets.order_by('-created_at')
    
    # 5. ПАГИНАЦИЯ - режем список по 9 штук на страницу
    paginator = Paginator(assets, 9)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    # 6. Создаем query_string для пагинации (сохраняет все параметры кроме page)
    query_string = QueryDict('', mutable=True)
    if search_query:
        query_string['q'] = search_query
    if ordering != 'new':
        query_string['ordering'] = ordering
    query_string_encoded = query_string.urlencode()
    
    # 7. Отдаем результат
    context_data = {
        'page_title': 'Главная Галерея',
        'page_obj': page_obj,
        'query_string': query_string_encoded,  # "q=test&ordering=old"
    }
    return render(request, 'gallery/index.html', context_data)

import base64
from django.core.files.base import ContentFile  # обертка для сохранения файла


def upload(request):
    if request.method == 'POST':
        form = AssetForm(request.POST, request.FILES)
        if form.is_valid():
            # Создаем объект, но пока не сохраняем (commit=False), чтобы подставить картинку
            new_asset = form.save(commit=False)

            # Скрытое поле, куда JS класть Base64-строку
            image_data = request.POST.get('image_data')
            if image_data:
                # строка имеет вид "data:image/jpeg;base64,..."
                format, imgstr = image_data.split(';base64,')
                ext = format.split('/')[-1]  # jpeg, png и т.д.
                data = base64.b64decode(imgstr)
                file_name = f"{new_asset.title}_thumb.{ext}"
                new_asset.image.save(file_name, ContentFile(data), save=False)

            new_asset.save()
            messages.success(request, f'Модель "{new_asset.title}" успешно загружена! ✅')
            return redirect('home')
    else:
        form = AssetForm()
    return render(request, 'gallery/upload.html', {'form': form})
