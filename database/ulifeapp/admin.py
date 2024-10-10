from django.contrib import admin
from django.contrib.admin import AdminSite
from django.contrib.admin import ModelAdmin
from .models import Cieat, Meal, Extracur, Announcement

class UlifeAdminSite(AdminSite):
    site_header = "ulife 관리자"
    site_title = "ulife 관리자 사이트"
    index_title = "ulife"
    
class CieatAdmin(ModelAdmin):
    list_display = ['title', 'category']
    search_fields = ['title', 'category']
    def get_queryset(self, request):
        return super().get_queryset(request)
    
class MealAdmin(ModelAdmin):
    list_display = ['menu_date', 'food_time', 'cafeteria_name', 'food_name']
    search_fields = ['menu_date', 'food_time','cafeteria_name']
    def get_queryset(self, request):
        return super().get_queryset(request) 

class ExtracurAdmin(ModelAdmin):
    list_display = ['title', 'category', 'category_sub']
    search_fields = ['title', 'category', 'category_sub']
    def get_queryset(self, request):
        return super().get_queryset(request)
    
class AnnouncementAdmin(ModelAdmin):
    list_display = ['major', 'title', 'date_post']
    search_fields = ['major', 'title', 'date_post']
    def get_queryset(self, request):
        return super().get_queryset(request)
    
ulife_admin_site = UlifeAdminSite(name='ulife_admin')    
ulife_admin_site.register(Meal, MealAdmin)
ulife_admin_site.register(Cieat, CieatAdmin)
ulife_admin_site.register(Extracur, ExtracurAdmin)
ulife_admin_site.register(Announcement, AnnouncementAdmin)