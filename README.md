# 🚒 sg-brandweer | FiveM Brandweer Script  

Een realistisch en uitgebreid brandweer script voor **ESX** en **QB-Core**. Dit script voegt interactieve brandweerslangen, ademlucht en een dynamisch brand- en incidentensysteem toe.  

## 📌 Kenmerken  
✅ **Brandweercommandant menu** via ox_target  
✅ **Kleedkamer systeem** met outfits per rang  
✅ **Voertuigbeheer** via NPC en ox_target interacties  
✅ **Brandweerslangen** (fysiek aansluiten op hydranten & voertuigen)  
✅ **Waterdruk & waterverbruik systeem**  
✅ **Ademlucht & rookinhalatie effecten**  
✅ **Realistisch brandsysteem** (vuur verspreidt zich)  

## 📦 Installatie  
### 1️⃣ Vereisten  
- [ox_lib](https://github.com/overextended/ox_lib)  
- [ox_target](https://github.com/overextended/ox_target)  
- [ox_inventory](https://github.com/overextended/ox_inventory)  
- Een werkende **ESX** of **QB-Core** server  

### 2️⃣ Installatie  
Plaats het script in je `resources` map:  
```sh
cd resources
git clone https://github.com/jouwrepo/sg-brandweer.git

of download en pak het uit.

3️⃣ Server configuratie
Voeg het script toe aan je server.cfg:

ensure sg-brandweer

Pas instellingen aan in config.lua om voertuigen, waterdruk en andere parameters te bepalen.

🎮 Gebruik
👨‍🚒 Brandweerslangen
Pak een slang uit een brandweerwagen via ox_target
Sluit de slang aan op een hydrant of voertuig
Gebruik de nozzle om water te spuiten
🔥 Brandbestrijding
Vuur kan zich uitbreiden als het niet snel wordt geblust
Sommige branden vereisen een specifieke aanpak (olie, elektrisch, gaslekken)
👷‍♂️ Ademlucht & Veiligheid
Rook veroorzaakt hoesten en vermindert zichtbaarheid
Gebruik een ademluchtapparaat bij zware rookontwikkeling
⚙️ Configuratie
In config.lua kun je:

Voertuigen instellen die slangen kunnen opslaan
Waterdrukwaarden en slangenlengte aanpassen
Brandweer outfits en rangen configureren
❓ Ondersteuning
Voor vragen of bugs, open een issue of vraag in Discord.
