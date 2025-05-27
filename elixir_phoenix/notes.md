# Tenant setup and migration

## Setup tenant 
This mix task will setup the customer schema
```elixir
mix setup.tenant 100002
```
## Migration & rollback tenant
This mix task will run the migrations on a customer schema
```elixir
mix migrate.tenant 100002
```
This mix task will rollback the latest migration on a customer schema
```elixir
mix rollback.tenant 100002
```

### Add user to tenant
```elixir
ExamenBackend.Users.create_user(%{user_name: "Lisa", email: "info@test.com", name: "Lisa", password: "Password123!"}, [prefix: "100002"])
```

### Add hotel to tenant
```elixir
ExamenBackend.Hotels.create_hotel(%{name: "Radison Green"}, [prefix: "100002"])
```

### Add mockdata from seed file
Have prefix: "100006" in add_prefix_to_10_rooms, add_prefix_to_1000_rooms and delete_seeded_rooms

#### 10 rooms
```bash
mix run priv/repo/seeds/add_prefix_to_10_rooms.exs
``` 
```bash
mix run priv/repo/seeds/seeds_10.exs
```

#### 1000 rooms
```bash
mix run priv/repo/seeds/add_prefix_to_1000_rooms.exs
``` 
```bash
mix run priv/repo/seeds/seeds_1000.exs
```

### Delete all rooms from tenant
```bash
mix run priv/repo/seeds/delete_seeded_rooms.exs
```