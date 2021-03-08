/**
 * This server will be used as demo for Admission control
 */
const

  // The certificates folder
  certsFolder = process.env.CERTS_FOLDER || "./certs",
  // The desired port or use default 3000
  port = process.env.PORT || 3000,
  
  express = require('express'),
  https = require('https'),
  fs = require('fs-extra'),
  app = express(),

  // TLS data for https server
  options = {
    ca: fs.readFileSync(`${certsFolder}/ca.crt`),
    key: fs.readFileSync(`${certsFolder}/server.key`),
    cert: fs.readFileSync(`${certsFolder}/server.crt`)
  };

// Set the default router
app.get('/', (req, res) => {
  res.send('Hello World!');
});

https.createServer(options, app)
  .listen(port, () => {
    console.log(`Server running on https://127.0.0.1:${port}/`);
  });