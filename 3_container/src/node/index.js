'use strict';

const express = require('express');

const PORT = 80;
const HOST = '0.0.0.0';

const app = express();

app.get('/', (req, res) => {
  res.send('Hello World from node.js');
});

// golangからアクセスされる
app.get('/hello', (req, res) => {
  res.send('Hello from node.js');
});

const startServer = async () => {
  try {
    await app.listen(PORT, HOST);
    console.log(`Server running on http://${HOST}:${PORT}`);
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
};

startServer();
