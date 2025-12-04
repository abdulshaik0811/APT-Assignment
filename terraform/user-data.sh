#!/bin/bash
set -e

# Update and install Node.js
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create app directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Create simple server.js with port from template variable
cat > server.js << EOL
const express = require('express');
const app = express();
const PORT = ${app_port};

app.get('/', (req, res) => {
    res.json({ 
        message: 'DevOps Assignment API',
        status: 'running',
        port: PORT,
        timestamp: new Date().toISOString()
    });
});

app.get('/health', (req, res) => {
    res.json({ status: 'ok' });
});

app.listen(PORT, () => {
    console.log('Server started on port ' + PORT);
});
EOL

# Create package.json
cat > package.json << EOL
{
  "name": "api-server",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOL

# Install dependencies and start server
npm install
nohup node server.js > app.log 2>&1 &

# Print status
echo "API server started on port ${app_port}"
echo "Test with: curl http://localhost:${app_port}/health"
