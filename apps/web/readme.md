
```
# RUN
docker run -p 49161:8080 -d rheath/asciifier-web

# BUILD/PUBLISH
docker build -t mnd22/asciifier-web .
docker run -p 49160:8080 mnd22/asciifier-web
docker tag mnd22/asciifier-web mnd22/asciifier-web
docker tag mnd22/asciifier-web mnd22/asciifier-web:1.0.0
docker push mnd22/asciifier-web:1.0.0
```