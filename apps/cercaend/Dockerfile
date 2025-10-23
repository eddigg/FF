# Use a lightweight web server
FROM mirror.gcr.io/library/nginx:alpine

# Copy the Flutter web build output to the web server's root directory
COPY build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80
