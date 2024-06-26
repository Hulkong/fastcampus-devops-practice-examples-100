const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const { add } = require('../src/math');

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.get('/add', (req, res) => {
  const { a, b } = req.query;
  res.send(`Result: ${add(parseInt(a), parseInt(b))}`);
});

module.exports = app; // 테스트를 위해 export
