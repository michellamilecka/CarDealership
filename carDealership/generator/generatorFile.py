from faker import Faker
from random import randint, choice
from datetime import datetime, timedelta
import json

output_klienci = "carDealership/generator/clients.json"
output_samochody = "carDealership/generator/cars.json"
output_transakcje = "carDealership/generator/transactions.json"
scraper_output = "carDealership/scraper/scraperResult.json"


fake = Faker("pl_PL")
klienci = []
samochody = []
silniki = []
transakcje = []

silniki_elektryczne = []
silniki_spalinowe = []

dane_samochodow = {
    "name",
    "model",
    "color",
    "acceleration",
    "transmission",
    "topSpeed",
    "gasMileage",
    "mileage",
    "drivetrainType",
    "description",
    "bodyType",
    "price",
    "imagePath",
    "vinNumber",
    "productionYear",
    "condition"
}

dane_silnikow_elektrycznych = {
    "power",
    "fuelType",
    "capacity"
}

dane_silnikow_spalinowych = {
    "power",
    "fuelType",
    "displacement",
    "cylindersNumber",
}

def filtrowanie_samochodow(sciezka_do_pliku):
    with open(sciezka_do_pliku, "r", encoding="utf-8") as f:
        data = json.load(f)

    elektryczne = []
    spalinowe = []
    hybrydowe = []

    must_have_spalinowy = {"cylindersNumber", "displacement"}
    must_have_elektryczny = {"capacity"}
    must_have_hybrydowy = {"capacity", "cylindersNumber", "displacement"}

    spalinowe = [ obj for obj in data if must_have_spalinowy.issubset(obj) and must_have_elektryczny.isdisjoint(obj)]
    elektryczne = [ obj for obj in data if must_have_elektryczny.issubset(obj) and must_have_spalinowy.isdisjoint(obj)]
    hybrydowe = [ obj for obj in data if must_have_hybrydowy.issubset(obj)]


    return elektryczne, spalinowe, hybrydowe

elektryczne, spalinowe, hybrydowe = filtrowanie_samochodow(scraper_output)

print(json.dumps(elektryczne, indent=2, ensure_ascii=False))

print(f"Elektryczne: {len(elektryczne)}")
print(f"Spalinowe: {len(spalinowe)}")
print(f"Hybrydowe: {len(hybrydowe)}")



#     @Column(name="zuzycie_paliwa")
#     double gasMileage;

#     @Column(name="opis")
#     String description;
#  
#     @Column(name="numer_vin", unique = true)
#     String vinNumber;

#     @Column(name="rok_produkcji")
#     int productionYear;

#     @Column(name="przebieg_km")
#     int mileage;

#     @Column(name="stan")
#     @Enumerated(EnumType.STRING)
#     CarCondition condition;
# transakcje 
# public class Transaction {

#     @Column(name="data_transakcji")
#     LocalDateTime transactionDate;

#     @Column(name="kwota")
#     BigDecimal totalAmount;

#     @Column(name="sposob_platnosci")
#     @Enumerated(EnumType.STRING)
#     PaymentMethod paymentMethod;

#     @Column(name="czy_zarejestrowany")
#     boolean registered;

#     @Column(name="czy_ubezpieczony")
#     boolean insured;

#     @ManyToOne(fetch = FetchType.EAGER)
#     @JoinColumn(name="client_id")
#     Client client;

#     @OneToOne(fetch = FetchType.EAGER)
#     @JoinColumn(name="car_id")
#     Car car;

# }
#KLIENT INDYWIDUALNY
# {
#   "type": "individual",
#   "name": "John",
#   "surname": "Doe",
#   "pesel": "12345678901",
#   "address": "123 Main Street, New York",
#   "phoneNumber": "+1 123 456 789",
#   "email": "john.doe@example.com"
# }

# KLIENT FIRMA
# {
#   "type": "corporate",
#   "companyName": "Tech Solutions LLC",
#   "nip": "1234567890",
#   "address": "456 Business Avenue, Chicago",
#   "phoneNumber": "+1 987 654 321",
#   "email": "contact@techsolutions.com"
# }


# def generowanie_klienta_indywidualnego():
#     type = "individual"
#     name = fake.first_name()
#     surname = fake.last_name()
#     pesel = fake.random_int(min=100000000, max=999999999)
#     address = fake.address().replace("\n", ", ")
#     phoneNumber = fake.phone_number()
#     email = fake.email()
#     return {
#         "type": type,
#         "name": name,
#         "surname": surname,
#         "pesel": pesel,
#         "address": address,
#         "phoneNumber": phoneNumber,
#         "email": email
#     }
    

# def generowanie_klienta_firmowego():
#     type = "corporate"
#     companyName = fake.company()
#     nip = fake.random_int(min=100000000, max=999999999)
#     address = fake.address().replace("\n", ", ")
#     phoneNumber = fake.phone_number()
#     email = fake.email()

#     return {
#         "type": type,
#         "companyName": companyName,
#         "nip": nip,
#         "address": address,
#         "phoneNumber": phoneNumber,
#         "email": email
#     }




# for i in range(100):
#     if i % 2 == 0:
#         klienci.append(generowanie_klienta_indywidualnego())
#     else:
#         klienci.append(generowanie_klienta_firmowego())

# with open(output_klienci, "w", encoding="utf-8") as f:
#     json.dump(klienci, f, ensure_ascii=False, indent=2)