from django.urls import path
from .views import ElecGeneralAPI

urlpatterns = [
    path("elec_general/", ElecGeneralAPI.as_view()),
]