# Deploy Guide: PythonAnywhere

Complete step-by-step guide to deploy **3D Storage Gallery** on PythonAnywhere.

## Prerequisites

✅ GitHub account with your repo
✅ PythonAnywhere account (free tier is fine)
✅ Project must be fully committed to GitHub (with `.gitignore` protecting `.env`)

---

## STEP 1: Create PythonAnywhere Account & Open Bash Console

1. Go to **pythonanywhere.com**
2. Sign up for **Beginner plan** (FREE)
3. Choose username wisely (becomes part of your URL: `username.pythonanywhere.com`)
4. After login, go to **Consoles** tab
5. Click **Bash** to open terminal

---

## STEP 2: Clone Your Repository

```bash
git clone https://github.com/YOUR_USERNAME/web-structures-course.git
cd web-structures-course
```

If repo is **private**, you'll need to use a GitHub Personal Access Token instead of password.

---

## STEP 3: Create Virtual Environment & Install Dependencies

```bash
# Create virtual environment with Python 3.10
mkvirtualenv --python=/usr/bin/python3.10 myenv

# Install all dependencies
pip install -r requirements.txt
```

Wait ~1-2 minutes for installation to complete.

---

## STEP 4: Create .env File on Server

Create configuration file with your production settings:

```bash
# Open nano editor
nano .env
```

Paste this content (replace `YOUR_USERNAME`):

```bash
SECRET_KEY=django-insecure-v0i6@k!7r(2shy1bbm^x3bfsa**wr58wtm8$6nw@i8s!dr93qe
DEBUG=False
ALLOWED_HOSTS=your_username.pythonanywhere.com
```

**Save & Exit:**
- Press `Ctrl + O`
- Press `Enter` to confirm
- Press `Ctrl + X` to exit

---

## STEP 5: Setup Database & Collect Static Files

```bash
# Create database tables
python manage.py migrate

# Collect static files (CSS, JS) for production
python manage.py collectstatic --noinput

# Create admin user for yourself
python manage.py createsuperuser
# Enter desired username, email, password when prompted
```

---

## STEP 6: Configure Web App in PythonAnywhere

### 6a. Create Web App

1. Go to **Web** tab (top right)
2. Click **Add a new web app**
3. Click **Next**
4. **IMPORTANT:** Select **Manual configuration** (NOT Django - we don't want a fresh project)
5. Choose **Python 3.10**
6. Click **Next**

### 6b. Configure Virtualenv

In the Web tab, find **Virtualenv** section:

1. Click the red link "Enter path to a virtualenv"
2. Enter this path (replace `your_username`):
   ```
   /home/your_username/.virtualenvs/myenv
   ```
3. Click checkmark (OK)

### 6c. Configure Source Code

In the **Code** section:

1. Find "Source code:" field
2. Enter path (replace `your_username`):
   ```
   /home/your_username/web-structures-course
   ```

### 6d. Configure WSGI Application

⚠️ **MOST IMPORTANT STEP**

1. In **Code** section, click the WSGI configuration file link:
   ```
   /var/www/your_username_pythonanywhere_com_wsgi.py
   ```

2. **Delete ALL content** in that file

3. Paste this code (replace `your_username`):

```python
import os
import sys

# 1. Add project folder to path
path = '/home/your_username/web-structures-course'
if path not in sys.path:
    sys.path.append(path)

# 2. Load environment variables from .env
from dotenv import load_dotenv
project_folder = os.path.expanduser('~/web-structures-course')
load_dotenv(os.path.join(project_folder, '.env'))

# 3. Set Django settings module
os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'

# 4. Run Django WSGI application
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

4. Click **Save** (top right)

---

## STEP 7: Reload & Go Live!

1. Return to **Web** tab
2. Click large green **Reload** button
3. Wait for spinner to stop (10-30 seconds)
4. Click your site URL at the top (blue link)

### Expected Result:

✅ You should see your gallery homepage
- CSS is styled
- Navigation works
- Search & pagination visible

### If You See Errors:

**DisallowedHost error:**
- Check ALLOWED_HOSTS in `.env` matches your domain

**ModuleNotFoundError:**
- Check that pip install completed without errors
- Reload web app again

**Something went wrong:**
- Go to **Web** tab → **Log files** → **Error log**
- Scroll to bottom to see Python error
- Common issues: typo in .env path, missing package

---

## STEP 8: Security & HTTPS

1. On **Web** tab, find **Security** section
2. Toggle **Force HTTPS** to ON
3. This gives you green padlock 🔒

---

## STEP 9: Test Functionality

### Test Upload:
1. Navigate to Upload page
2. Select a `.glb` file
3. Click Upload
4. Should see success notification
5. Model should appear in gallery

### Test Search:
1. On homepage, type something in search
2. Should filter results correctly

### Test Admin:
1. Go to `/admin/`
2. Login with superuser credentials you created
3. Can manage models via admin panel

---

## POST-DEPLOYMENT CHECKLIST

- [ ] Site loads at `https://username.pythonanywhere.com`
- [ ] CSS & styling loads correctly
- [ ] Can navigate between pages
- [ ] Search works
- [ ] Can upload 3D models (after creating one)
- [ ] 3D viewer works (click on a model)
- [ ] Admin panel accessible at `/admin/`
- [ ] HTTPS enabled (green padlock)

---

## Troubleshooting

### Problem: "DisallowedHost" Error

**Solution:** Update `.env` on server:
```bash
nano .env
# Change ALLOWED_HOSTS to: your_username.pythonanywhere.com
```

Then reload web app.

### Problem: "ModuleNotFoundError: No module named 'dotenv'"

**Solution:** Reinstall from requirements.txt:
```bash
pip uninstall -y python-dotenv whitenoise
pip install -r requirements.txt
```

### Problem: Static files not loading (no CSS)

**Solution:** Recollect static files:
```bash
python manage.py collectstatic --noinput
```

Then reload web app.

### Problem: Something went wrong when uploading

**Solution:** Check error log:
1. **Web** tab
2. **Log files**
3. **Error log**
4. Scroll to bottom for error message

### Problem: Database errors

**Solution:** Recreate database:
```bash
rm db.sqlite3  # Delete old database
python manage.py migrate  # Create fresh one
python manage.py createsuperuser  # Create admin again
```

---

## Updating Code on Server

After you make changes locally:

```bash
# On your local machine:
git add .
git commit -m "Description of changes"
git push origin main

# On PythonAnywhere console:
cd web-structures-course
git pull origin main

# If you changed code that affects static files:
python manage.py collectstatic --noinput

# Reload in Web tab
```

---

## Custom Domain (Optional)

You can point your own domain to PythonAnywhere:

1. **Web** tab → **Web address** section
2. Add your domain name
3. Update DNS settings at your domain registrar to point to PythonAnywhere

(Detailed guide on PythonAnywhere help docs)

---

## Free Tier Limitations

- 100MB disk space (enough for small projects)
- Limited to PythonAnywhere domain (unless you pay)
- Older free accounts may have restrictions
- Upgrade anytime if needed

---

## SUCCESS! 🚀

Your application is now live on the internet!

**Your URL:** `https://your_username.pythonanywhere.com`

You can visit this from any device, any browser, anywhere in the world.

Share it with friends, family, colleagues - anyone can access it!

---

## Next Steps

- Consider upgrading to paid PythonAnywhere account for custom domain
- Add HTTPS certificate (PythonAnywhere does this automatically free)
- Monitor error logs regularly
- Keep code updated with new features
- Build your portfolio with this project

---

**Congratulations on completing Web Structures Course!** 🎉
