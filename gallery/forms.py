from django import forms
import os
from django.core.exceptions import ValidationError
from .models import Asset


class AssetForm(forms.ModelForm):
    class Meta:
        model = Asset
        fields = ['title', 'file']
        widgets = {
            'title': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Название модели'}),
            'file': forms.FileInput(attrs={'class': 'form-control'}),
        }

    def clean_file(self):
        file = self.cleaned_data.get('file')
        if not file:
            return file
        ext = os.path.splitext(file.name)[1].lower()
        valid_extensions = ['.glb', '.gltf']
        if ext not in valid_extensions:
            raise ValidationError('Неподдерживаемый формат. Пожалуйста, загрузите .glb или .gltf')
        return file
