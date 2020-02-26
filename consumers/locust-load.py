import random
import requests
import os
from locust import HttpLocust, TaskSet


token = os.getenv("TOKEN")
apigee_url = os.getenv("APIGEE_URL")

print(apigee_url)


hugePayload = {"Content":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et tortor elit. Vivamus nibh orci, auctor eu pharetra sit amet, finibus et turpis. Nullam scelerisque vel lorem et condimentum. Pellentesque a est nulla. Praesent molestie cursus commodo. Integer ac odio at arcu imperdiet volutpat ut et velit. Ut viverra pellentesque elit eget mattis. Maecenas et convallis risus. Aenean sem nisl, cursus sit amet faucibus eget, lacinia eget sapien. Aenean eu elementum mi, condimentum pharetra ante. Aliquam scelerisque malesuada purus.Etiam elementum libero neque, id pellentesque lectus sodales non. Suspendisse dui arcu, vehicula quis diam semper, tempus elementum nulla. Duis ut ipsum ut ex mollis malesuada sed ultrices nisl. Etiam sit amet massa vestibulum, imperdiet nunc ac, sagittis massa. Nulla quis orci sit amet sem faucibus malesuada. Sed ut eros placerat, consequat nisl facilisis, accumsan diam. Phasellus eleifend velit non iaculis aliquet. Etiam ac dolor tincidunt, luctus metus et, luctus erat. Praesent fermentum sed dui et fermentum. Donec nec pretium neque, eu vulputate urna. Donec non metus sit amet velit interdum viverra. Praesent non luctus velit. Maecenas velit arcu, suscipit sed mauris et, ultrices ullamcorper arcu. Phasellus commodo magna metus, vel mollis arcu aliquam non. Nunc rhoncus velit nisi, a fermentum eros luctus nec.Cras cursus tempus velit, vel commodo ex dapibus a. Sed nec commodo libero, semper iaculis purus. Praesent faucibus, mi vitae scelerisque feugiat, ligula dui dictum quam, eget porta neque quam ac ligula. Ut ullamcorper ipsum quis urna ornare, vitae consequat nibh viverra. Curabitur semper feugiat nunc et ultrices. Suspendisse id tellus in velit auctor elementum vitae in enim. Nunc eu venenatis risus. Sed sed purus magna. Proin nec facilisis eros. Donec et elit id risus tristique congue ut nec lectus. Sed augue mi, accumsan non ligula vel, dapibus lacinia mauris. Mauris quam arcu, congue et sapien eu, consectetur placerat nisl. Nam finibus quam pulvinar vehicula placerat.Quisque rhoncus sapien quis turpis lacinia, egestas congue neque placerat. Phasellus eu bibendum quam. Proin quis justo erat. Nam faucibus lorem iaculis, aliquam risus non, vulputate sapien. Ut gravida interdum mauris vel rutrum. Nullam tortor est, bibendum at nibh quis, tincidunt rutrum tellus. Integer luctus ante eu sapien euismod, a tempus quam congue. Donec ullamcorper posuere leo, vel condimentum purus venenatis ut. Maecenas in faucibus justo, convallis euismod sem. In ut magna vel est blandit porta. Ut et porta lorem, et scelerisque tortor. Curabitur faucibus, velit vel tristique aliquam, leo nibh porta sem, at euismod augue tortor a sapien. Maecenas sit amet augue id ipsum dictum malesuada id ac ligula. Fusce vel fringilla nisl, nec hendrerit sapien.Vestibulum lorem nisl, cursus varius lacus quis, eleifend posuere sem. Cras vehicula faucibus diam a vehicula. Etiam tincidunt malesuada porta. Aliquam erat volutpat. Integer nec diam diam. Nullam tortor lorem, rutrum nec consectetur vitae, gravida a purus. Nullam vehicula eros libero, non consectetur ligula imperdiet nec. Quisque malesuada justo mi, at tincidunt neque pharetra et. Duis vitae magna eu libero malesuada dictum. Maecenas sit amet ornare velit. Maecenas egestas velit egestas felis dignissim blandit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et tortor elit. Vivamus nibh orci, auctor eu pharetra sit amet, finibus et turpis. Nullam scelerisque vel lorem et condimentum. Pellentesque a est nulla. Praesent molestie cursus commodo. Integer ac odio at arcu imperdiet volutpat ut et velit. Ut viverra pellentesque elit eget mattis. Maecenas et convallis risus. Aenean sem nisl, cursus sit amet faucibus eget, lacinia eget sapien. Aenean eu elementum mi, condimentum pharetra ante. Aliquam scelerisque malesuada purus.Etiam elementum libero neque, id pellentesque lectus sodales non. Suspendisse dui arcu, vehicula quis diam semper, tempus elementum nulla. Duis ut ipsum ut ex mollis malesuada sed ultrices nisl. Etiam sit amet massa vestibulum, imperdiet nunc ac, sagittis massa. Nulla quis orci sit amet sem faucibus malesuada. Sed ut eros placerat, consequat nisl facilisis, accumsan diam. Phasellus eleifend velit non iaculis aliquet. Etiam ac dolor tincidunt, luctus metus et, luctus erat. Praesent fermentum sed dui et fermentum. Donec nec pretium neque, eu vulputate urna. Donec non metus sit amet velit interdum viverra. Praesent non luctus velit. Maecenas velit arcu, suscipit sed mauris et, ultrices ullamcorper arcu. Phasellus commodo magna metus, vel mollis arcu aliquam non. Nunc rhoncus velit nisi, a fermentum eros luctus nec.Cras cursus tempus velit, vel commodo ex dapibus a. Sed nec commodo libero, semper iaculis purus. Praesent faucibus, mi vitae scelerisque feugiat, ligula dui dictum quam, eget porta neque quam ac ligula. Ut ullamcorper ipsum quis urna ornare, vitae consequat nibh viverra. Curabitur semper feugiat nunc et ultrices. Suspendisse id tellus in velit auctor elementum vitae in enim. Nunc eu venenatis risus. Sed sed purus magna. Proin nec facilisis eros. Donec et elit id risus tristique congue ut nec lectus. Sed augue mi, accumsan non ligula vel, dapibus lacinia mauris. Mauris quam arcu, congue et sapien eu, consectetur placerat nisl. Nam finibus quam pulvinar vehicula placerat.Quisque rhoncus sapien quis turpis lacinia, egestas congue neque placerat. Phasellus eu bibendum quam. Proin quis justo erat. Nam faucibus lorem iaculis, aliquam risus non, vulputate sapien. Ut gravida interdum mauris vel rutrum. Nullam tortor est, bibendum at nibh quis, tincidunt rutrum tellus. Integer luctus ante eu sapien euismod, a tempus quam congue. Donec ullamcorper posuere leo, vel condimentum purus venenatis ut. Maecenas in faucibus justo, convallis euismod sem. In ut magna vel est blandit porta. Ut et porta lorem, et scelerisque tortor. Curabitur faucibus, velit vel tristique aliquam, leo nibh porta sem, at euismod augue tortor a sapien. Maecenas sit amet augue id ipsum dictum malesuada id ac ligula. Fusce vel fringilla nisl, nec hendrerit sapien.Vestibulum lorem nisl, cursus varius lacus quis, eleifend posuere sem. Cras vehicula faucibus diam a vehicula. Etiam tincidunt malesuada porta. Aliquam erat volutpat. Integer nec diam diam. Nullam tortor lorem, rutrum nec consectetur vitae, gravida a purus. Nullam vehicula eros libero, non consectetur ligula imperdiet nec. Quisque malesuada justo mi, at tincidunt neque pharetra et. Duis vitae magna eu libero malesuada dictum. Maecenas sit amet ornare velit. Maecenas egestas velit egestas felis dignissim blandit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et tortor elit. Vivamus nibh orci, auctor eu pharetra sit amet, finibus et turpis. Nullam scelerisque vel lorem et condimentum. Pellentesque a est nulla. Praesent molestie cursus commodo. Integer ac odio at arcu imperdiet volutpat ut et velit. Ut viverra pellentesque elit eget mattis. Maecenas et convallis risus. Aenean sem nisl, cursus sit amet faucibus eget, lacinia eget sapien. Aenean eu elementum mi, condimentum pharetra ante. Aliquam scelerisque malesuada purus.Etiam elementum libero neque, id pellentesque lectus sodales non. Suspendisse dui arcu, vehicula quis diam semper, tempus elementum nulla. Duis ut ipsum ut ex mollis malesuada sed ultrices nisl. Etiam sit amet massa vestibulum, imperdiet nunc ac, sagittis massa. Nulla quis orci sit amet sem faucibus malesuada. Sed ut eros placerat, consequat nisl facilisis, accumsan diam. Phasellus eleifend velit non iaculis aliquet. Etiam ac dolor tincidunt, luctus metus et, luctus erat. Praesent fermentum sed dui et fermentum. Donec nec pretium neque, eu vulputate urna. Donec non metus sit amet velit interdum viverra. Praesent non luctus velit. Maecenas velit arcu, suscipit sed mauris et, ultrices ullamcorper arcu. Phasellus commodo magna metus, vel mollis arcu aliquam non. Nunc rhoncus velit nisi, a fermentum eros luctus nec.Cras cursus tempus velit, vel commodo ex dapibus a. Sed nec commodo libero, semper iaculis purus. Praesent faucibus, mi vitae scelerisque feugiat, ligula dui dictum quam, eget porta neque quam ac ligula. Ut ullamcorper ipsum quis urna ornare, vitae consequat nibh viverra. Curabitur semper feugiat nunc et ultrices. Suspendisse id tellus in velit auctor elementum vitae in enim. Nunc eu venenatis risus. Sed sed purus magna. Proin nec facilisis eros. Donec et elit id risus tristique congue ut nec lectus. Sed augue mi, accumsan non ligula vel, dapibus lacinia mauris. Mauris quam arcu, congue et sapien eu, consectetur placerat nisl. Nam finibus quam pulvinar vehicula placerat.Quisque rhoncus sapien quis turpis lacinia, egestas congue neque placerat. Phasellus eu bibendum quam. Proin quis justo erat. Nam faucibus lorem iaculis, aliquam risus non, vulputate sapien. Ut gravida interdum mauris vel rutrum. Nullam tortor est, bibendum at nibh quis, tincidunt rutrum tellus. Integer luctus ante eu sapien euismod, a tempus quam congue. Donec ullamcorper posuere leo, vel condimentum purus venenatis ut. Maecenas in faucibus justo, convallis euismod sem. In ut magna vel est blandit porta. Ut et porta lorem, et scelerisque tortor. Curabitur faucibus, velit vel tristique aliquam, leo nibh porta sem, at euismod augue tortor a sapien. Maecenas sit amet augue id ipsum dictum malesuada id ac ligula. Fusce vel fringilla nisl, nec hendrerit sapien.Vestibulum lorem nisl, cursus varius lacus quis, eleifend posuere sem. Cras vehicula faucibus diam a vehicula. Etiam tincidunt malesuada porta. Aliquam erat volutpat. Integer nec diam diam. Nullam tortor lorem, rutrum nec consectetur vitae, gravida a purus. Nullam vehicula eros libero, non consectetur ligula imperdiet nec. Quisque malesuada justo mi, at tincidunt neque pharetra et. Duis vitae magna eu libero malesuada dictum. Maecenas sit amet ornare velit. Maecenas egestas velit egestas felis dignissim blandit."}

#User Agents
userAgent1 = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'
userAgent2 = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1'
userAgent3 = 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G930F Build/R16NW; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/74.0.3729.157 Mobile Safari/537.36'
userAgent4 = 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
userAgent5 = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1'
userAgent6 = 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G930F Build/R16NW; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/74.0.3729.157 Mobile Safari/537.36'
userAgent7 = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko)'
userAgent8 = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko)'
userAgent9 = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148'
userAgent10 = 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
userAgent11 = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1'
userAgent12 = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148'

