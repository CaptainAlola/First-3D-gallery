# Pre-Deployment Checklist

Complete this checklist before deploying to PythonAnywhere.

## Local Development Complete ✓

- [x] Project runs locally with `python manage.py runserver`
- [x] All pages load correctly (/, /upload/, /about/)
- [x] Search and sorting work
- [x] Pagination works
- [x] Can upload 3D models
- [x] 3D viewer displays models
- [x] Admin panel works (`/admin/`)
- [x] No console errors in browser
- [x] Tested with `DEBUG=False` locally

## Code Quality ✓

- [x] All Python code is clean and commented
- [x] No hardcoded secrets in code
- [x] No `print()` statements left for debugging
- [x] All files follow naming conventions
- [x] Database migrations are created
- [x] No unused imports

## Configuration ✓

- [x] `.env` file exists with settings
- [x] `.env.example` created for documentation
- [x] `ALLOWED_HOSTS` uses environment variable
- [x] `DEBUG = False` works locally
- [x] `SECRET_KEY` is in `.env` (not in code)
- [x] `STATIC_URL`, `STATIC_ROOT` configured
- [x] `MEDIA_URL`, `MEDIA_ROOT` configured
- [x] WhiteNoise middleware installed and configured

## Dependencies ✓

- [x] `requirements.txt` created with `pip freeze`
- [x] All required packages listed:
  - [ ] Django
  - [ ] Pillow
  - [ ] python-dotenv
  - [ ] whitenoise
- [x] Virtual environment can be recreated from `requirements.txt`
- [x] No development-only packages in requirements (like ipython)

## Git & GitHub ✓

- [x] Git repository initialized
- [ ] GitHub repository created
- [ ] `.gitignore` configured to exclude:
  - [ ] `.env`
  - [ ] `venv/` or `.venv/`
  - [ ] `__pycache__/`
  - [ ] `db.sqlite3`
  - [ ] `media/`
  - [ ] `staticfiles/`
  - [ ] `.pyc` files
- [ ] Code pushed to GitHub
- [ ] Repository is accessible (public or with proper access)

Example commands:
```bash
git add .
git commit -m "Initial commit: Web Structures Course project"
git remote add origin https://github.com/USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

## Documentation ✓

- [x] `README.md` created with:
  - [ ] Project description
  - [ ] Features list
  - [ ] Installation instructions
  - [ ] Usage guide
  - [ ] Tech stack
  - [ ] Deployment instructions (links to DEPLOYMENT_GUIDE.md)

- [x] `DEPLOYMENT_GUIDE.md` created with:
  - [ ] Step-by-step PythonAnywhere setup
  - [ ] Environment variables to set
  - [ ] WSGI configuration
  - [ ] Troubleshooting section

- [x] `COURSE_COMPLETION.md` created (portfolio reference)
- [x] `wsgi_template.py` created for easy WSGI setup
- [x] `deploy.sh` created for automated setup

## Final Testing

### On Your Local Machine

```bash
# 1. Test with fresh venv simulation
rm -rf test_venv  # OR: rmdir /s test_venv on Windows
python -m venv test_venv
source test_venv/bin/activate  # OR: test_venv\Scripts\activate on Windows
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py runserver
# Visit http://localhost:8000 and test all features
deactivate
```

### Check .env Requirements
```
✓ SECRET_KEY is set
✓ DEBUG is False
✓ ALLOWED_HOSTS is set (will change on PythonAnywhere)
```

### Verify Static Files
```bash
python manage.py collectstatic --noinput
ls staticfiles/  # Check folder was created
# Should contain CSS files, JS files, etc.
```

### Test Admin
```bash
python manage.py createsuperuser
# Create test admin user
# Login at http://localhost:8000/admin/
# Verify you can:
  - [ ] View uploaded models
  - [ ] Create new models
  - [ ] Delete models
  - [ ] Access admin interface styling
```

## Security Review

- [x] No passwords in code
- [x] No API keys in code
- [x] No tokens in code
- [x] `.env` file in `.gitignore`
- [x] DEBUG must be False in production
- [x] ALLOWED_HOSTS configured properly
- [x] CSRF protection enabled
- [x] SQL injection protected (using ORM)
- [x] XSS protection enabled (Django template escaping)

## Performance Check

- [x] Static files collected
- [x] Database optimized (indexes on frequently searched fields)
- [ ] No N+1 queries in views
- [x] Pagination implemented
- [x] Static file compression enabled (WhiteNoise)

## Documentation for Others

Your GitHub repo should have clear instructions:

```markdown
# Project Name

1. Clone: git clone URL
2. Setup: python -m venv venv && source venv/bin/activate
3. Install: pip install -r requirements.txt
4. Create .env from .env.example
5. Migrate: python manage.py migrate
6. Run: python manage.py runserver
7. Visit: http://localhost:8000
```

## Files to Review One More Time

Before pushing to GitHub, review these files:

- [ ] `config/settings.py` - No hardcoded secrets?
- [ ] `.gitignore` - Contains `.env`?
- [ ] `requirements.txt` - Has all dependencies?
- [ ] `.env` - Contains actual values?
- [ ] `README.md` - Clear instructions?

## Ready for PythonAnywhere? 

If you can check all of the above, you're ready to:

1. Create account at pythonanywhere.com
2. Follow `DEPLOYMENT_GUIDE.md`
3. Clone your repo
4. Run `bash deploy.sh`
5. Configure WSGI
6. Click Reload
7. Visit: `https://your_username.pythonanywhere.com`

---

## Deployment Day Checklist

When actually deploying:

- [ ] PythonAnywhere account created
- [ ] Repository cloned on server
- [ ] Virtual environment created
- [ ] Dependencies installed
- [ ] `.env` created with PythonAnywhere values
- [ ] Migrations run
- [ ] Static files collected
- [ ] Superuser created
- [ ] Virtualenv path set correctly
- [ ] Source code path set correctly
- [ ] WSGI file updated
- [ ] Web app reloaded
- [ ] Site loads at https://username.pythonanywhere.com
- [ ] Tested uploading a model
- [ ] Tested search functionality
- [ ] HTTPS forced to ON
- [ ] Admin panel loads

---

## Success Indicators

Your deployment is successful when:

✅ Site loads at https://username.pythonanywhere.com
✅ No 500 errors
✅ CSS and JavaScript work (styled properly)
✅ Can navigate between pages
✅ Search filters results
✅ Can upload 3D models
✅ 3D viewer displays models
✅ Admin panel accessible
✅ Green HTTPS padlock in browser

---

## Troubleshooting Quick Reference

| If You See | Check |
|-----------|-------|
| DisallowedHost | ALLOWED_HOSTS in .env |
| ModuleNotFoundError | pip install -r requirements.txt |
| No CSS/JS | python manage.py collectstatic |
| Can't upload | permissions on media/ folder |
| Database error | python manage.py migrate |

---

**Ready to launch? Good luck! 🚀**

Follow `DEPLOYMENT_GUIDE.md` for step-by-step instructions.
