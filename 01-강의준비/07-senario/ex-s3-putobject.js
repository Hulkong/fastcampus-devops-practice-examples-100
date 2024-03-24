const express = require('express');
const AWS = require('aws-sdk');
const fs = require('fs');
const app = express();
const port = 3000;

// AWS S3 설정
const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION
});

app.get('/', function(req, res) {
  res.send('hello world');
});

app.get('/health-check', function(req, res) {
  res.send('healthy');
});

app.get('/upload', (req, res) => {
  const filePath = './test-upload.png'

  // 파일을 읽어서 S3에 업로드하는 함수
  const uploadFile = () => {
    // 파일 읽기
    const fileContent = fs.readFileSync(filePath);

    // 업로드 파라미터 설정
    const params = {
      Bucket: 'part01-s3',
      Key: 'uploads/image.png',
      Body: fileContent
    };

    // S3에 파일 업로드
    s3.upload(params, (err, data) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.send(`File uploaded successfully. ${data.Location}`);
    });
  };

  // 업로드 실행
  uploadFile();
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
