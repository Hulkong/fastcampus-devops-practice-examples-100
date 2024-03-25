const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors()); // CORS를 활성화하여 모든 도메인에서의 요청을 허용

// MongoDB 연결
const mongoURI = 'mongodb://mongodb:27017/mydatabase'; // MongoDB URI를 적절히 설정하세요
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true });

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB 연결 에러:'));
db.once('open', function() {
  console.log('MongoDB 연결 성공');
});

app.get('/', (req, res) => {
  res.send('Hello World from Node.js Express Backend!');
});

app.get('/api/greet', (req, res) => {
  res.json({ message: 'Hello from Backend!' });
});

app.get('/health-check', (req, res) => {
  res.send('Healthy!');
});

app.get('/db-check', (req, res) => {
  if (mongoose.connection.readyState == 1) {
    res.status(200).send('MongoDB에 성공적으로 연결되었습니다.');
  } else {
    res.status(500).send('MongoDB 연결 실패');
  }
});

app.listen(port, () => {
  console.log(`Node.js app listening at http://localhost:${port}`);
});
