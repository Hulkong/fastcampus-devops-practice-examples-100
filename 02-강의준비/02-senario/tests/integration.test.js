const request = require('supertest');
const app = require('../src/index');
const { add } = require('../src/math');

describe("GET /", () => {
  it("should return Hello, World!", async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('Hello, World!');
  });
});

describe("GET /add", () => {
  it("returns the sum of two query parameters", async () => {
    const a = 5;
    const b = 3;
    const response = await request(app).get(`/add?a=${a}&b=${b}`);
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe(`Result: ${add(a, b)}`);
  });
});