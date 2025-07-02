# Aplikacja Mobilna Zarządzania Salonem Samochodowym 🚗📱

Aplikacja mobilna stworzona we Flutterze, służąca do zarządzania salonem samochodowym. Projekt obejmuje zarówno frontend (Flutter), jak i backend (Spring Boot) oraz bazę danych (PostgreSQL). System wspiera rejestrowanie transakcji, zarządzanie klientami i pojazdami, oraz integruje się z zewnętrznymi źródłami danych.

---

## ✨ Kluczowe funkcje

- Dodawanie transakcji sprzedaży samochodów
- Obsługa klientów indywidualnych i firmowych
- Przegląd i wybór samochodów z oferty
- Możliwość zakupu nowego/używanego auta
- Wybór metody płatności (gotówka, karta kredytowa, przelew)
- Walidacja formularzy i czytelne komunikaty błędów
- Komunikacja z backendem REST API (Spring Boot)
- Przechowywanie danych i zdjęć w bazie PostgreSQL

---

## 🧰 Technologie

- **Flutter** – aplikacja mobilna (frontend)
- **Spring Boot** – backend i logika biznesowa
- **PostgreSQL** – baza danych
- **Scraper** – pobieranie danych z zewnętrznego źródła (BMW)
- **Generator danych** – testowe dane dla klienta i pojazdów
- **GitHub + Discord** – współpraca zespołu
  
## 👥 Współtwórcy

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/michellamilecka">
        <img src="https://avatars.githubusercontent.com/michellamilecka" width="80px;" alt="Jan Kowalski"/>
        <br /><sub><b>Michella Miłecka</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/zamrokjulita">
        <img src="https://avatars.githubusercontent.com/zamrokjulita" width="80px;" alt="Anna Nowak"/>
        <br /><sub><b>Julita Zamroczyńska</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/alicjalendzioszek">
        <img src="https://avatars.githubusercontent.com/alicjalendzioszek" width="80px;" alt="Piotr Wiśniewski"/>
        <br /><sub><b>Alicja Lendzioszek</b></sub>
      </a>
    </td>
  </tr>
</table>
---

## 📸 Przykładowe ekrany


---

## 🚀 Jak uruchomić?

### Wymagania

- Flutter SDK
- Emulator lub fizyczne urządzenie mobilne
- Backend API (np. lokalny Spring Boot)

### Krok po kroku

```bash
git clone https://github.com/twoj-login/amzss-app.git
cd amzss-app
flutter pub get
flutter run
