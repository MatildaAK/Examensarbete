Vi har byggt Våran React applikation baserat på det vi har i Elixir / Phoenix LiveView, så den består av olika komponenter som vi kan använda på flera ställen. Detta för att försöka minska duppliceringen av kod. 


## Starta projekt

För att starta projektet behöver man i **frontend**:

```
npm i
```

```
npm run dev
```

## För att starta projektet behöver man i **Backend**:

```
mix deps.get
```

Har du inte *rätt* inställning när det kommer till **"nmake"** behöver du om du sitter på en Windows:

1. Öppna en Windocs comand promp
2.  cmd /K "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"  (Detta ska vara din väg till rätt fil)
3. 
```
mix deps.clean bcrypt_elixir --all 

mix deps.get 

mix deps.compile 
```