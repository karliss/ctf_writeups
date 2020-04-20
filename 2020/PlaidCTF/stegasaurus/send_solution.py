#!/bin/env python3
import socket
import requests
import subprocess

HOST = "stegasaurus.pwni.ng"
PORT = 1337
RECV_SIZE = 4096



def main():
    re = socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC, socket.SOCK_STREAM, 0, socket.AI_PASSIVE)
    print(re)

    hashcash = subprocess.check_output(['hashcash', '-b', '25', '-m', '-r', 'stegasaurus'])
    print(hashcash)
    #return

    af, socktype, proto, canonname, sa = re[0]
    conn = socket.create_connection(sa)
    response = conn.recv(RECV_SIZE)
    print(response)
    conn.send(hashcash)
    print(conn.recv(RECV_SIZE))
    
    solution_file = open("solution.lua", "rb")
    conn.sendfile(solution_file)
    conn.shutdown(socket.SHUT_WR)

    i = 0
    while True:
        i += 1
        resp = conn.recv(RECV_SIZE)
        if resp:
            print(resp.decode())
        else:
            break

if __name__ == '__main__':
    main()
