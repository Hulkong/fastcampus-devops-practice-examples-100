const express = require('express');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

// MongoDB 연결
const mongoURI = 'mongodb://mongodb:27017/mydatabase'; // MongoDB URI를 적절히 설정하세요
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true });

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB 연결 에러:'));
db.once('open', function() {
  console.log('MongoDB 연결 성공');
});

// CPU 부하를 생성하는 함수
function generateCpuLoad(seconds) {
  const endTime = Date.now() + seconds * 1000;
  while (Date.now() < endTime) {
      // CPU를 사용하는 무한 루프
  }
}

app.get('/', function(req, res) {
  res.send('hello world');
});

app.get('/cpu', (req, res) => {
  // 요청이 들어오면 CPU 부하를 60초간 생성
  generateCpuLoad(10);
  res.send('CPU load generated for 10 seconds');
});

app.listen(port, () => {
  console.log(`서버가 http://localhost:${port}에서 실행중입니다.`);
});
