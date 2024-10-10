from rest_framework import serializers
from .models import ElecGeneral

class ElecGeneralSerializer(serializers.ModelSerializer):
    class Meta:
        model = ElecGeneral
        fields = ['id','major','nid','title','url','date_post']