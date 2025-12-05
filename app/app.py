from flask import Flask, jsonify
import socket
import os
import datetime

app = Flask(__name__)

@app.route('/')
def index():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    html_content = f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Private EC2 Instance</title>
        <style>
            * {{
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }}
            
            body {{
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }}
            
            .container {{
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                padding: 40px;
                max-width: 800px;
                width: 100%;
                text-align: center;
            }}
            
            .header {{
                margin-bottom: 30px;
            }}
            
            h1 {{
                color: #333;
                font-size: 2.5em;
                margin-bottom: 10px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }}
            
            .subtitle {{
                color: #666;
                font-size: 1.1em;
                margin-bottom: 30px;
            }}
            
            .info-card {{
                background: #f8f9fa;
                border-radius: 15px;
                padding: 25px;
                margin: 20px 0;
                border-left: 5px solid #667eea;
                text-align: left;
            }}
            
            .info-title {{
                color: #555;
                font-size: 1.2em;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }}
            
            .info-value {{
                color: #333;
                font-size: 1.4em;
                font-weight: bold;
                padding: 10px;
                background: white;
                border-radius: 8px;
                margin-top: 5px;
                display: inline-block;
            }}
            
            .highlight {{
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 12px 24px;
                border-radius: 10px;
                font-size: 1.3em;
                margin: 20px 0;
                display: inline-block;
            }}
            
            .architecture {{
                margin-top: 30px;
                padding: 20px;
                background: #f0f2f5;
                border-radius: 15px;
            }}
            
            .architecture h3 {{
                color: #555;
                margin-bottom: 15px;
            }}
            
            .architecture-list {{
                display: flex;
                justify-content: center;
                gap: 15px;
                flex-wrap: wrap;
            }}
            
            .arch-item {{
                background: white;
                padding: 15px;
                border-radius: 10px;
                min-width: 120px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }}
            
            .footer {{
                margin-top: 30px;
                color: #777;
                font-size: 0.9em;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }}
            
            @media (max-width: 600px) {{
                .container {{
                    padding: 20px;
                }}
                
                h1 {{
                    font-size: 1.8em;
                }}
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🎯 Private EC2 Instance</h1>
                <p class="subtitle">Running securely behind Application Load Balancer</p>
            </div>
            
            <div class="highlight">
                ✅ You are under private-ec2 instance
            </div>
            
            <div class="info-card">
                <div class="info-title">🖥️ Instance Details</div>
                <div class="info-value">{hostname}</div>
            </div>
            
            <div class="info-card">
                <div class="info-title">📡 IP Address</div>
                <div class="info-value">{ip_address}</div>
            </div>
            
            <div class="info-card">
                <div class="info-title">🕒 Current Time</div>
                <div class="info-value">{current_time}</div>
            </div>
            
            <div class="architecture">
                <h3>🏗️ Infrastructure Architecture</h3>
                <div class="architecture-list">
                    <div class="arch-item">🌐 VPC</div>
                    <div class="arch-item">🔒 Private Subnet</div>
                    <div class="arch-item">⚖️ ALB</div>
                    <div class="arch-item">🚀 Auto Scaling</div>
                    <div class="arch-item">🐍 Python Flask</div>
                </div>
            </div>
            
            <div class="footer">
                <p>This application is deployed using Terraform with high availability</p>
                <p>Powered by Flask | Served by Gunicorn | Secured in Private Subnet</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    return html_content

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.datetime.now().isoformat(),
        'service': 'python-flask-app',
        'hostname': socket.gethostname()
    }), 200

@app.route('/api/info')
def info():
    return jsonify({
        'instance_id': socket.gethostname(),
        'ip_address': socket.gethostbyname(socket.gethostname()),
        'timestamp': datetime.datetime.now().isoformat(),
        'environment': 'private-subnet',
        'message': 'You are under private-ec2 instance'
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
