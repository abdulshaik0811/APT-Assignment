const express = require('express');
const app = express();
const PORT = 8080;

// Simple text response
app.get('/', (req, res) => {
    console.log('GET / - Request received');
    res.send('DevOps Assignment API is running!');
});

// Health check endpoint
app.get('/health', (req, res) => {
    console.log('GET /health - Health check');
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
