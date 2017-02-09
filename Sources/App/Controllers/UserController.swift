//
//  UserController.swift
//  analysis-server
//
//  Created by Max de Dumast on 24/01/2017.
//
//

import Vapor
import HTTP

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        var specs = try Specs(node: request.json?["specs"])
        
        try user.save()

        specs.user_id = user.id
        try specs.save()
        
        return JSON([
            "user": try user.makeNode(),
            "coin": "/coins/bitcoin.js"
            ])
    }
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        // Specs can be retrieved as such.
        // Because of the absence of any other currency than bitcoin at this
        // stage, there is no need to use them yet. Once there are, here would
        // be a good place to call the decision algorithm to set the coin
        // variable.
        //        let specs = try user.specs().first()

        return try JSON([
            "user": user.makeNode(),
            "coin": "/coins/bitcoin.js"
            ])
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        var user = user
        try user.save()
        return user
    }
    
    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
