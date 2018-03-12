from json import dumps
from urllib.request import Request, urlopen
import urllib.parse 
msg = {
    "msgtype": "text", 
    "text": {
        "content": "abc"
    }
}
str = dumps(msg)
print(str)
str = bytes(str,'utf-8')
print(str)

req = Request('''https://oapi.dingtalk.com/robot/send?access_token=f4bb52dc2b21aceed4ed22d0c82f7a3d1e51fa1208535301e39480273d31e03a''',data=str,headers={'content-type':'application/json'})

with urlopen(req) as response:
    for f in response:
        print(f)
 