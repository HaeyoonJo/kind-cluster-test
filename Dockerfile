FROM nginx:alpine
LABEL maintainer="Haeyoon Jo <mymail@gmail.com>"

COPY website /website
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
