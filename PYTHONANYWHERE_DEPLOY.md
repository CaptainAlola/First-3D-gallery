# 🚀 Деплой на PythonAnywhere

## Быстрые команды для PythonAnywhere Bash консоли

### 1️⃣ Клонирование репозитория
```bash
git clone https://github.com/CaptainAlola/First\ 3D\ gallery.git
cd "First 3D gallery"
```

### 2️⃣ Создание виртуального окружения
```bash
mkvirtualenv --python=/usr/bin/python3.10 myenv
pip install -r requirements.txt
```

### 3️⃣ Создание .env файла
```bash
nano .env
```

Вставьте:
```
SECRET_KEY=django-insecure-v0i6@k!7r(2shy1bbm^x3bfsa**wr58wtm8$6nw@i8s!dr93qe
DEBUG=False
ALLOWED_HOSTS=CaptainAlola.pythonanywhere.com
```

Сохранить: `Ctrl+O`, `Enter`, `Ctrl+X`

### 4️⃣ Миграция БД и статика
```bash
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
```

### 5️⃣ Настройка Web App на PythonAnywhere

**Вкладка Web → Add new web app → Manual configuration → Python 3.10**

#### Virtualenv:
```
/home/CaptainAlola/.virtualenvs/myenv
```

#### Source code:
```
/home/CaptainAlola/First\ 3D\ gallery
```

#### WSGI файл:
Замените путь на:
```
/var/www/captainalola_pythonanywhere_com_wsgi.py
```

Содержимое WSGI файла:
```python
import os
import sys

path = '/home/CaptainAlola/First\ 3D\ gallery'
if path not in sys.path:
    sys.path.append(path)

from dotenv import load_dotenv
project_folder = os.path.expanduser('~/First\ 3D\ gallery')
load_dotenv(os.path.join(project_folder, '.env'))

os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

### 6️⃣ Перезагрузка и HTTPS
- Вкладка Web → **Reload**
- Web → Security → Force HTTPS (включить) ✅

### ✨ Готово!
Ваш сайт будет доступен по: **https://CaptainAlola.pythonanywhere.com**

---

## 🔗 Ссылки
- [PythonAnywhere](https://www.pythonanywhere.com/)
- [Документация](https://help.pythonanywhere.com/)
