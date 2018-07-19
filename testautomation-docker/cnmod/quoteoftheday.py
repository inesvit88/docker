import urllib.request
import json

url = "http://api.icndb.com/jokes/random"
request = urllib.request.Request(url)
r = urllib.request.urlopen(request).read()
rjson = json.loads(r.decode('utf-8'))
print (rjson['value']['joke'])

