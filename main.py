import os
import subprocess
from flask import Flask, request, Response
from pathlib import Path

# Configuration
AUTH_FILE = "resources/tainted/key.txt"  # Path to the authentication file
APACHE_ACCESS_LOG = "/var/log/apache2/access.log"  # Path to Apache's access log
BUFFER_SIZE = 4096  # Size of chunks to read when streaming logs

app = Flask(__name__)
connected_client = None  # Tracks the currently connected client


def load_auth_key():
    """Load the authentication key from file."""
    try:
        return Path(AUTH_FILE).read_text().strip()
    except FileNotFoundError:
        print(f"Error: Authentication file '{AUTH_FILE}' not found.")
        return None


def stream_apache_log():
    """Generator to stream new entries from the Apache access log."""
    try:
        with subprocess.Popen(
            ["tail", "-f", APACHE_ACCESS_LOG], stdout=subprocess.PIPE, stderr=subprocess.PIPE
        ) as process:
            for line in iter(process.stdout.readline, b""):
                yield line
    except Exception as e:
        print(f"Error streaming Apache log: {e}")


@app.route("/api/log", methods=["POST"])
def api_log():
    global connected_client

    # Read the authentication key from the request
    client_key = request.data.decode("utf-8").strip()

    # Validate the key
    if client_key != load_auth_key():
        return Response("Authentication failed.", status=403)

    # Check if another client is connected
    if connected_client:
        return Response("Another client is already connected.", status=403)

    # Mark the client as connected
    connected_client = request.remote_addr
    print(f"Client {connected_client} connected.")

    # Stream the Apache log to the client
    def stream():
        global connected_client
        try:
            for line in stream_apache_log():
                yield line
        finally:
            print(f"Client {connected_client} disconnected.")
            connected_client = None

    return Response(stream(), content_type="text/plain")


if __name__ == "__main__":
    # Ensure the Apache log exists
    if not os.path.exists(APACHE_ACCESS_LOG):
        print(f"Error: Apache log file '{APACHE_ACCESS_LOG}' not found.")
        exit(1)

    # Load the authentication key
    if not load_auth_key():
        print("Error: Authentication key file is missing.")
        exit(1)

    # Run the Flask app
    app.run(host="0.0.0.0", port=7000)  # Port 5000 assumes the `/api` path is proxied from the web server
