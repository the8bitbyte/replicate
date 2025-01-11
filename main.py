from flask import Flask, request, jsonify
import requests
import os
import json

app = Flask(__name__)

# File paths
ip_log_file = "ip_log.json"
counter_file = "counter.txt"
webhook_file = "resources/discord/webhook"

# Initialize IP log
if not os.path.exists(ip_log_file):
    with open(ip_log_file, "w") as f:
        json.dump({}, f)

# Initialize counter
if not os.path.exists(counter_file):
    with open(counter_file, "w") as f:
        f.write("0")

def load_ip_log():
    with open(ip_log_file, "r") as f:
        return json.load(f)

def save_ip_log(ip_log):
    with open(ip_log_file, "w") as f:
        json.dump(ip_log, f)

def read_counter():
    with open(counter_file, "r") as f:
        return int(f.read())

def update_counter(value):
    with open(counter_file, "w") as f:
        f.write(str(value))

def read_webhook():
    if not os.path.exists(webhook_file):
        print("Webhook file not found!")
    with open(webhook_file, "r") as f:
        return f.read().strip()

def get_location(ip):
    try:
        response = requests.get(f"http://ip-api.com/json/{ip}")
        if response.status_code == 200:
            data = response.json()
            city = data.get("city", "Unknown City")
            region = data.get("regionName", "Unknown Region")
            return f"{city}, {region}"
    except requests.exceptions.RequestException as e:
        print(f"Error fetching location: {e}")
    return "Unknown Location"

def send(client_ip, counter):
    webhook_url = read_webhook()
    location = get_location(client_ip)
    embed = {
        "title": "New Visitor Logged",
        "description": f"IP Address: {client_ip}\nLocation: {location}\nCounter Value: {counter}",
        "color": int("9f00ff", 16),  # Convert hex color to decimal
    }
    message = {
        "embeds": [embed]
    }
    try:
        response = requests.post(webhook_url, json=message)
        response.raise_for_status()
        print("Webhook sent successfully")
    except requests.exceptions.RequestException as e:
        print(f"Error sending webhook: {e}")

@app.route("/", methods=["POST"])
def log_ip():
    client_ip = request.headers.get("X-Forwarded-For", request.remote_addr)

    ip_log = load_ip_log()
    if client_ip in ip_log:
        return "Blocked", 403

    ip_log[client_ip] = True
    save_ip_log(ip_log)

    counter = read_counter()
    counter += 1
    update_counter(counter)

    send(client_ip, counter)

    print(f"Logged IP: {client_ip}, Counter: {counter}")
    return "Logged", 200

@app.route("/counter", methods=["GET"])
def get_counter():
    counter = read_counter()
    return jsonify({"current_counter": counter})

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
