# Transfer Readiness Checklist ✅

Before transferring your project to another computer, use this checklist to ensure nothing breaks.

---

## Pre-Transfer Verification

### Code & Configuration ✅
- [ ] `.gitignore` exists and includes:
  - [ ] `.env` (secrets protected)
  - [ ] `venv/` (virtual env excluded)
  - [ ] `__pycache__/` (Python cache)
  - [ ] `media/` (user uploads)
  - [ ] `staticfiles/` (generated files)

```bash
# View .gitignore contents
cat .gitignore
```

- [ ] `requirements.txt` exists with all dependencies
  ```bash
  # Verify exact versions
  cat requirements.txt
  ```

- [ ] `.env.example` exists as template
  ```bash
  # Should show SECRET_KEY, DEBUG, ALLOWED_HOSTS examples
  cat .env.example
  ```

- [ ] `README_TRANSFER.md` exists with setup instructions
- [ ] `CREATE_ZIP.md` exists with ZIP instructions
- [ ] `PROJECT_INFO.md` exists with project overview

### Django Configuration ✅
- [ ] `config/settings.py` reads from environment variables:
  ```python
  SECRET_KEY = os.getenv('SECRET_KEY', '...')
  DEBUG = os.getenv('DEBUG') == 'True'
  ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', '*').split(',')
  ```

- [ ] No hardcoded secrets in any Python files
  ```bash
  # Search for exposed secrets (should find none)
  grep -r "SECRET_KEY = '" config/
  grep -r "DEBUG = True" config/
  ```

### Project Files ✅
- [ ] `manage.py` exists in project root
- [ ] `db.sqlite3` exists (optional - can be recreated)
- [ ] `gallery/migrations/` folder intact
- [ ] `gallery/templates/` folder intact
- [ ] `gallery/static/` folder intact
- [ ] All templates use proper relative paths

### Git ✅
- [ ] Repository initialized: `git init`
- [ ] All code committed: `git status` shows clean
- [ ] `.git/` folder exists (not in .gitignore)
- [ ] `README.md` exists with project description

---

## Creating the ZIP File

### Option A: Use the Script (Easiest)

```powershell
# From Desktop folder:
cd C:\Users\Delta-Game\OneDrive\Desktop
.\web\create-zip.ps1
```

**Result:** `web-structures-course.zip` appears on Desktop

### Option B: Manual PowerShell

```powershell
cd C:\Users\Delta-Game\OneDrive\Desktop
$exclude = @('web/venv', 'web/.venv', 'web/env', 'web/ENV', 'web/__pycache__', 'web/staticfiles', 'web/.git', 'web/.env', 'web/media')
Compress-Archive -Path web -DestinationPath web-structures-course.zip -Force -Exclude $exclude
```

### Verify ZIP Contents ✅

```powershell
# Check file size (should be 5-15 MB, NOT 500+ MB)
(Get-Item web-structures-course.zip).Length / 1MB

# List major folders inside
Expand-Archive -Path web-structures-course.zip -DestinationPath test-extract\ -Force
ls test-extract\web\
```

ZIP should contain:
- ✅ `config/` folder
- ✅ `gallery/` folder
- ✅ `requirements.txt` file
- ✅ `.env.example` file
- ✅ `manage.py` file
- ❌ NO `venv/` folder
- ❌ NO `.env` file (with secrets)
- ❌ NO `media/` uploads

---

## Test Transfer (Simulate New Computer)

### 1. Extract to Test Location
```powershell
# Extract to temp folder
mkdir C:\TransferTest
Expand-Archive -Path web-structures-course.zip -DestinationPath C:\TransferTest\
cd C:\TransferTest\web
```

### 2. Run Setup Steps
```powershell
# Create virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt

# Create .env
copy .env.example .env
# Edit .env: Set DEBUG=True, Secret key, etc.
notepad .env

# Run migrations
python manage.py migrate

# Create admin user
python manage.py createsuperuser

# Start server
python manage.py runserver
```

### 3. Test in Browser
- [ ] Open http://127.0.0.1:8000/
- [ ] Page loads with CSS styling
- [ ] Search box visible
- [ ] Upload link visible
- [ ] Admin link visible

### 4. Test Functionality
- [ ] Click `/admin/` → Login works
- [ ] Click `/upload/` → Upload form shows
- [ ] Pagination visible on homepage
- [ ] No error messages in console

### 5. Success Indicators ✅
```
✅ Server running without errors
✅ CSS loads (styled page, not plain HTML)
✅ No 404 errors for static files
✅ Can navigate all pages
✅ Admin login works
```

### 6. Cleanup Test
```powershell
# Delete test folder
Remove-Item -Recurse C:\TransferTest\
```

---

## Share Your ZIP

Once test succeeds, your ZIP is ready:

