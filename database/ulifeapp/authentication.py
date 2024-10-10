import os
import firebase_admin
from firebase_admin import auth as firebase_auth
from firebase_admin import credentials
from rest_framework import authentication, exceptions
from django.utils import timezone
from .models import CBNUInfoUser

# Firebase Admin SDK 초기화

from pathlib import Path
from firebase_admin import credentials
import logging

logger = logging.getLogger(__name__)


# BASE_DIR = Path(__file__).resolve().parent.parent
# cred_path = os.path.join(BASE_DIR, "firebase.json")
# cred = credentials.Certificate(cred_path)
# firebase_app = firebase_admin.initialize_app(cred)


class FirebaseAuthentication(authentication.BaseAuthentication):
    
    # def get_firebase_app(self):
    #     return firebase_app

    
    def authenticate(self, request):

        auth_header = request.headers.get('Authorization')
        if not auth_header:
            return None

        token = auth_header[7:]

        try:
            decoded_token = firebase_auth.verify_id_token(token)
            uid = decoded_token["uid"]
            user = CBNUInfoUser.objects.get(uid=uid)
            return (user, None)
        except firebase_auth.InvalidIdTokenError:
            raise AuthenticationFailed

class AuthenticationFailed(exceptions.AuthenticationFailed):
    status_code = 401
    default_detail = "잘못된 id 토큰입니다."
    
    
