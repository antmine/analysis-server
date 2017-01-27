import Vapor

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.middleware.append(HeaderMiddleware())

drop.post("users") { request in
    return JSON(
        [
            "id": "fer33-3fvc-dac7-f5c2",
            "coin": "/coins/bitcoin.js"
        ]
    )
}

drop.get("users", String.self) { request, userId in
    if userId == "fer33-3fvc-dac7-f5c2" {
        return "Success"
    } else {
        throw Abort.custom(status: .badRequest, message: "User not found")
    }
}

drop.run()
