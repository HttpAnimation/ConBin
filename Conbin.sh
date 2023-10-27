#!/bin/bash

# Look for flask to be installed and install it if it's not
if ! python3 -c "import flask" &> /dev/null; then
echo "Flask is not found on python3 installing it now"
pip install flask
fi


# Marked for remove
# Make the html site
cat <<EOL > index.html
<!DOCTYPE html>
<html>
<head>
    <title>Conbin Media Server</title>
    <style>
        body {
            background-color: #000;
            color: #fff;
        }
    </style>
</head>
<body>
    <h1>Welcome to Conbin Media Server</h1>
    <ul>
        <li><a href="/CB/Code/Html/Movies.html">Movies</a></li>
        <li><a href="/shows">TV Shows</a></li>
        <li><a href="/music">Music</a></li>
        <li><a href="/photos">Photos</a></li>
    </ul>
</body>
</html>
EOL

cat <<EOL > server.py
from flask import Flask, send_from_directory
import configparser
import os

app = Flask(__name__)

# Load media paths from the Config.ini file, ignoring lines starting with '#'
config = configparser.ConfigParser()
config.read('Configs/Config.ini')

@app.route('/')
def index():
    return send_from_directory('', 'index.html')

@app.route('/<directory>/<path:filename>')
def serve_media(directory, filename):
    if directory in config['Media']:
        media_path = os.path.join(os.getcwd(), config['Media'][directory])
        return send_from_directory(media_path, filename)
    else:
        return "Directory not found", 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2342)

EOL

# start the server
python3 server.py