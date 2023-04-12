# Use an official Ubuntu runtime as the base image
FROM ubuntu:latest

# Install PostgreSQL and other necessary packages
RUN apt-get update && \
    apt-get install -y postgresql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the default command to run when starting the container
CMD ["postgres"]
