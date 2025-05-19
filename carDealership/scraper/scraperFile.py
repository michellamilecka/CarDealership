from concurrent.futures import ThreadPoolExecutor, as_completed
from itertools import takewhile
import os
import requests
import uuid
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

output_file = "carDealership/scraper/scraperResult.json"
photos_dir = "carDealership/scraper/photos/"
page_url = "https://www.bmw.pl/pl/all-models.html"

options = Options()
options.add_argument("--headless=new")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")
options.add_argument("--window-size=1920,1080")

# Initialize driver
driver = webdriver.Chrome(options=options)
driver.get(page_url)

cars = driver.find_elements(By.CLASS_NAME, "allmodelscard.container.responsivegrid[data-counter]")
[os.remove(os.path.join(photos_dir, f)) for f in os.listdir(photos_dir) if os.path.isfile(os.path.join(photos_dir, f))]

wanted_cars = []

for car in cars:
    value = int(car.get_attribute("data-counter"))
    
    if 1600 <= value <= 10400:
        wanted_cars.append(car)


car_links = []

for wanted_car in wanted_cars:
    div = wanted_car.find_element(By.TAG_NAME, "div")
    div_attributes = div.get_attribute("data-card-filter-info")
    data = json.loads(div_attributes)

    car_info = {}
    car_info["price"] = data["price"]

    car_info["fuelType"] = {
        "o" : "benzyna",
        "e" : "elektryczny",
        "d" : "diesel",
        "h" : "hybrydowy"
    }.get(data["fuelType"])

    car_info["bodyType"] = {
        "li" : "limuzyna",
        "to" : "combi",
        "cp" : "coupe",
        "suv" : "suv",
        "caro" : "cabriolet",
        "comp" : "compact"
    }.get(data["category"])

    div_details = div.find_element(By.CLASS_NAME,"cmp-allmodelscarddetail").get_attribute("data-tracking-attributes")
    data_details =json.loads(div_details)
    car_info["name"] = data_details["name"]
    
    car_link = wanted_car.find_element(By.XPATH, './/a[@aria-label="Informacje o pojeździe"]').get_attribute("href")
    car_info["link"] = car_link

    car_links.append(car_info)
    
def process_car(idx, car):

    try:
        driver = webdriver.Chrome(options=options)
        print(f"\n=== [Krok {idx + 1}/{len(car_links)}] ===")
        print(f"Przetwarzam: {car.get('name')} - {car.get('link')}")

        driver.get(car["link"])
        time.sleep(2)
        driver.execute_script("window.scrollBy(0, window.innerHeight * 3);")
        time.sleep(2)

        src_image = None
        color_text = ""
        try:
            img = driver.find_element(
                By.XPATH,
                '//div[contains(@class, "cmp-modelhubcard__image") and contains(@class, "cmp-modelhubcard__image--frontview") and contains(@class, "cmp-modelhubcard__image--disable-hover")]//source[@type="image/webp" and @media="(max-width: 1024px)"]'
            )
            src_image = img.get_attribute("srcset")
            print("✔️ Zdjęcie znalezione w standardowy sposób (srcset).")
        except:
            try:
                wait = WebDriverWait(driver, 15)
                image = wait.until(EC.presence_of_element_located((
                    By.CSS_SELECTOR,
                    "div.view-car.tw-absolute.tw-pin-t.tw-pin-l img"
                )))
                src_image = image.get_attribute("src")
                alt_raw = image.get_attribute("alt") or ""
                color_text = alt_raw.replace("undefined", "").strip()
                print("✔️ Zdjęcie znalezione w <div class='view-car ...'>")
            except:
                print("❌ Nie udało się znaleźć zdjęcia alternatywnie.")

        if src_image:
            try:
                response = requests.get(src_image)
                if response.status_code == 200:
                    image_path = f"{os.path.join(photos_dir, uuid.uuid4().hex)}.png"
                    car["image_path"] = image_path
                    with open(image_path, "wb") as f:
                        f.write(response.content)
                    print("✔️ Zdjęcie zapisane:", image_path)
            except Exception as e:
                print(f"❌ Błąd przy pobieraniu zdjęcia.")

        # Color
        if not color_text:
            try:
                wait = WebDriverWait(driver, 5)
                color_span = wait.until(EC.presence_of_element_located((
                    By.CSS_SELECTOR,
                    "button.cmp-visualizer__model-option--selected + div.cmp-visualizer__option-label span.cmp-visualizer__option-label--multiline"
                )))
                color_text = color_span.get_attribute("textContent").strip()
                print("✔️ Kolor:", color_text)
            except:
                pass
        car["color"] = color_text

        # Technical link
        try:
            technical_link_element = WebDriverWait(driver, 5).until(
                EC.presence_of_element_located((By.XPATH, './/a[@aria-label="Dane techniczne"]'))
            )
            car["technical_link"] = technical_link_element.get_attribute("href")
        except:
            try:
                xpath = (
                    "//div[contains(@class, 'ds2-model-brief--table') and contains(@class, 'large-push-6')]"
                    "//ul/li/a[span[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZĄĆĘŁŃÓŚŹŻ', 'abcdefghijklmnopqrstuvwxyząćęłńóśźż'), 'dane techniczne')]]"
                )
                link = WebDriverWait(driver, 5).until(EC.presence_of_element_located((By.XPATH, xpath)))
                car["technical_link"] = link.get_attribute("href")
            except:
                car["technical_link"] = ""
    except Exception as e:
        print(f"❌ Błąd ogólny.")
    finally:
        driver.quit()
    return car


