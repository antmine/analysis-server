## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## Routes

- `POST /users`
	```{"specs":{
		"hashs_per_second": <int>
		"gpu": <string>
	}```
	Returns `user_id` and path to coin algorithm:
	``` { "user_id": <int>, "coin": <string> ```

- `GET /users/:id`

Returns: ``` { "user_id": <int>, "coin": <string> ```