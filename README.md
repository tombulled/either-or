# either-or
Flutter "Either Or" clone

## Build
### Linux
```sh
flutter build linux
./build/linux/x64/release/bundle/eitheror
```

### Web
```sh
flutter build web
python3 -m http.server --directory build/web/
```

### Docker
```sh
docker build -t either-or .
docker run -p 8080:8080 either-or
```