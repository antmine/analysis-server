//
//  Droplet+Setup.swift
//  analysis-server
//
//  Created by Max de Dumast on 03/03/2017.
//
//

import Vapor
import VaporMySQL
import VaporRedis

public func load(_ drop: Droplet) throws {
//    drop.middleware.append(HeaderMiddleware())
//    drop.middleware.insert(CORSMiddleware(), at: 0)
    
    try drop.addProvider(VaporMySQL.Provider.self)
    try drop.addProvider(VaporRedis.Provider(config: drop.config))
    
    drop.preparations.append(User.self)
    drop.preparations.append(Specs.self)
//    drop.preparations.append(RemoveGPUFromSpecs.self)
    
    let userController = UserController(drop)
    drop.get("users", handler: userController.index)
    drop.post("users", handler: userController.create)
    drop.get("users", Int.self, handler: userController.show)
    drop.put("users", Int.self, handler: userController.update)
}
