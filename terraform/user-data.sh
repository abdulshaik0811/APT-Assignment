#!/bin/bash
set -e

# Update system
yum update -y

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create application directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Create package.json
cat > package.json << EOF
{
  "name": "simple-api",
  "version": "1.0.0",
  "description": "Simple REST API for DevOps Assignment",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

# Create server.js
cat > server.js << EOF
const express = require('express');
const app = express();
const PORT = ${app_port};

app.use(express.json());

// Root endpoint
app.get('/', (req, res) => {
    console.log('GET / - Request received');
    const response = {
        message: 'DevOps Assignment API is running!',
        timestamp: new Date().toISOString(),
        instance_id: process.env.AWS_INSTANCE_ID || 'local'
    };
    res.json(response);
});

// Health check endpoint
app.get('/health', (req, res) => {
    console.log('GET /health - Health check');
    res.json({ 
        status: 'ok', 
        timestamp: new Date().toISOString() 
    });
});

// Info endpoint
app.get('/info', (req, res) => {
    res.json({
        service: 'DevOps Assignment API',
        version: '1.0.0',
        port: PORT,
        environment: process.env.NODE_ENV || 'development'
    });
});

app.listen(PORT, () => {
    console.log(\`Server running on port \${PORT}\`);
    console.log(\`Health check available at http://localhost:\${PORT}/health\`);
});
EOF

# Install dependencies
npm install

# Create systemd service
cat > /etc/systemd/system/api.service << EOF
[Unit]
Description=DevOps Assignment API
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/app
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Start and enable service
systemctl daemon-reload
systemctl start api
systemctl enable api

# Output instance metadata (optional)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "Instance ID: $INSTANCE_ID"
echo "Application started on port ${app_port}"
