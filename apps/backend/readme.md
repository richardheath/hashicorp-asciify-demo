
```
# RUN
docker run -p 49160:8081 mnd22/asciifier-service

# BUILD/PUBLISH
docker build -t mnd22/asciifier-service .
docker tag mnd22/asciifier-service $DOCKER_ID_USER/asciifier-service
docker tag mnd22/asciifier-service mnd22/asciifier-service:1.0.0
docker push mnd22/asciifier-service:1.0.0
```

# Saple Images
```
# Eiffel
https://images-na.ssl-images-amazon.com/images/I/615StV0ULHL._SL1000_.jpg

GO
https://www.archer.com.mt/wp-content/uploads/golang-gopher.png

# CONSUL
https://www.datocms-assets.com/2885/1508281312-blog-consul.svg

# Tesla
https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Tesla_Motors.svg/2000px-Tesla_Motors.svg.png
```