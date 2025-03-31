import os
from http.server import BaseHTTPRequestHandler, HTTPServer

class MockHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        id_header_name = "x-rh-identity" 
        id_header_value = self.headers.get(id_header_name)
        req_id_header_name = "x-rh-insights-request-id" 
        req_id_header_value = self.headers.get(req_id_header_name)
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(f"Identity header = {id_header_value}\n".encode('utf-8'))
        self.wfile.write(f"Request Id header = {req_id_header_value}\n".encode('utf-8'))
        self.wfile.write(f"OK from {os.getenv('MOCK_NAME', 'unknown')}\n".encode('utf-8'))
    
    def do_POST(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(f"OK from {os.getenv('MOCK_NAME', 'unknown')}".encode('utf-8'))

if __name__ == "__main__":
    server = HTTPServer(('0.0.0.0', 80), MockHandler)
    server.serve_forever()
