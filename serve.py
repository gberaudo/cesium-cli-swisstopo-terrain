import sys
import socketserver
from http.server import SimpleHTTPRequestHandler

class MyHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        print(self.path)
        if '.terrain' in self.path:
            self.send_header('Content-Encoding', 'gzip')
        SimpleHTTPRequestHandler.end_headers(self)

if __name__ == '__main__':
    PORT = 8000

    with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
        print("Listening on port {}. Press Ctrl+C to stop.".format(PORT))
        httpd.serve_forever()
