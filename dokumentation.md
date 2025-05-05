Skriv vad och hur vi gör 

vi försöker att följa samma struktur och användar sett som vi har gjorti QH detta för att vi ska kunna koppla ihop React med denna databas.

# Frontend och Backend

## Innehåll

1. [Starta projekt](#startproject)
2. [Databaskoppling](#databaskoppling)
3. [Komponenter](#komponenter)
4. [CLSX](#clsx)

Vi har byggt Våran React applikation baserat på det vi har i Elixir / Phoenix LiveView, så den består av olika komponenter som vi kan använda på flera ställen. Detta för att försöka minska duppliceringen av kod. Vi använder oss av komponenter och props för att vi har arbetat med tidigare och tycker det är smidit och när projektet väker är det smidigt att kunna använda samma kod på flera ställen ett att behöva dupplicera koden på alla ställen där det används.


### Starta projekt

Se hur i [README](/examen_frontend/README.md)

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

### Databaskoppling
vi har återanvänt samma kodbas så långt det går i backenden, så att den är den samma här som i QH för att skapa tenant, användare samt hotell i terminalen.

För att frontenden ska kunna kommunicera med backenden har vi definierat vår *Base_url* i Config.ts, vilket gör det enkelt att hantera URL:en centralt.

Backenden är byggd med Elixir och Phoenix LiveView, och använder PostgreSQL som databas, där kopplingen är förkonfigurerad i projektet. För att möjliggöra kommunikation mellan frontend och backend från olika domäner har vi lagt till CORSPlug i endpoint.ex. Där har vi specificerat tillåtna origins, metoder och headers. CORSPlug är en dependency som vi har lagt till i mix.exs.

### Komponenter

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

### CLSX
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