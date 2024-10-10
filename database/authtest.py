
import firebase_admin
from firebase_admin import auth, credentials
from firebase_admin import auth as firebase_auth
# Firebase Admin SDK 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate("./firebase.json")
    firebase_admin.initialize_app(cred)

def create_anonymous_user():
    try:
        # 익명 사용자 생성
        user = auth.create_user()
        print(f'익명 사용자 생성됨, UID: {user.uid}')
        
        # 생성된 사용자를 위한 Custom Token 발급
        custom_token = auth.create_custom_token(user.uid)
        print(f'Custom Token: {custom_token}')
        
        # 출력: UID와 Custom Token
        return user.uid, custom_token
    except Exception as e:
        print(f'익명 사용자 생성 중 오류 발생: {e}')
        return None

# 익명 사용자 생성 및 UID와 Custom Token 출력
uid, custom_token = create_anonymous_user()
#print(f'UID: {uid}\nCustom Token: {custom_token}')

header = {
    "Authorization" : "Bearer "+str(custom_token),
    "Content-Type": "application/json"
}

token = header.get('Authorization')

decoded_token = firebase_auth.verify_id_token(token[7:])
id = decoded_token["uid"]

print(id)