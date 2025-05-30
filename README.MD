1. Börja med att klona ned projektet
2. Öppna terminalen och gå till rätt "path"
    * För React - Elixir - Phoenix: cd examen_frontend och cd examen_backend
    * För Elixir och Phoenix LiveView: cd elixir_phoenix. Fortsätt sedan från steget **Starta projektet i backend**
3. Installera projektets dependencies
4. Starta server
5. Skapa användare i backend terminalen (när du är i iex)
6. Logga in
7. Lägg till rum i databasen (mockdata)

## Starta projekt i **Frontend** (React):

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

(Alla *mix*-kommandon körs i en separat terminal där ingen server körs)

1. Installera beroenden: 

```elixir
mix deps.get
```

2. Skapa databaskoppling:
```elixir
mix ecto.create
```

3. Setup och Migrera databasen:

(*Tenant namnet behöver vara sex siffror*)

```elixir
mix setup.tenant 100006

mix migrate.tenant 100006
```

4. Starta Phoenix-endpoint:
```elixir
iex -S mix phx.server
```
Eller om du har en Windows:
```elixir
iex.bat -S mix phx.server
```

5. Skapa användare:
```elixir
ExamenBackend.Users.create_user(%{user_name: "Lisa", email: "info@test.com", name: "Lisa", password: "Password123!"}, [prefix: "100006"])
```

6. Logga in med användarnamn@prefix och lösenord

7. Lägg till rum till databasen (mockdata)

Har prefix: *100006* som default, så lägger man till en till tenant eller valt ett annat namn, ändra även i *add_prefix_to_10_rooms.exs*, *add_prefix_to_1000_rooms.exs* och *delete_seeded_rooms.exs* som ligger i mappen priv/repo/seeds.

10 rum:
```elixir
mix run priv/repo/seeds/add_prefix_to_10_rooms.exs
``` 
```elixir
mix run priv/repo/seeds/seeds_10.exs
```
1000 rum:
```elixir
mix run priv/repo/seeds/add_prefix_to_1000_rooms.exs
``` 
```elixir
mix run priv/repo/seeds/seeds_1000.exs
```

Radera alla rum:
```elixir
mix run priv/repo/seeds/delete_seeded_rooms.exs
```

Skulle man få problem med NMake, se [BCrypt](/dokumentation.md)
