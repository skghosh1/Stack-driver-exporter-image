# Use an official Golang image as the build environment
FROM golang:1.23 as builder

# Set the working directory inside the container
WORKDIR /app

# Clone the Stackdriver Exporter repository
RUN git clone https://github.com/prometheus-community/stackdriver_exporter.git .

# Download Go modules
RUN go mod download

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
