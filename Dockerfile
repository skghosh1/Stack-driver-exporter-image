# Use the official Golang image (1.19 or later) to build the binary
FROM golang:1.19-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Install git and necessary packages for Go modules
RUN apk add --no-cache git

# Clone the Stackdriver Exporter repository
RUN git clone https://github.com/prometheus-community/stackdriver_exporter.git .

# Ensure Go modules are downloaded
RUN go mod tidy

# Build the Stackdriver Exporter binary
RUN go build -o stackdriver_exporter .

# Use a minimal base image to reduce the size of the final image
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the binary from the builder image
COPY --from=builder /app/stackdriver_exporter .

# Expose the port that the exporter listens on
EXPOSE 9255

# Set the entrypoint to run the exporter
ENTRYPOINT ["/app/stackdriver_exporter"]
