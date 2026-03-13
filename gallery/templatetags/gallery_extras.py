from django import template

register = template.Library()

@register.simple_tag
def param_replace(request, **kwargs):
    """
    Заменяет один или несколько GET-параметров, сохраняя остальные.
    Использование: {% param_replace request page=2 %}
    Результат: q=test&ordering=new&page=2
    """
    # Копируем все параметры из текущего запроса (q, ordering...)
    d = request.GET.copy()
    
    # Заменяем или добавляем новые параметры
    for k, v in kwargs.items():
        d[k] = v
    
    # Возвращаем готовую строку для URL
    return d.urlencode()
