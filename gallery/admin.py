from django.contrib import admin
from .models import Asset # Импортируем наш класс
# Регистрируем

# Используем декоратор @admin.register
@admin.register(Asset)
class AssetAdmin(admin.ModelAdmin):
    # Какие поля показывать в таблице (колонки)
    list_display = ('title', 'created_at', 'thumbnail', 'id')
    # Добавляем строку поиска (поиск по названию)
    search_fields = ('title',)
    # Добавляем фильтр справа (по дате)
    list_filter = ('created_at',)
    # Поля, на которые можно кликнуть для входа в редактирование
    list_display_links = ('title',)

    def thumbnail(self, obj):
        if obj.image:
            return f"<img src='{obj.image.url}' style='max-height:50px;'/>"
        return "-"
    thumbnail.allow_tags = True
    thumbnail.short_description = 'Превью'
