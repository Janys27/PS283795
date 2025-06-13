import socket 


def scan_ports(ip, start_port, end_port):

    #iterujemy po portach
    for port in range(start_port, end_port + 1): #+1 zeby bylo wlacznie
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #af_inet- ipv4, sock_stream- tcp
        sock.settimeout(0.5)  #zeby nie czekac w nieskonczonosc

        result = sock.connect_ex((ip, port))  #jesli wyrzyca 0 to znaczy, ze jest dobrze, connect_ex nie przerwie
        #jesli bedzie blad
        if result == 0:
            print(f"Port {port} jest OTWARTY")
        sock.close()

#pobieranie wymaganych danych, od razu robimy zeby sie nie uruchomilo przy imporcie w przyszlosci
if __name__ == "__main__":
    target_ip = input("Podaj adres IP serwera do skanowania: ")
    start = int(input("Podaj startowy port: "))
    end = int(input("Podaj koncowy port: "))

    scan_ports(target_ip, start, end)
