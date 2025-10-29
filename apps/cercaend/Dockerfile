# Use a Flutter SDK image to build the web app
FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build the web app
RUN flutter build web

# Use a lightweight web server
FROM mirror.gcr.io/library/nginx:alpine

# Copy the Flutter web build output to the web server's root directory
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80