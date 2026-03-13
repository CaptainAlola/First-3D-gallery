# WSGI configuration for PythonAnywhere
# Copy this to: /var/www/your_username_pythonanywhere_com_wsgi.py
# Replace "your_username" with your actual PythonAnywhere username

import os
import sys

# 1. Add project folder to Python path
# This allows Django to find your modules
path = '/home/YOUR_USERNAME/web-structures-course'
if path not in sys.path:
    sys.path.append(path)

# 2. Load environment variables from .env file
# This gives us SECRET_KEY, DEBUG, ALLOWED_HOSTS, etc.
from dotenv import load_dotenv
project_folder = os.path.expanduser('~/web-structures-course')
load_dotenv(os.path.join(project_folder, '.env'))

# 3. Set Django settings module
# This tells Django where to find settings.py
os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'

# 4. Get the WSGI application
# This is what the webserver calls to handle requests
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
