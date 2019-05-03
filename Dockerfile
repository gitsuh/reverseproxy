FROM nginx:alpine

COPY cert.key /etc/nginx/cert.key
COPY cert.crt /etc/nginx/cert.crt
COPY nginx.conf /etc/nginx/nginx.conf