### Method 1: Email
```
web-structures-course.zip (~10 MB)
↓ Email to recipient
↓ They extract & follow README_TRANSFER.md
✅ Works on their computer!
```

### Method 2: Cloud Storage
- Google Drive
- OneDrive
- Dropbox
- WeTransfer

### Method 3: GitHub (Better!)
```bash
# Instead of ZIP, just push code
git remote add origin https://github.com/USERNAME/web-structures-course
git push -u origin main

# Others can:
git clone https://github.com/USERNAME/web-structures-course
```

### Method 4: USB Drive
```
Copy web-structures-course.zip to USB
↓ Give USB to someone
↓ They extract on their computer
✅ Works!
```

---

## Transfer Day Checklist

When transferring to another computer:

### Before Transferring:
- [ ] ZIP file created successfully
- [ ] ZIP file size reasonable (5-15 MB)
- [ ] Test extraction + setup completed
- [ ] All tests passed without errors

### On Receiving Computer:
- [ ] Extract ZIP file
- [ ] Python 3.13+ installed
- [ ] Follow `README_TRANSFER.md` step by step
- [ ] Confirm each step before proceeding

### After Setup:
- [ ] Server starts: `python manage.py runserver`
- [ ] Browser loads http://127.0.0.1:8000
- [ ] CSS and styling visible
- [ ] Admin login works
- [ ] Can upload models

---

## Troubleshooting During Transfer

### Problem: "No such file or directory: manage.py"
- ❌ You extracted ZIP to wrong location
- ✅ Extract again, navigate into the `web/` folder

### Problem: "No module named 'django'"
- ❌ Virtual environment not activated (look for `(venv)` prefix)
- ❌ `pip install -r requirements.txt` didn't complete
- ✅ Check that `(venv)` shows in terminal, reinstall packages

### Problem: "DisallowedHost exception"
- ❌ `.env` has wrong ALLOWED_HOSTS
- ✅ Edit `.env` add: `ALLOWED_HOSTS=localhost,127.0.0.1`

### Problem: CSS doesn't load (page looks plain)
- ❌ DEBUG is not True in `.env`
- ✅ Edit `.env`: `DEBUG=True`
- ✅ Restart server

### Problem: "DJANGO_SETTINGS_MODULE"
- ❌ `.env` file is missing
- ✅ Create `.env` from `.env.example`
- ✅ set SECRET_KEY, DEBUG, ALLOWED_HOSTS

---

## Final Verification ✅

### Run This Before Sharing ZIP:

```powershell
# Navigate to project
cd C:\Users\Delta-Game\OneDrive\Desktop\web

# Check all critical files exist
Test-Path manage.py                    # Should be TRUE
Test-Path requirements.txt             # Should be TRUE
Test-Path .env.example                 # Should be TRUE
Test-Path config/settings.py           # Should be TRUE
Test-Path gallery/                     # Should be TRUE
Test-Path gallery/migrations/          # Should be TRUE
Test-Path gallery/templates/           # Should be TRUE
Test-Path gallery/static/              # Should be TRUE
Test-Path .gitignore                   # Should be TRUE
Test-Path README_TRANSFER.md           # Should be TRUE
Test-Path README.md                    # Should be TRUE
Test-Path PROJECT_INFO.md              # Should be TRUE

# Check that .env is EXCLUDED from version control
Test-Path .env                         # Should be FALSE (not committed)
```

All should show:
```
True
True
True
... (all True except .env which is False)
```

### Final Validation:

```bash
# Make sure nothing accidentally got committed
git status
# Should show: "nothing to commit, working tree clean"

# If .env somehow got committed, REMOVE IT!
git rm --cached .env
git commit -m "Remove .env from version control"
```

---

## ✅ YOU'RE READY!

Your project is transfer-ready when:

- [x] `.gitignore` properly configured
- [x] No secrets in version control
- [x] `requirements.txt` has all packages
- [x] `.env.example` provided
- [x] Setup instructions clear
- [x] ZIP created and tested successfully
- [x] All core files present and complete

**ZIP file:** `web-structures-course.zip` ✅ Ready to transfer

**Time to transfer:** ~5 minutes on new computer
**Time to setup:** ~10-15 minutes on new computer
**Difficulty:** Easy (follow step-by-step guide)

---

## Share This Info

When you transfer, include:
1. ✅ `web-structures-course.zip` (the actual file)
2. ✅ Link to `README_TRANSFER.md` (setup instructions)
3. ✅ Python 3.13+ (they need this installed)

That's it! Everything else is in the ZIP.

---

🚀 **Happy transferring!**

---

**Questions?** Check:
- `README_TRANSFER.md` - Setup guide
- `CREATE_ZIP.md` - ZIP creation details
- `PROJECT_INFO.md` - Technical overview
