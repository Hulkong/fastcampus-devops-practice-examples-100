# Node.js 공식 이미지를 베이스 이미지로 사용
FROM node:18

# 애플리케이션 디렉토리 생성
WORKDIR /usr/src/app

# 애플리케이션 의존성 설치
# package.json 과 package-lock.json을 먼저 복사
COPY package*.json ./

RUN npm install

# 애플리케이션 소스 추가
COPY . .

# 애플리케이션 실행을 위한 포트 설정
EXPOSE 3000

# 애플리케이션 실행
CMD [ "node", "server.js" ]
