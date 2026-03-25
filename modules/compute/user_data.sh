#!/bin/bash
yum update -y
yum install -y httpd

# Create a simple web page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Cloudelligent - Instance ${instance_number}</title>
    <style>
        body { font-family: Arial; margin: 50px; }
        .container { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Cloudelligent</h1>
        <p>This is Instance #${instance_number}</p>
        <p>Hostname: <code>$(hostname)</code></p>
        <p>Instance ID: <code>$(ec2-metadata --instance-id | cut -d' ' -f2)</code></p>
    </div>
</body>
</html>
EOF

# Start Apache web server
systemctl start httpd
systemctl enable httpd
