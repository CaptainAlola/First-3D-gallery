from django.apps import AppConfig


class GalleryConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'gallery'

    # Этот метод запускается один раз при старте сервера
    def ready(self):
        # Импортируем сигналы, чтобы они были зарегистрированы
        import gallery.signals
