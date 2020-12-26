
docker login
# Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
# Username: angelfreya
# Password: 
# WARNING! Your password will be stored unencrypted in /home/angel/.docker/config.json.
# Configure a credential helper to remove this warning. See
# https://docs.docker.com/engine/reference/commandline/login/#credentials-store
#
# Login Succeeded

# before push our images to DockerHub repository we should tag it
# docker tag IMAGE:TAG DOCKER_HUB_USER/IMAGE:TAG
docker tag helloworld:2.0 angelfreya/helloworld:2.0
docker tag angelfreya/helloworld:2.0 angelfreya/helloworld:latest

docker images
# REPOSITORY              TAG       IMAGE ID       CREATED        SIZE
# angelfreya/helloworld   2.0       3c40f618db6c   13 hours ago   158MB
# angelfreya/helloworld   latest    3c40f618db6c   13 hours ago   158MB
# helloworld              2.0       3c40f618db6c   13 hours ago   158MB
# helloworld              latest    3c40f618db6c   13 hours ago   158MB
# helloworld              1.0       ef54a8723a64   14 hours ago   158MB
# ubuntu                  18.04     2c047404e52d   4 weeks ago    63.3MB

# Upload our image to repository
docker push angelfreya/helloworld
docker push angelfreya/helloworld:2.0

# Using default tag: latest
# The push refers to repository [docker.io/angelfreya/helloworld]
# f589d22cc498: Pushed 
# 75dcd30aa8a1: Pushed 
# b265a7ee0924: Pushed 
# fe6d8881187d: Mounted from library/ubuntu 
# 23135df75b44: Mounted from library/ubuntu 
# b43408d5f11b: Mounted from library/ubuntu 
# latest: digest: sha256:a7c48948c044acb3577f29f8cb112ce523182e0079764c71442ab86903663247 size: 1574

# If we could download the image, we should remove all before
docker image rm 3c40f618db6c ef54a8723a64 2c047404e52d -f
# Untagged: angelfreya/helloworld:2.0
# Untagged: angelfreya/helloworld:latest
# Untagged: angelfreya/helloworld@sha256:a7c48948c044acb3577f29f8cb112ce523182e0079764c71442ab86903663247
# Untagged: helloworld:2.0
# Untagged: helloworld:latest
# Deleted: sha256:3c40f618db6ca2a872170a35d1c9ac33a29421b32cd12e98381d5e97d53b9871
# Deleted: sha256:48be99009daf6d3c9d5a7b7dea45e36cd9941602a2bd6ce6eda70e416403ff09
# Untagged: helloworld:1.0
# Deleted: sha256:ef54a8723a6416ecd8b529baf2527081d681054700bedb4784646f46b10e9391
# Deleted: sha256:996db838f0b92104286644e4f063fa72396f207f625401a52f12adb0d29374ef
# Deleted: sha256:8342e76859cd21af3c0c940cbcc519bcc6783022b6190935aa16a3bb74ebc3eb
# Deleted: sha256:087f1ce72f15cd745a008fe264470ba51fc5e196aebd6797792a2ee7f668054e
# Deleted: sha256:06e1c84ad3a1b187d4a97b910f152c1e51a87dab2359af229f250398bdf80234
# Deleted: sha256:29552fe9e9548f2990f2be831605153be43757dad4ba9e1126579d418f6e74b1
# Deleted: sha256:008f7ae4c5c7d053d9787947583d731c99ff39146677dd9616957777049d8143
# Untagged: ubuntu:18.04
# Untagged: ubuntu@sha256:fd25e706f3dea2a5ff705dbc3353cf37f08307798f3e360a13e9385840f73fb3
# Deleted: sha256:2c047404e52d7f17bdac4121a13cd844447b74e13063f8cb8f8b314467feed06
# Deleted: sha256:9459b6a89846db0723e467610b841e6833dbb2aae6133319a91f2f70c388afac
# Deleted: sha256:9a9311f7fcddf94f7476ce89f9703e8360e8cf347ef486a280735f5cf98888cd
# Deleted: sha256:b43408d5f11b7b2faf048ae4eb25c296536c571fb2f937b4f1c3883386e93d64
# angel@ubuntu:~/docker-lab/02_docker-getting-started/nginx-helloworld$ docker images
# REPOSITORY   TAG       IMAGE ID   CREATED   SIZE

# Download your image
docker pull angelfreya/helloworld:2.0
# 2.0: Pulling from angelfreya/helloworld
# f22ccc0b8772: Pull complete 
# 3cf8fb62ba5f: Pull complete 
# e80c964ece6a: Pull complete 
# b73981adb9c0: Pull complete 
# 0648e53c16ff: Pull complete 
# 41509378228c: Pull complete 
# Digest: sha256:a7c48948c044acb3577f29f8cb112ce523182e0079764c71442ab86903663247
# Status: Downloaded newer image for angelfreya/helloworld:2.0
# docker.io/angelfreya/helloworld:2.0

# Update and rebuild Dockerfile
docker build -t helloworld:3.0 .
docker tag helloworld:3.0 angelfreya/helloworld:3.0

docker push angelfreya/hellworld:3.0
# The push refers to repository [docker.io/angelfreya/helloworld]
# 42de3c999538: Pushed
# d7117f6d2917: Pushed
# adfac622ed56: Pushed
# fe6d8881187d: Layer already exists
# 23135df75b44: Layer already exists
# b43408d5f11b: Layer already exists
# 3.0: digest: sha256:4229e2e44056757c2e4bc52d4d5acc31389f692bd644d0c9ed44ab5a2c4b2280 size: 1574

docker images
# REPOSITORY              TAG       IMAGE ID       CREATED              SIZE
# angelfreya/helloworld   3.0       a7ef080d2e35   About a minute ago   158MB
# helloworld              3.0       a7ef080d2e35   About a minute ago   158MB
# angelfreya/helloworld   2.0       3c40f618db6c   13 hours ago         158MB
# ubuntu                  18.04     2c047404e52d   4 weeks ago          63.3MB

