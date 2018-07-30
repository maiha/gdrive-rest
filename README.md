# gdrive-rest

A handy REST server for google drive.

## features
This provides REST access to your gdrive files
- without credentials
- with rich interfaces

### Why without credentials?

I have many apps that handle gdrive files,
I am tired of setting the same credentials file on all of them.

So I decided to divide them into one service and use it as micro service.
In this case it is convenient to omit the authentication
because it is closed on the safe network or the same host.

### Rich interfaces

- fetch a spreadsheet as TSV, CSV, ...

When you want first worksheet in spreadsheet(`1234abcd...`),
no needs to program it. Just do it with REST.

```
curl localhost:8080/sheets/1234abcd.../0.csv    # number means sheet index
curl localhost:8080/sheets/1234abcd.../foo.csv  # string means sheet name
```

## setup

Put `config.json` like this.
```json
{
  "client_id": "1234abcd....apps.googleusercontent.com",
  "client_secret": "1234xyz...",
  "scope": [
    "https://www.googleapis.com/auth/drive",
    "https://spreadsheets.google.com/feeds/"
  ],
  "refresh_token": "zzz1234..."
}
```

Test oauth2 with `config.json`.

```console
docker run -v $(PWD):/mnt -e GDRIVE_CONFIG=/mnt/config.json maiha/gdrive-rest auth
```

## run

```console
docker run -v $(PWD):/mnt -e GDRIVE_CONFIG=/mnt/config.json --net host maiha/gdrive-rest httpd -p 8080
```

## Environments

```
GDRIVE_CONFIG string (default: 'config.json')
GDRIVE_BIND   string (default: 'localhost')
GDRIVE_PORT   int    (default: 8080)
GDRIVE_DUMP_ERRORS bool (default: nil)
```

## API

- [x] GET /sheets/:key.{html,json,txt}
- [x] GET /sheets/:key/:num.{html,json,csv,tsv,txt}
- [ ] PUT /sheets/:key/:num.csv
- [x] GET /sheets/:key/:name.{html,json,csv,tsv,txt}
- [ ] PUT /sheets/:key/:name.csv

## Contributing

1. Fork it ( https://github.com/maiha/gdrive-rest/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