agents = [userAgent1,userAgent10,userAgent11,userAgent12,userAgent2,userAgent3,userAgent4,userAgent5,userAgent6,userAgent7,userAgent8,userAgent9]

# mapping regions - developers

#  [1] asia-east1
#  [2] asia-northeast1
#  [3] europe-north1
#  [4] europe-west1
#  [5] europe-west4
#  [6] us-central1
#  [7] us-east1
#  [8] us-east4
#  [9] us-west1

region1 = "europe-west1"
region2 = "europe-north1"
region3 = "us-central1"
region4 = "asia-northeast1"
region5 = "us-east1"
region6 = "us-east4"
region7 = "us-west1"
region8 = "asia-east1"
region9 = "europe-west4"

asianortheast2 = "hugh@startkaleo.com" # Consumer
europewest3 = "grant@enterprise.com" # Consumer
useast4 = "petsell@wrong.com" # Catalog
australiasoutheast1 = "tomjones@enterprise.com" # Catalog
northamericanortheast1 = "joew@bringiton.com" # Catalog & consumer
southamericaeast1 = "acop@enterprise.com" # Catalog
asiaeast1 = "barbg@enterprise.com" # Store & shopping
uswest2 = "freds@bringiton.com" # Consumer
europewest2 = "dandee@enterprise.com" # Admin
                



