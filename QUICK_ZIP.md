# Простой способ создать ZIP на Windows

## Способ 1: Windows Explorer (Самый простой!)  ⭐

1. **Откройте** `C:\Users\Delta-Game\OneDrive\Desktop\`
2. **Удалите** из папки `web/` ненужные файлы:
   - Правый клик на `venv/` → Delete
   - Правый клик на `__pycache__/` → Delete  
   - Правый клик на `.env` → Delete
   - (Опционально) Удалите `media/` если много файлов

3. **Создайте ZIP:**
   - Правый клик на папку `web/`
   - Выберите **Send to** → **Compressed (zipped) folder**
   - Файл `web.zip` создан!

4. **Переименуйте:**
   - `web.zip` → `web-structures-course.zip` (более понятное имя)

5. **Восстановите ненужные файлы:**
   - Если удалили `venv/` - это OK, он пересоздается на новом компе
   - Если удалили `.env` - это ОТЛИЧНО (это секреты!)
   - Если удалили `media/` - не беда (это только загруженные файлы)

---

## Способ 2: Через 7-Zip (Если установлен)

```powershell
# Если у вас есть 7-Zip:
& 'C:\Program Files\7-Zip\7z.exe' a web-structures-course.zip C:\Users\Delta-Game\OneDrive\Desktop\web -x!venv -x!.venv -x!__pycache__ -x!.env -x!media -x!staticfiles
```

---

## Способ 3: Скопировать только нужные файлы

Создать новую папку `web-clean` с только нужными файлами:

```
web-clean/
├── config/                ✅ Копируем
├── gallery/               ✅ Копируем
├── manage.py              ✅ Копируем
├── requirements.txt       ✅ Копируем
├── .env.example          ✅ Копируем
├── .gitignore            ✅ Копируем
├── README.md             ✅ Копируем
├── README_TRANSFER.md    ✅ Копируем
├── PROJECT_INFO.md       ✅ Копируем
├── DEPLOYMENT_GUIDE.md   ✅ Копируем
├── TRANSFER_CHECKLIST.md ✅ Копируем
├── CREATE_ZIP.md         ✅ Копируем
├── db.sqlite3            ⚠️  Опционально
│
├── venv/                 ❌ НЕ копируем
├── .env                  ❌ НЕ копируем  
├── media/                ❌ НЕ копируем
├── staticfiles/          ❌ НЕ копируем
```

Потом `web-clean/` запаковать в ZIP.

---

## ✅ Рекомендуемый способ: Способ 1 (Windows Explorer)

Это самый простой и надежный способ на Windows.

**Итого за 2 минуты:**
1. Удаляете `venv/`, `.env`, `media/` из `web/`
2. Правый клик на `web/` → Compress
3. Получаете `web.zip` (~5-10 MB)
4. Переименовываете в `web-structures-course.zip`
5. Готово! 🚀

**Размер результата:**
- С venv: ~500 MB (СЛИШКОМ БОЛЬШОЙ!)
- Без venv: ~5-10 MB (ИДЕАЛЬНО!)

---

## Что делать после создания ZIP

После создания `web-structures-course.zip`:

```powershell
# Проверьте размер
Get-Item C:\Users\Delta-Game\OneDrive\Desktop\web-structures-course.zip | 
  ForEach-Object { "Size: $([Math]::Round($_.Length / 1MB, 2)) MB" }
```

Если размер:
- ✅ 5-20 MB → Идально!
- ⚠️  100-500 MB → Слишком большой (в ZIP есть venv/)
- ❌ 1+ GB → У вас много загруженных файлов в media/

---

## Все файлы для TRANSFER готовы:

- ✅ `README_TRANSFER.md` - Инструкция для нового компа
- ✅ `TRANSFER_CHECKLIST.md` - Проверочный список
- ✅ `CREATE_ZIP.md` - Подробная инструкция по ZIP
- ✅ `.env.example` - Шаблон конфигурации
- ✅ `requirements.txt` - Все зависимости

**Теперь нужно только создать ZIP через Explorer!**
