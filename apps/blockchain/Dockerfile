# Use the official Go image.
# This will be our builder.
FROM mirror.gcr.io/library/golang:1.19-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY . .

# We want to populate the module cache based on the go.mod file.
COPY go.mod go.sum ./api/
WORKDIR /app/api
RUN go mod download


# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/app .

# Start a new stage from scratch for a smaller image
FROM mirror.gcr.io/library/alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /go/bin/app .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./app"]