url_metadata = "http://metadata.google.internal/computeMetadata/v1/instance/zone"


r = requests.get(url = url_metadata,headers={'Metadata-Flavor': 'Google'})
data = r.content
print("We are in: " + str(data, 'utf-8'))
request_region = str(data, 'utf-8')
#request_region = "europe-west1"

final_user = ""

if region1 in request_region:
    final_user=europewest2
elif region2 in request_region:
    final_user=europewest3
elif region3 in request_region:
    final_user=useast4
elif region4 in request_region:
    final_user=asianortheast2
elif region5 in request_region:
    final_user=australiasoutheast1
elif region6 in request_region:
    final_user=northamericanortheast1
elif region7 in request_region:
    final_user=southamericaeast1
elif region8 in request_region:
    final_user=asiaeast1
elif region9 in request_region:
    final_user=uswest2
else:
    raise Exception


print("URL: "+apigee_url)
print("USERS: "+final_user)
print("TOKEN: "+token)

print(apigee_url+"developers/"+final_user)

app = requests.get(url = apigee_url+"developers/"+final_user,headers={'Authorization': "Basic "+token})
print("This is my app: " +str(app))
print(apigee_url+"developers/"+final_user+"/apps/"+app.json()['apps'][0])
apiKey = requests.get(url = apigee_url+"developers/"+final_user+"/apps/"+app.json()['apps'][0],headers={'Authorization': "Basic "+token})
#print(apiKey.json()['credentials'][0]['consumerKey'])
appkey = apiKey.json()['credentials'][0]['consumerKey']

