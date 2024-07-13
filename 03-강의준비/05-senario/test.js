const request = require('supertest');
const express = require('express');

const app = express();
app.get('/', (req, res) => {
  res.send('Hello World!');
});

describe('GET /', () => {
  it('responds with Hello World', async () => {
    const response = await request(app).get('/');
    expect(response.text).toEqual('Hello World!');
  });
});
