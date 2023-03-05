import socket
host = "alfheim.pw" # "mc.hypixel.net"
port = 25565
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(10)
sock.connect((host, port))
sock.send(bytes([0x00, 0x00]) + bytes([len(host)]) + bytes(host, 'utf-8') + bytes([port >> 8, port & 0xFF]))
#sock.send(b"\xFE\x01")
print(sock.recv(1024))
sock.close()
