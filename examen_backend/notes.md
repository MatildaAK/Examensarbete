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