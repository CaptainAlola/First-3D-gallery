# Transfer / Restore Instructions

## What's Inside the ZIP

Your `.zip` contains the entire project INCLUDING:
- ✅ All source code (`config/`, `gallery/`)
- ✅ Templates & CSS (`gallery/templates/`, `gallery/static/`)
- ✅ Database schema & migrations (`gallery/migrations/`)
- ✅ Configuration files (`requirements.txt`, `.env.example`)

NOT included (protected by `.gitignore`):
- ❌ `.env` (secrets - you create this)
- ❌ `venv/` (virtual environment - you recreate this)
- ❌ `media/` (user uploads - optional)
- ❌ `staticfiles/` (compiled static files - you regenerate)
- ❌ `__pycache__/` (Python cache)

---

## Step-by-Step Setup on New Computer

### 1️⃣ Unzip the Project

```PowerShell
# Windows
Expand-Archive -Path web-structures-course.zip -DestinationPath C:\Projects
cd C:\Projects\web-structures-course

# OR drag-and-drop in Explorer
```

### 2️⃣ Install Python 3.13+

Download from [python.org](https://www.python.org) if not installed.

Verify:
```powershell
python --version
# Should show: Python 3.13.x or later
```

### 3️⃣ Create Virtual Environment

```powershell
# Windows PowerShell
python -m venv venv
.\venv\Scripts\Activate.ps1

# Windows CMD
python -m venv venv
venv\Scripts\activate.bat

# Mac/Linux
python3 -m venv venv
source venv/bin/activate
```

You should see `(venv)` prefix in terminal.

### 4️⃣ Install Dependencies

```powershell
pip install --upgrade pip
pip install -r requirements.txt
```

Wait 2-3 minutes for installation.

Verify:
```powershell
pip list
# Should show: Django, Pillow, whitenoise, python-dotenv, etc.
```

### 5️⃣ Create `.env` Configuration File

```powershell
# Copy example
copy .env.example .env

# Edit .env (use Notepad or VS Code)
notepad .env
```

Content for DEVELOPMENT:
```
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

**Important:** 
- Keep `.env` in `.gitignore` (never commit secrets!)
- Each machine needs its own `.env`

### 6️⃣ Setup Database

```powershell
# Create database tables
python manage.py migrate

# Create admin user (your credentials)
python manage.py createsuperuser
# Follow prompts for username, email, password
```

### 7️⃣ Collect Static Files (Optional for Development)

```powershell
# For production or to test production mode
python manage.py collectstatic --noinput
```

### 8️⃣ Start Development Server

```powershell
python manage.py runserver
```

You should see:
```
Starting development server at http://127.0.0.1:8000/
```

Open browser → http://127.0.0.1:8000

---

## Troubleshooting

### "ModuleNotFoundError: No module named 'django'"
- Did you activate venv? Check for `(venv)` prefix
- Did `pip install` complete? Run again: `pip install -r requirements.txt`

### "Error: DJANGO_SETTINGS_MODULE is not defined"  
- Ensure `.env` exists in project root
- Check `config/settings.py` reads from `.env` correctly
- Delete any `db.sqlite3` and run `python manage.py migrate` again

### "DisallowedHost" error
- Edit `.env` and add your hostname to `ALLOWED_HOSTS`
- Examples: `localhost`, `192.168.1.100`, `mycomputer.local`

### CSS/JS not loading in browser
- Make sure `DEBUG=True` in `.env` (development mode)
- Django auto-serves static files in dev mode
- For production: run `python manage.py collectstatic --noinput`

### Port 8000 already in use
```powershell
python manage.py runserver 8001
# Use different port
```

---

## Optional: Copy Media/Database from Old Computer

### Copy Database
```powershell
# From old computer: Copy C:\...\web\db.sqlite3
# To new computer: Paste in project root

# Then:
python manage.py migrate  # Updates schema if needed
```

### Copy User Uploads
```powershell
# From old computer: Copy C:\...\web\media\ folder
# To new computer: Paste in project root

# Should see: media/3d_assets/, media/thumbnails/
```

---

## Next Steps

- Start the server: `python manage.py runserver`
- Visit http://127.0.0.1:8000
- Try uploading a 3D model: http://127.0.0.1:8000/upload
- Access admin: http://127.0.0.1:8000/admin (use credentials from `createsuperuser`)

---

## ✅ Checklist

- [x] ZIP extracted to folder
- [x] Python 3.13+ installed
- [x] Virtual environment created & activated
- [x] Dependencies installed (`pip install -r requirements.txt`)
- [x] `.env` file created with `DEBUG=True`
- [x] Database migrated (`python manage.py migrate`)
- [x] Admin user created (`python manage.py createsuperuser`)
- [x] Server starting (`python manage.py runserver`)
- [x] Browser loads http://127.0.0.1:8000 ✅

Done! Your project is ready to work with.
- If you see errors about missing packages, check `requirements.txt` and re-run `pip install -r requirements.txt`.
- If project uses a different path layout, verify `MEDIA_ROOT` in `config/settings.py` and adjust if necessary.
- If transferring between OS (Windows ↔ Linux/Mac), recreate the virtualenv and ensure file permissions for `media/` are correct.
