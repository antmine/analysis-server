//
//  SpecsController.swift
//  analysis-server
//
//  Created by Max de Dumast on 24/01/2017.
//
//

import Vapor
import HTTP

final class SpecsController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Specs.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var specs = try request.specs()
        try specs.save()
        return specs
    }
    
    func show(request: Request, specs: Specs) throws -> ResponseRepresentable {
        return try JSON(["specs": specs.makeNode()])
    }
    
    func delete(request: Request, specs: Specs) throws -> ResponseRepresentable {
        try specs.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Specs.query().delete()
        return JSON([])
    }
    
    func update(request: Request, specs: Specs) throws -> ResponseRepresentable {
        var specs = specs
        try specs.save()
        return specs
    }
    
    func replace(request: Request, specs: Specs) throws -> ResponseRepresentable {
        try specs.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Specs> {
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
    func specs() throws -> Specs {
        guard let json = json else { throw Abort.badRequest }
        return try Specs(node: json)
    }
}
