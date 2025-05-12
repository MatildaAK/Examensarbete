1. Börja med att klona ned projektet
2. Öppna terminalen och gå till rätt "path"
    * För React - Elixir - Phoenix LiveView: cd examen_frontend och cd examen_backend
    * För Elixir och Phoenix LiveView: cd elixir_phoenix. Fortsätt sedan från steget **Starta projektet i backend**
3. Installera projektets dependencies
4. Starta server


## Starta projekt i **Frontend**

För att starta projektet behöver man i **frontend**:

1. Installera dependencies
```bash
npm i
```
2. Starta servern
```bash
npm run dev
```

## Starta projektet i **Backend**:
1. Installera dependencies 

```elixir
mix deps.get
```

2. Skapa databas koppling med:
```elixir
mix ecto.create
```

3. setup och Migrera databasen
```elixir
mix setup.tenant 100002

mix migrate.tenant 100002
```

4. starta Phoenix endpoint:
```elixir
iex -S mix phx.server
```
Eller om du har en Windows:
```elixir
iex.bat -S mix phx.server
```

Skulle du få problem med NMake, se [BCrypt](/dokumentation.md)