def randomNum():
    return str(random.randint(1,6))

def returnPayload():
    if random.randint(0,100) >= 85:
        return hugePayload
    else:
        return {"content":"something"}

def starting(l):
    print("Starting load")

#Catalog functions
def catalogGetList(l):
    l.client.get("/catalog?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def catalogGet(l):
    l.client.get("/catalog/"+randomNum()+"?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def catalogPost(l):
    l.client.post("/catalog?apikey="+appkey,{"product":"this is a new product"} ,headers={"User-Agent":  random.choice(agents)})

#Checkout functions

def checkoutGetList(l):
    l.client.get("/checkout?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def checkoutGet(l):
    l.client.get("/checkout/"+randomNum()+"?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def checkoutPost(l):
    l.client.post("/checkout?apikey="+appkey,{"cart":"this is a new cart"} ,headers={"User-Agent":  random.choice(agents)})

#Loyalty functions

def loyaltyGetList(l):
    l.client.get("/loyalty?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def loyaltyGet(l):
    l.client.get("/loyalty/"+randomNum()+"?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def loyaltyPost(l):
    l.client.post("/loyalty?apikey="+appkey,{"loyalty":"this is a new loyalty"} ,headers={"User-Agent":  random.choice(agents)})

#Loyalty functions

def recommendationGetList(l):
    l.client.get("/recommendation?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def recommendationGet(l):
    l.client.get("/recommendation/"+randomNum()+"?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def recommendationPost(l):
    l.client.post("/recommendation?apikey="+appkey,returnPayload() ,headers={"User-Agent":  random.choice(agents)})

#Loyalty functions

def userGetList(l):
    l.client.get("/user?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def userGet(l):
    l.client.get("/user/"+randomNum()+"?apikey="+appkey ,headers={"User-Agent":  random.choice(agents)})
def userPost(l):
    l.client.post("/user?apikey="+appkey,returnPayload() ,headers={"User-Agent":  random.choice(agents)})


class UserBehavior(TaskSet):

    def on_start(self):
        starting(self)

    print("This is the final user: " + final_user)
    if final_user == asianortheast2:
        tasks = {loyaltyGetList: 1, loyaltyGet: 5,loyaltyPost: 1, recommendationGet: 3, recommendationPost: 2, recommendationGetList: 7, userGet: 6, userPost: 1}
    elif final_user == europewest3:
        tasks = {loyaltyGetList: 8, loyaltyGet: 3,loyaltyPost: 1, recommendationGet: 7, recommendationPost: 2, recommendationGetList: 7, userGet: 5, userPost: 1}
    elif final_user == useast4:
        tasks = {catalogGet: 8, catalogGetList: 3,catalogPost: 1}
    elif final_user == australiasoutheast1:
        tasks = {catalogGet: 8, catalogGetList: 3,catalogPost: 1}
    elif northamericanortheast1 == australiasoutheast1:
        tasks = {catalogGet: 8, catalogGetList: 3,catalogPost: 1, loyaltyGetList: 3, loyaltyGet: 3,loyaltyPost: 1, recommendationGet: 7, recommendationPost: 2, recommendationGetList: 7, userGet: 5, userPost: 1}
    elif final_user == southamericaeast1:
        tasks = {catalogGet: 8, catalogGetList: 3,catalogPost: 1}
    elif final_user == asiaeast1:
        tasks = {catalogGet: 8, catalogGetList: 3,catalogPost: 1, checkoutGet: 3, checkoutGetList:1, checkoutPost: 5, recommendationGet: 7, recommendationPost: 2, recommendationGetList: 7}
    elif final_user == uswest2:
        tasks = {loyaltyGetList: 1, loyaltyGet: 5,loyaltyPost: 1, recommendationGet: 3, recommendationPost: 2, recommendationGetList: 7, userGet: 6, userPost: 1}
    elif final_user == europewest2:
        tasks = {loyaltyGetList: 1, loyaltyGet: 5,loyaltyPost: 1, recommendationGet: 3, recommendationPost: 2, recommendationGetList: 7, userGet: 6, userPost: 1, userGet: 5, userPost: 1, checkoutGet: 3, checkoutGetList:1, checkoutPost: 5, catalogGet: 8, catalogGetList: 3, catalogPost: 1}
    

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait=5000
    max_wait=9000