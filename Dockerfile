# Use an official Golang image as the build environment
FROM golang:1.23 as builder

# Set the working directory inside the container
WORKDIR /app

# Install git and necessary packages for Go modules
RUN apk add --no-cache git

# Clone the Stackdriver Exporter repository
RUN git clone https://github.com/prometheus-community/stackdriver_exporter.git .

# Copy the Go modules files
COPY go.mod go.sum ./

# Download Go modules
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Stackdriver Exporter binary
RUN go build -o stackdriver_exporter .

# Use a minimal base image to reduce the size of the final image
FROM gcr.io/distroless/base

# Set the working directory inside the container
WORKDIR /

# Copy the Stackdriver Exporter binary from the build stage
COPY --from=builder /app/stackdriver_exporter /stackdriver_exporter

# Expose the necessary port
EXPOSE 9255

# Run the Stackdriver Exporter binary
ENTRYPOINT ["/stackdriver_exporter"]
