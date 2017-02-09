## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## ⛔️ Routes

|Method| Endpoint | JSON post | JSON return |
|--|--|--|
| POST | /users | ```{"specs":{	"hashs_per_second": <int>" 	gpu": <string>}```| ``` { "user_id": <int>, "coin": <string> }```
| GET|/users| N/A | ``` { "user_id": <int>, "coin": <string> }```

## ⚙️ Configuration

Configure MySQL by creating a file `Config/Secrets/mysql.json`:

```json
{
    "host": "",
    "user": "",
    "password": "",
    "database": "",
    "port": "",
    "encoding": "utf8"
}
```
