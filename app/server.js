// app/server.js
const http = require('http');
const os = require('os');
const port = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    return res.end('ok');
  }
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(`Hello from private EC2! Host: ${os.hostname()}\n`);
});

server.listen(port, () => {
  console.log(`Server listening on ${port}`);
});
