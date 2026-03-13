# 3D Storage Gallery - Web Structures Course

A Django web application for uploading, searching, and viewing 3D models with real-time 3D preview using Three.js.

## Features

- ✅ Upload 3D models (.glb format)
- ✅ Automatic thumbnail generation from 3D models
- ✅ Real-time 3D viewer with rotation and zoom
- ✅ Full-text search with case-insensitive matching
- ✅ Multiple sorting options (new/old/alphabetical)
- ✅ Pagination with smart link preservation
- ✅ Success/Error notifications
- ✅ Responsive design

## Installation & Local Setup

### 1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/web-structures-course.git
cd web-structures-course
```

### 2. Create virtual environment
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate
```

### 3. Install dependencies
```bash
pip install -r requirements.txt
```

### 4. Create .env file
```bash
# In project root (next to manage.py)
# Copy this:
SECRET_KEY=django-insecure-v0i6@k!7r(2shy1bbm^x3bfsa**wr58wtm8$6nw@i8s!dr93qe
DEBUG=True
```

### 5. Run migrations
```bash
python manage.py migrate
```

### 6. Create superuser (for admin panel)
```bash
python manage.py createsuperuser
# Follow the prompts
```

### 7. Run development server
```bash
python manage.py runserver
```

Visit: http://localhost:8000

## Project Structure

```
.
├── config/              # Django project settings
│   ├── settings.py     # Configuration (reads from .env)
│   ├── urls.py         # URL routing
│   └── wsgi.py         # WSGI configuration
├── gallery/            # Main app
│   ├── static/         # CSS, JS, images
│   ├── templates/      # HTML templates
│   ├── models.py       # Database models
│   ├── views.py        # View logic
│   └── forms.py        # Django forms
├── media/              # User uploads (not in git)
├── staticfiles/        # Collected static files (production)
├── .env                # Secret configuration (not in git)
├── .gitignore          # Git ignore rules
├── manage.py           # Django CLI
└── requirements.txt    # Python dependencies

```

## Production Deployment (PythonAnywhere)

### Detailed Step-by-Step Guide

See **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** for complete instructions on how to deploy to PythonAnywhere.

Quick summary:
1. Create PythonAnywhere account
2. Clone this repo in bash console
3. Create virtual environment with `mkvirtualenv`
4. Create `.env` file with your settings
5. Run migrations and collect static files
6. Configure Web app and WSGI
7. Reload and go live!

### With Setup Script (Easier)

After cloning and activating virtualenv:

```bash
bash deploy.sh
```

This automates steps 3-6 above.

### 1. Create PythonAnywhere Account
Visit: https://www.pythonanywhere.com
Sign up for a free account

### 2. Create Web App
In PythonAnywhere web console:
```bash
git clone https://github.com/YOUR_USERNAME/web-structures-course.git
cd web-structures-course
mkvirtualenv --python=/usr/bin/python3.10 mysite
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
```

### 3. Configure Web App Settings
In PythonAnywhere:
1. Add your domain to ALLOWED_HOSTS in settings.py
2. Create .env file in project root:
   ```
   SECRET_KEY=your-actual-secret-key
   DEBUG=False
   ```
3. Configure WSGI to point to `config.wsgi`

### 4. Reload Web App
Click "Reload" button in PythonAnywhere web app settings

## Admin Panel

Access at http://localhost:8000/admin/
- Username: (created during `createsuperuser`)
- Password: (created during `createsuperuser`)

## Technology Stack

- **Backend**: Django 6.0.2
- **Frontend**: Three.js (3D viewer)
- **Database**: SQLite (development) / PostgreSQL (production)
- **Static Files**: WhiteNoise
- **Environment**: python-dotenv
- **Image Processing**: Pillow

## API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/` | Gallery home page |
| GET | `/?q=search&ordering=new&page=2` | Search with pagination |
| GET | `/upload/` | Upload form |
| POST | `/upload/` | Submit 3D model |
| GET | `/about/` | About page |

## Environment Variables

Create `.env` file in project root:

```bash
# SECRET_KEY from Django (keep it SECRET in production)
SECRET_KEY=your-secret-key-here

# Debug mode (False in production!)
DEBUG=True  # for development
DEBUG=False # for production
```

## Troubleshooting

### Models not loading
- Check `MEDIA_ROOT` and `MEDIA_URL` in settings.py
- Ensure media folder has proper permissions
- Verify .glb files are properly uploaded

### Static files missing in production
```bash
python manage.py collectstatic --noinput
```

### Database errors
```bash
python manage.py migrate
```

### Template tag errors
Ensure `gallery/templatetags/` folder exists with `__init__.py`

## License

Educational Project - Web Structures Course

## Author

Created for learning purposes as part of Web Structures course.
