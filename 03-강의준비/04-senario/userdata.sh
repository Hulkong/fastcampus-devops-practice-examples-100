#!/bin/bash
# Install Docker
amazon-linux-extras install -y docker
service docker start
usermod -a -G docker ec2-user

# Create Dockerfile and build script
cat << 'EOF' > /home/ec2-user/Dockerfile
FROM ubuntu:latest
RUN dd if=/dev/zero of=/bigfile bs=1M count=1024 # 0으로 채워진 1024MB 크기의 파일을 생성합니다.
EOF

cat << 'EOF' > /home/ec2-user/build_images.sh
#!/bin/sh
for i in $(seq 1 100); do
  # docker system prune -af
  docker build --no-cache -t example_image_$i .
  df -h /
  sleep 1
done
EOF

chmod +x /home/ec2-user/build_images.sh

# Run the build script
# /home/ec2-user/build_images.sh

# Install logrotate
# yum install -y logrotate

# Docker system prune script
cat << 'EOF' > /home/ec2-user/docker_prune.sh
#!/bin/sh
# Remove all unused containers, networks, images (both dangling and unreferenced)
docker system prune -af
EOF

chmod +x /home/ec2-user/docker_prune.sh

# Set up cron job to run docker_prune.sh daily
echo "0 0 * * * /home/ec2-user/docker_prune.sh" > /etc/cron.d/docker_prune

# Logrotate configuration for Docker
cat << 'EOF' > /etc/logrotate.d/docker
/var/lib/docker/containers/*/*.log {
  daily
  rotate 7
  compress
  delaycompress
  missingok
  notifempty
  copytruncate
}
EOF
