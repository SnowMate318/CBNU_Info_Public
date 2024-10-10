from rest_framework.generics import ListAPIView
from rest_framework.filters import SearchFilter
from.models import ElecGeneral
from.serializers import ElecGeneralSerializer

class ElecGeneralAPI(ListAPIView):
    queryset = ElecGeneral.objects.filter(major = '전자공학부')
    serializer_class = ElecGeneralSerializer
    filter_backends = [SearchFilter]
    search_fields = ['title']

        

    
# gunicorn proj_u.wsgi:application --bind 127.0.0.1:8000

#어떻게 할 거냐
#