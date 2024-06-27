const request = require('supertest');
const http = require('http');
const app = require('../src/index');
const { add } = require('../src/math');

let server;
let agent;

beforeAll((done) => {
  server = http.createServer(app);
  server.listen(0, () => { // Listen on a random port
    agent = request.agent(server);
    done();
  });
});

afterAll((done) => {
  return server && server.close(done);
});

describe("GET /", () => {
  it("should return Hello, World!", async () => {
    const response = await agent.get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('Hello, World!');
  });
});

describe("GET /add", () => {
  it("returns the sum of two query parameters", async () => {
    const a = 5;
    const b = 3;
    const response = await agent.get(`/add?a=${a}&b=${b}`);
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe(`Result: ${add(a, b)}`);
  });
});