processed_cars = []

with ThreadPoolExecutor(max_workers=os.cpu_count()) as executor:
    futures = [executor.submit(process_car, idx, car) for idx, car in enumerate(car_links)]

    for future in as_completed(futures):
        processed_cars.append(future.result())

print("✅ Gotowe! Przetworzono:", len(processed_cars))

dozwolone_wartosci = {
  "price" : "cena",
  "fuelType" : "rodzaj_paliwa",
  "bodyType" : "rodzaj_nadwozia",
  "name" : "nazwa",
  "model" : "model",
  "image_path" : "zdjecie",
  "color" : "kolor",
  "Moc w kW (KM)" : "moc_silnika",
  "Skrzynia biegów" : "skrzynia_biegow",
  "Rodzaj napędu" : "rodzaj_napedu",
  "Cylindry" : "liczba_cylindrow",
  "Pojemność w cm³" : "pojemnosc",
  "Przyspieszenie 0-100 km/h w s" : "przyspieszenie",
  "Prędkość maksymalna w km/h" : "predkosc_maksymalna",
  "Pojemność akumulatora w kWh" : "pojemnosc_akumulatora",
  "Prędkość maksymalna na napędzie elektrycznym w km/h" : "predkosc_maksymalna"
}

filtered_cars = []
for car in processed_cars:
    if not car.get("technical_link"):
        continue

    driver.get(car["technical_link"])

    technical_data_facts = driver.find_elements(By.CLASS_NAME, "cmp-technicaldatafact")
    for fact in technical_data_facts:
        key = fact.find_element(By.CSS_SELECTOR, "td.cmp-technicaldatafact__label p.cmp-text__paragraph").text.strip()
        value = fact.find_element(By.CSS_SELECTOR, "td.cmp-technicaldatafact__value p.cmp-text__paragraph").text.strip()
        car[key] = value

    result = " ".join(takewhile(lambda x: "drive" not in x.lower(), car["name"].split()[1:]))
    car["model"] = result

    filtered_car = {
        dozwolone_wartosci[k]: v
        for k, v in car.items()
        if k in dozwolone_wartosci
    }
    filtered_cars.append(filtered_car)


with open(output_file,"w",encoding="utf-8") as f:
    json.dump(filtered_cars, f,ensure_ascii=False, indent=2)