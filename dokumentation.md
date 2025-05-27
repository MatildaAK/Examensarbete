Vi försöker att följa samma struktur och användar sett som vi har gjorti QH detta för att vi ska kunna koppla ihop React med denna databas.

# Frontend och Backend

## Innehåll

1. [Starta projekt](#startproject)
2. [Databaskoppling](#databaskoppling)
3. [Controllers](#controllers)
4. [Modul](#modul)
5. [Routes](#routes)
6. [Komponenter](#komponenter)
7. [BCrypt](#bcrypt)
8. [CLSX](#clsx)
9. [Mockdata](#mockdata)
10. [Seeds](#seeds)
11. [UseState](#useState)
12. [UseEffect](#useEffect)

Vi har byggt Våran React applikation baserat på det vi har i Elixir / Phoenix LiveView, så den består av olika komponenter som vi kan använda på flera ställen. Detta för att försöka minska duppliceringen av kod. Vi använder oss av komponenter och props för att vi har arbetat med tidigare och tycker det är smidit och när projektet växer är det smidigt att kunna använda samma kod på flera ställen ett att behöva dupplicera koden på alla ställen där det används.


## Starta projekt

Se hur i [README](/README.md)

starta servern:

**Frontend:**
```
npm run dev
```

**Backend:**
```elixir
iex -S mix phx.server

Windows:

iex.bat -S mix phx.server
```

## Databaskoppling
vi har återanvänt samma kodbas så långt det går i backenden, så att den är den samma här som i QH för att skapa tenant, användare samt hotell i terminalen.

För att frontenden ska kunna kommunicera med backenden har vi definierat vår *Base_url* i Config.ts, vilket gör det enkelt att hantera URL:en centralt.

Backenden är byggd med Elixir och Phoenix LiveView, och använder PostgreSQL som databas, där kopplingen är förkonfigurerad i projektet. För att möjliggöra kommunikation mellan frontend och backend från olika domäner har vi lagt till CORSPlug i endpoint.ex. Där har vi specificerat tillåtna origins, metoder och headers. CORSPlug är en dependency som vi har lagt till i mix.exs.

```elixir
  plug CORSPlug,
    origin: ["http://localhost:5173"],
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    headers: ["Authorization", "Content-Type", "X-Tenant"]
```

## Controllers
I vår backend, som är byggd med Elixir och webbramverket Phoenix, använder vi så kallade controllers för att hantera HTTP-förfrågningar till vår API. Varje controller ansvarar för en resurstyp – i det här fallet [hotellrum](/examen_backend/lib/examen_backend_web/controllers/hotel_room_controller.ex). En controller består av olika funktioner, en för varje typ av operation: hämta alla, hämta en, skapa, uppdatera och ta bort.

Kort om varje funktion:
* *index/2:* Hämtar alla hotellrum från databasen och returnerar dem som JSON.

* *show/2:* Hämtar ett enskilt hotellrum baserat på ID.

* *create/2:* Skapar ett nytt hotellrum med de data som skickas in i förfrågan.

* *update/2:* Uppdaterar ett befintligt hotellrum.

* *delete/2:* Tar bort ett hotellrum.

Viktiga koncept:
* *conn:* Objektet som håller information om HTTP-förfrågan och används för att skicka svar tillbaka till klienten.

* *conn.assigns.tenant:* Eftersom vi arbetar med flera kunder (tenants) använder vi detta värde för att peka till rätt databasnamnsutrymme i PostgreSQL. Det möjliggör så kallad "multi-tenancy", där varje kund har sina egna data.

* *with:* En kontrollstruktur i Elixir som används för att hantera kedjor av operationer som kan misslyckas. Om något går fel, avbryts kedjan automatiskt.

* *Serializers.serialize_hotel_room/1:* En hjälpfunktion som omvandlar våra Elixir-datastrukturer till ett JSON-format som passar frontendens behov.

Exempel:

När frontend skickar en POST-förfrågan med data för att skapa ett nytt hotellrum, hamnar den i create/2. Den använder Hotels.create_hotel_room/2 för att skapa hotellet i databasen, och returnerar sedan svaret som JSON.

## Modul
En modul i Elixir är ett sätt att gruppera relaterade funktioner under ett gemensamt namn. Det är ungefär som en klass i objektorienterade språk – fast utan objekt och tillstånd. Istället för att skapa instanser, definierar man funktioner direkt i modulen som man sedan kan anropa.
Moduler definieras med defmodule och kompileras till Erlang-moduler under huven, vilket gör dem mycket snabba och kompatibla med BEAM (Erlang Virtual Machine).

Moduler används för att:
* Strukturera kod i logiska enheter (t.ex. [User](/examen_backend/lib/examen_backend/users.ex), [Hotel](/examen_backend/lib/examen_backend/hotels.ex))
* Återanvända funktioner
* Undvika namnkonflikter
* Separera ansvar i större system

```elixir
defmodule ExamenBackend.Users do
  import Ecto.Query, warn: false

  alias ExamenBackend.Repo

  def list_users(opts) do
    Repo.all(User, opts)
  end
end
```
* *defmodule* definierar ett nytt namnrum.
* *def* definierar en publikt synlig funktion inom modulen.
* Funktioner är stateless och alltid pure om du inte anropar IO eller externa system.

Exempel på hur vi hämtar en funktion från modulen:
```elixir
 alias ExamenBackend.Users

 users = Users.list_users([prefix: conn.assigns.tenant])
```

Till skillnad från objektorienterade språk, där tillstånd ofta kapslas in i objekt, är moduler i Elixir rena funktionella containers. De innehåller inga instanser, ingen intern state, och varje funktionsanrop är oberoende.

Detta gör att:
* Kod blir enklare att testa
* Det inte finns några sidoeffekter utan explicita IO-anrop
* All tillståndshantering sker via immutabla datastrukturer

## Routes
I vår Phoenix-applikation definierar vi så kallade routes (vägar) som kopplar inkommande HTTP-förfrågningar till specifika funktioner i våra controllers. Dessa routes beskriver vilket URL-mönster och HTTP-metod som ska anropa vilken funktion.

Här är ett exempel för hotell:

```elixir
  get "/hotels", HotelController, :index # Hämtar alla Hotell
  get "/hotels/:id", HotelController, :show # Hämtar ett specifikt hotell
  post "/hotels", HotelController, :create # Skapar ett nytt hotell
  put "/hotels/:id", HotelController, :update # Uppdatera ett hotell
  delete "/hotels/:id", HotelController, :delete # Radera ett hotell
```

#### Vad betyder detta?
* get, post, put, delete är HTTP-metoder som talar om vad för slags operation det handlar om:

  * *get:* hämta data

  * *post:* skapa ny data

  * *put:* uppdatera existerande data

  * *delete:* ta bort data

* URL-strängen är den sökväg som klienten (t.ex. frontend) anropar. :id betyder att det är en dynamisk parameter, t.ex. /hotel/1.

* HotelController är den modul (controller) som tar hand om förfrågan.

* :index, :show, etc. är namnet på den funktion i controllern som körs när vägen matchas.

#### Varför är detta viktigt?
Dessa routes fungerar som kopplingen mellan frontend och backend. När t.ex. frontend skickar en förfrågan till /hotel/5 med metoden GET, vet Phoenix att det är HotelController.show/2 som ska anropas – och den funktionen ansvarar för att hämta hotell med ID 5 och returnera det som JSON.

## Komponenter

Komponenter vi skapat.
* [Back](#back)
* [Button](#button)
* [Input](#input)
* [Card_link](#card_link)
* [Container](#container)
* [List](#list)
* [Modal](#modal)
* [Select](#select)
* [Table](#table)

Vi har skapat komponenterna för att vi använder dem på flera olika ställen och filer. Detta för att minimera så mycket som möjligt av dupplicering av kod.

#### *Back*
I komponenten *[Back](/examen_frontend/src/components/core/Back.tsx)* använder vi useNavigate från React Router för att gå tillbaka till föregående sida med hjälp av *navigate(-1)*, vilket tar användaren till den senaste besökta sidan. 

Om man inte skickar med något innehåll (via children) visas standardtexten *Tillbaka* tillsammans med pilikonen. Om man däremot skickar med egen text, visas den istället. Det gör knappen flexibel – antingen visar den den angivna texten eller faller tillbaka till standardvärdet.

Hur det kan användas:

```typescript
<Back>Tillbaka till Lista</Back> // visar: <- Tillbaka till lista

<Back />  // visar: <- Tillbaka
```

#### *Button*
I *[Button](/examen_frontend/src/components/core/Button.tsx)* -komponenten har vi just nu stöd för två visuella varianter: "primary" och "danger", vilket gör det enkelt att använda olika typer av knappar beroende på syftet – exempelvis en vanlig bekräftelseknapp eller en knapp för att radera något. Variationen styrs av prop:en variant, där "primary" ger en standardknapp med vår sekundära färg och "danger" ger en varningstonad knapp med annan styling. Det går också att styra knappens storlek genom prop:en size, där alternativet "small" gör knappen mer kompakt. I övrigt innehåller komponenten props för type, som kan vara "button" eller "submit" beroende på användningsområde, samt onClick som hanterar klickhändelser. Innehållet i knappen styrs av children, vilket gör det möjligt att dynamiskt visa text eller andra komponenter.

Knappens logik är uppdelad i två olika return-block beroende på vilken variant som används, vilket gör koden tydlig men också lätt att bygga ut. Vill man lägga till ytterligare varianter eller storlekar är det enkelt att göra genom att uppdatera typerna i props och lägga till motsvarande villkor i komponenten. På så sätt är Button-komponenten både återanvändbar och flexibel, samtidigt som den säkerställer en konsekvent design i hela applikationen.

Knapp komponent för primary:

```typescript
{variant === "primary" ? (
  <button
    className={`${
      size === "small" ? "min-h-12 min-w-32" : "min-h-12 w-80"
    } h-fit 'cursor-pointer rounded bg-secondaryColor hover:bg-hoverOnButton border-hoverOnButton text-textColor font-semibold text-base hover:text-lg font-poppins shadow-custom'`}
    type={type}
    onClick={onClick}
  >
    {children}
  </button>
)}
```

Hur det kan användas:

```typescript
<Button
  onClick={() => setModalOpen(true)}
  type="button"
  variant="primary"
  size="small"
>
  Nytt hotel
</Button>
```

#### *Input*
I *[Input](/examen_frontend/src/components/core/Input.tsx)*-komponenten har vi valt att definiera stöd för flera olika type-värden redan från början, även om vi inte använder alla för tillfället. Detta är gjort för att komponenten ska vara flexibel och framtidssäker – exempelvis kan vi i ett senare skede behöva inmatning för datum, tid eller checkboxar, vilket redan är förberett i props-definitionen. Komponentens struktur bygger på en switch-liknande logik där olika renderingar sker beroende på vilket type-värde som skickas in. För "checkbox", "radio" samt vissa textbaserade fält som "text", "email" och "password" används olika markup och layout för att säkerställa rätt visning och tillgänglighet. Övriga typer, såsom "date" och "time", fångas upp av ett generellt fallback-block vilket gör att vi inte behöver duplicera kod för varje ny inputtyp. Denna lösning gör komponenten enkel att vidareutveckla utan att man behöver ändra dess grundstruktur.  

Hur det kan användas:

```typescript
<Input
  type="text"
  label="Namn"
  value={name}
  onChange={(e) => setName(e.target.value)}
  name="name"
/>
```

#### *Card_link*
I komponenten *[Card_link](/examen_frontend/src/components/core/Card_Link.tsx)* använder vi clsx, ett hjälpbibliotek som förenklar hanteringen av CSS-klasser genom att kombinera dem dynamiskt. Syftet här är att göra det möjligt att utöka eller modifiera komponentens styling genom att skicka in egna klasser via prop:en className. Det gör komponenten mer flexibel och återanvändbar i olika sammanhang där olika visuella behov kan finnas.

Exempel:

```typescript
const LinkCard: React.FC<LinkCardProps> = ({ to, className, children, ...rest }) => {
  return (
    <Link
      to={to}
      className={clsx("group text-center no-underline", className)}
      {...rest}
    >
      <div className="bg-secondaryColor text-textColor relative flex flex-col cursor-pointer items-center justify-center gap-y-2 rounded-lg py-6 text-center text-lg font-bold uppercase group-hover:bg-hoverOnButton">
        {children}
      </div>
    </Link>
  );
};
```

Hur det kan användas:

```typescript
  <LinkCard to="/users"><FontAwesomeIcon icon={faUsers} className="h-16 w-16" /> <span className="ml-4">användare</span> </LinkCard>
```

#### *Container*
Vi har skapat en egen komponent vid namn *[Container](/examen_frontend/src/components/core/Container.tsx)* som används på alla sidor i applikationen för att säkerställa en enhetlig layout och konsekvent styling. Genom att använda denna komponent kan vi centralt styra marginaler, bredd och padding, vilket förenklar både underhåll och framtida designändringar – det räcker att uppdatera Container-komponenten för att ändringen ska slå igenom överallt. Vi använder även clsx för att kombinera standardklasser med valfri extra styling som kan skickas in via prop:en className. Detta gör att komponenten är flexibel och kan anpassas vid behov utan att förlora sin grundläggande struktur

#### *List*
I vår komponent *[List](/examen_frontend/src/components/core/List.tsx)* itererar vi över en array av objekt och renderar dem dynamiskt. Varje objekt innehåller en title och ett value, där title visas som en rubrik och value renderas via en prop som heter renderSlot. Denna prop är en funktion som ger oss full kontroll över hur varje rad i listan ska presenteras. Det gör komponenten mycket flexibel och återanvändbar, eftersom vi kan anpassa både innehållet och utseendet beroende på kontext. Vi har byggt komponenten för att enkelt kunna lägga till eller ta bort datafält, vilket förenklar underhåll och utbyggnad i takt med att projektet växer. Genom att använda denna lista på flera sidor kan vi hålla presentationen konsekvent, samtidigt som vi slipper duplicera kod. 

Hur det kan användas:

```typescript
<List
  items={[
    { title: "Namn", value: user.name },
    { title: "Användar namn", value: user.user_name },
    { title: "Email", value: user.email },
  ]}
  renderSlot={(item) => item.value}
/>
```

#### *Modal*
Vi har skapat en egen *[Modal](/examen_frontend/src/components/core/Modal.tsx)*-komponent för att säkerställa ett enhetligt utseende och beteende för alla modaler i applikationen. För att modalen inte ska begränsas av den komponenthierarki som normalt uppstår i React har vi använt createPortal från Reacts DOM-API. Genom att rendera modalen direkt i document.body säkerställer vi att den visas ovanpå allt annat innehåll och inte påverkas av lokala styles eller positionering från andra komponenter i strukturen. Detta gör modalen mer robust och oberoende, vilket är särskilt viktigt i större applikationer där layouten kan variera kraftigt. Utöver detta hanterar komponenten även stängning vid klick utanför modalen och vid tryck på Escape-tangenten, vilket förbättrar användarupplevelsen och tillgängligheten.

Hur det kan användas:

```typescript
<Modal
  isOpen={roomModalOpen}
  onClose={() => setRoomModalOpen(false)}
  title={"Skapa Hotellrum"}
>
  <HotelRoomForm<NewHotelRoom>
    onSubmit={handleCreateHotelRoom}
    submitText="Skapa hotelrum" 
    initialHotelId={hotels.id.toString()}         
  />
</Modal>
```

[CreatePortal](https://react.dev/reference/react-dom/createPortal)

#### *Select*
Denna komponent är skapad för att underlätta framtida användning av flera *[Select](/examen_frontend/src/components/core/Select.tsx)*-fält i applikationen. För att göra det enkelt att hantera och rendera dessa fält har vi skapat en återanvändbar komponent som mappar igenom alla alternativ från databasen och presenterar dem i ett select-fält. På så sätt kan vi lätt lägga till eller ändra alternativ i framtiden utan att behöva duplicera kod eller logik. Komponentens flexibilitet gör att den kan användas på flera sidor där användaren behöver välja mellan fördefinierade alternativ, samtidigt som vi centraliserar hanteringen av de olika valen. 

Hur det kan användas:

```typescript
<Select
    name="hotel_id"
    label="Hotell"
    value={hotelId}
    onChange={(e) => setHotelId(e.target.value)}
    options={hotels.map((hotel) => ({
      label: hotel.name,
      value: hotel.id.toString(),
    }))}
/>
```

#### *Table*
I komponenten [Table](/examen_frontend/src/components/core/Table.tsx) har vi skapat en flexibel och återanvändbar lösning för att rendera tabeller med valfritt antal kolumner och rader. Komponentens design gör det enkelt att hantera dynamiska data och visar varje rad med en specifik uppsättning av kolumner definierade via columns-propen. För varje kolumn tillhandahåller vi ett render-fält som anger hur datan ska presenteras, vilket gör det möjligt att visa olika typer av innehåll i varje cell, beroende på den specifika kolumnen.

Tabellen stödjer även valfria åtgärder (actions) som kan kopplas till varje rad, exempelvis knappar för att redigera eller ta bort data. Om åtgärder anges kommer en extra kolumn att läggas till i slutet av varje rad, och varje åtgärd renderas genom en render-funktion, vilket gör det möjligt att anpassa dem efter behov.

För varje rad kan man även lägga till en onRowClick-prop för att definiera en funktion som ska köras när en rad klickas, vilket ger en interaktiv upplevelse. Denna funktion får hela raden som argument, vilket gör det möjligt att arbeta med den specifika datan i raden. För att unikt identifiera varje rad använder vi rowId-prop:en, som definierar hur varje rad ska identifieras. Om inget specifikt id anges används standardvärdet som hämtar id-fältet från varje objekt i items-arrayen.

Denna komponent gör det enkelt att skapa och visa tabeller med olika datatyper och funktioner, samtidigt som den bibehåller en hög grad av flexibilitet och återanvändbarhet i projektet.

Hur det kan användas:

```typescript
<Table
  items={users}
  columns={[
    {
      label: "Namn",
      render: (user) => user.name,
    },
    {
      label: "Email",
      render: (user) => user.email,
    },
  ]}
  onRowClick={(user) =>{
    setSelectedUser(user);
    navigate(`/users/${user.id}`, { state: { user } });
  }}
/>
```

## BCrypt
Vi använder oss av biblioteket bcrypt_elixir i backend för att hasha användarnas lösenord.
Detta bibliotek är en wrapper runt C-biblioteket bcrypt, vilket innebär att det kräver en fungerande C-kompilator för att kunna byggas.

#### Krav för Windows

Eftersom bcrypt_elixir kompileras från källkod behöver du ha rätt utvecklingsverktyg installerade. På Windows krävs delar från Visual Studio Installer:

1. Installera [Visual Studio Build Tool](https://visualstudio.microsoft.com/downloads/) 
2. Under installationen, välj:
      * Desktop development with C++ 
        * C++ CMake tools for Windows
        * Windows 11 eller 10 SDK (välj den senaste)
        * MSVC v143 - VS 2022 C++

Vanligt felmeddelande vid användande av bcrypt

När vi först körde mix deps.get och försökte kompilera projektet stötte vi på följande fel:
```bash
could not compile dependency :bcrypt_elixir, "mix compile" failed. Errors may have been logged above. You can recompile this dependency with "mix deps.compile

(Mix) Could not compile with "nmake" (exit status: 2). One option is to install a recent version of Visual C++ Build Tools either manually or using Chocolatey - choco install VisualCppBuildTools.
```

För att lösa detta krävs att Visual Studio-kompilatorn är korrekt laddad i din terminalsession.
* Öppna Command Prompt (cmd)
* Kör kommandot nedan för att ladda rätt miljövariabler (anpassa sökvägen om din installation ligger någon annanstans):
```mathematica
cmd /K "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"
```

I samma terminal, kör:
```bash
mix deps.clean bcrypt_elixir --all 
mix deps.get 
mix deps.compile 
```

Efter detta bör bcrypt_elixir kompileras korrekt.

## CLSX
I några av våra komponenter använder vi biblioteket clsx, som är ett lättviktsbibliotek för att kombinera och hantera CSS-klasser. clsx gör det enklare att conditionellt lägga till eller ta bort CSS-klasser baserat på logik, vilket minskar risken för att behöva hantera komplexa if-satser eller strängmanipuleringar för att bygga klasser manuellt.

En vanlig användning är att kombinera standardklasser med dynamiska klasser, beroende på komponentens tillstånd eller props. Till exempel kan man använda clsx för att dynamiskt lägga till en klass baserat på om en komponent är aktiv, om den har en viss storlek, eller om en annan prop är satt. På så sätt blir koden mer läsbar och lättare att underhålla.

Exempel:

```typescript
<button
      className={clsx(
        "btn",
        isActive && "btn-active",
        isDisabled && "btn-disabled"
      )}
>
  Click me
</button>
```

Här kommer clsx att lägga till klassen btn-active om isActive är true, och btn-disabled om isDisabled är true. Det gör det möjligt att kombinera klasser på ett renare och mer hanterbart sätt.

Eller som i vårat fall att vi använder det för att kunna lägga till styling där det behövs (se [Card_link](#card_link)). 

## Mockdata
För att underlätta testning och utveckling använder applikationen en mockad lista med 1000 hotell, som definieras i filen [mockdata.ts](/examen_frontend/src/Hotels/MockData/mockdata.ts). Detta innebär att hotellen inte är verkliga, utan används som platsfyllnad så att utvecklarna kan testa applikationen utan att manuellt behöva lägga till varje enskilt hotell. 
Vi har valt att använda mockdata för att snabbt kunna återge realistiska scenarion med större datamängder, samt underlätta arbetet när det kommer till komponenttestning.

## Seeds

Detta avsnitt förklarar hur man importerar hotellrum till databasen för ett specifikt tenant-schema och hur man enkelt kan ta bort dem vid behov. Ett seed-script läser in, transformerar och lagrar data — i detta fall hotellrum — i rätt tenant-schema i databasen. Denna data kan ses som en typ av mockad data, används för att snabbt och effektivt fylla systemet med realistiska testvärden.
Vi har valt att lägga in detta för både 10 och 1000 rum. Se [notes](/elixir_phoenix/notes.md) för alla kommandon.

Projektet är organiserat enligt följande:
```sh
priv/
  repo/
    seeds/
      add_prefix_to_10_rooms.exs        # Skript för att lägga in rum i databasen
      delete_seeded_rooms.exs          # Skript för att radera rummen
    data/
      10_rooms_seed.json                   # Ursprunglig JSON med rum
      10_hotel_rooms_with_prefix.json     # Uppdaterad JSON med tenant-prefix
```

1. Lägg till prefix_tenant till rummen

Kör detta för att uppdatera 10_room_seed.json och skapa en ny fil med tenant-id (ex: 100006):


```elixir
body = File.read!("priv/repo/data/10_rooms_seed.json")
rooms = Jason.decode(body)

updated_rooms =
  Enum.map(rooms, fn room ->
    Map.put(room, "prefix_tenant", "100006")
  end)

File.write!("priv/repo/data/10_hotel_rooms_with_prefix.json", Jason.encode!(updated_rooms, pretty: true))
```
Obs: ändra "100006" till det schema du vill importera till.

2. Lägg in rummen i databasen

Kör detta kommando för att lägga in alla rum i tenant-schemat 100006:

```sh
mix run priv/repo/seeds/add_prefix_to_10_rooms.exs
```
Det här läser in filen 10_hotel_rooms_with_prefix.json och lägger in rummen i rätt schema baserat på prefix_tenant.

3. Radera alla rum från ett schema
Om du vill ta bort alla rum från t.ex. schema 100006, kör:

```sh
mix run priv/repo/seeds/delete_seeded_rooms.exs
```
Detta kör Repo.delete_all/2 för HotelRoom i rätt schema.

## UseState
*useState* är en React-hook som gör det möjligt för funktionella komponenter att hantera tillstånd, vilket gör dem mer dynamiska och interaktiva. När *useState* används tillsammans med TypeScript får du dessutom typsäkerhet, vilket förbättrar utvecklarupplevelsen genom att fel upptäcks tidigt i utvecklingsprocessen.

Hooken returnerar två saker: ett tillståndsvärde och en funktion för att uppdatera detta värde. Här är ett exempel på hur det kan se ut:
```ts
  const [hotels, setHotels] = useState<Hotel[]>([]);
```

För att uppdatera tillståndet anropar du funktionen som returnerats av hooken – i detta fall *setHotels*. Denna funktion kan antingen ta ett nytt värde direkt, eller en funktion som i sin tur tar emot det tidigare tillståndet och returnerar det uppdaterade värdet. Detta är särskilt användbart när den nya tillståndsvarianten beror på den tidigare.
```ts
  const handleCreateHotel = async (newHotel: NewHotel) => {
    const created = await createHotel(newHotel.name);
    setHotels((prev) => [...prev, created]);
    setModalOpen(false);
  };
```
Tänk på att tillståndsuppdateringar i React är asynkrona och kan batchas för bättre prestanda. Det innebär att ett tillståndsvärde inte nödvändigtvis är uppdaterat direkt efter att du anropat *setState*. Därför är det rekommenderat att använda funktionsformen för att uppdatera tillstånd när det nya värdet beror på det tidigare.

## UseEffect
Hooken useEffect i React används för att utföra sidoeffekter i funktionskomponenter. Den ersätter de traditionella livscykelmetoderna componentDidMount, componentDidUpdate och componentWillUnmount som tidigare användes i klasskomponenter. Detta förändrades i och med introduktionen av Hooks i React version 16.8.

* Det första argumentet till useEffect är en funktion där du placerar koden för din sidoeffekt.
* Det andra argumentet är en valfri array med beroenden. Effekten körs varje gång något av dessa beroenden förändras. Om du inte anger några beroenden, körs effekten efter varje render.

Ett vanligt användningsområde för useEffect är att hämta data när en komponent monteras. Genom att skicka en tom array [] som beroendelista körs effekten endast en gång, direkt efter den första renderingen – vilket motsvarar componentDidMount i klasskomponenter.

Här är ett exempel där data hämtas från en API-endpoint:
```ts
  useEffect(() => {
    const token = localStorage.getItem("token");
    const tenant = localStorage.getItem("tenant");

    fetch(`${BASE_URL}/hotels`, {
      headers: {
        Authorization: `Bearer ${token}`,
        "X-Tenant": `${tenant}`,
      },
    })
      .then((res) => res.json())
      .then((data) => setHotels(data.data));
  }, []);
```

UseEffect kan även användas som en clean-up-funktion. 
Den utför då rensningsuppgifter som att avsluta prenumerationer på händelser eller avbryta asynkrona uppgifter.
```ts
useEffect(() => {
  const subscription = someObservable.subscribe();
  
  return () => {
    subscription.unsubscribe();
  };
}, []);
```