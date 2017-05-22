//
//  HeaderMiddleware.swift
//  analysis-server
//
//  Created by Max de Dumast on 27/01/2017.
//
//

import HTTP

final class HeaderMiddleware : Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)

        response.headers["Access-Control-Allow-Origin"] = request.headers["Origin"] ?? "*";
        response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, Origin, Content-Type, Accept"
        response.headers["Access-Control-Allow-Methods"] = "POST, GET, PUT, OPTIONS, DELETE, PATCH"
        return response
    }
}
