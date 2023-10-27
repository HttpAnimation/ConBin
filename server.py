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

