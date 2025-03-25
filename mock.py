import os
from http.server import BaseHTTPRequestHandler, HTTPServer

class MockHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(f"OK from {os.getenv('MOCK_NAME', 'unknown')}".encode('utf-8'))
    
    def do_POST(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(f"OK from {os.getenv('MOCK_NAME', 'unknown')}".encode('utf-8'))

if __name__ == "__main__":
    server = HTTPServer(('0.0.0.0', 80), MockHandler)
    server.serve_forever()
