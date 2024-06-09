# Dockerfile
# 1. Use a minimal base image
FROM python:3.8-slim-buster

# 2. Combine RUN commands
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# 3. Leverage Multi-Stage builds
FROM python:3.8-slim-buster as builder
COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.8-slim-buster
COPY --from=builder /root/.local /root/.local
COPY . .

# 4. Remove unnecessary files
RUN rm -rf /tmp/* /var/tmp/*

# 5. Optimize docker build cache
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

CMD ["python3", "app.py"]