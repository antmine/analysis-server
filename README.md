## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## ⛔️ Routes

|Method| Endpoint | JSON post | Return |
|---|---|---|---|
| POST | /users | ```{"specs": { "gpu": <string>, "hashs_per_second": <int>, "cores": <int>, "webGLRenderer": <string>, "webGLVendor": <string>, "webGLVersion": <string>, "webGLLanguage": <string>, "uri": <string>, "tabActive": <bool>, "battery": <bool> }}```| JSON:``` { "user": <int>, "coin": <string> }```|
| | | | Note: Path to algorithm will be returned here|
| GET|/users/:id| N/A | Javascript file containing algorithm|
| PUT|/users/:id| `{"specs":{"tabActive": <bool>, "battery": <bool> }}` | Javascript file containing algorithm|
| | | Note: tabActive or battery can be sent idenpently from one another |	|


## ⚙️ Configuration

Configure MySQL by creating a file `Config/Secrets/mysql.json`:

```json
{
    "host": "",
    "user": "",
    "password": "",
    "database": "",
    "port": ,
    "encoding": "utf8"
}
```
Configure REDIS by creating a file `Config/Secrets/redis.json`:
```json
{
	"address": "",
	"port":
}
```
Neither of these files will be pushed to remotes to prevent adding secrets to the versioning server.
