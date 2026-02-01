const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.json({ status: 'ok', time: new Date().toISOString() });
});

app.get('/', (req, res) => {
  res.send('<h1>DevOps Todo App</h1><p>Simple app for CI/CD demo</p>');
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
// test change for PR
