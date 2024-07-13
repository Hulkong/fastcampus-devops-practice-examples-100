# Dockerfile
FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y \
    dd \
    coreutils

# Script to generate large files
COPY generate_large_files.sh /usr/local/bin/generate_large_files.sh
RUN chmod +x /usr/local/bin/generate_large_files.sh

CMD ["/usr/local/bin/generate_large_files.sh"]
