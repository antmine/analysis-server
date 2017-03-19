//
//  Specs.swift
//  analysis-server
//
//  Created by Max de Dumast on 31/01/2017.
//
//

import Vapor
import Fluent
import Foundation

final class Specs: Model {
    var id: Node?
    var hashsPerSecond: Int
    var GPU: String
    var battery: Bool
    var tabActive: Bool
    var uri: String
    var webGLLanguage: String
    var webGLVersion: String
    var webGLVendor: String
    var webGLRenderer: String
    var cores: Int
    
    var user_id: Node? = nil
    
    static var entity = "specs"
    var exists: Bool = false
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.hashsPerSecond = try node.extract("hashs_per_second")
        self.GPU = try node.extract("gpu")
        self.battery = try node.extract("battery")
        self.tabActive = try node.extract("tabActive")
        self.uri = try node.extract("uri")
        self.webGLVendor = try node.extract("webGLVendor")
        self.webGLVersion = try node.extract("webGLVersion")
        self.webGLLanguage = try node.extract("webGLLanguage")
        self.webGLRenderer = try node.extract("webGLRenderer")
        self.cores = try node.extract("cores")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "hashs_per_second" : hashsPerSecond,
            "gpu": GPU,
            "user_id": user_id,
            "battery": battery,
            "tabActive": tabActive,
            "uri": uri,
            "webGLVendor" : webGLVendor,
            "webGLVersion": webGLVersion,
            "webGLLanguage": webGLLanguage,
            "webGLRenderer": webGLRenderer,
            "cores": cores,
            ])
    }
    
    func user() throws -> Parent<User> {
        return try parent(user_id)
    }
}

extension Specs: Preparation {
    /**
     The revert method should undo any actions
     caused by the prepare method.
     
     If this is impossible, the `PreparationError.revertImpossible`
     error should be thrown.
     */
    public static func revert(_ database: Database) throws {
        try database.delete("specs")
    }
    
    /**
     The prepare method should call any methods
     it needs on the database to prepare.
     */
    public static func prepare(_ database: Database) throws {
        try database.create("specs", closure: { (specs) in
            specs.id()
            specs.int("hashs_per_second")
            specs.string("gpu")
            specs.parent(User.self, optional: true, unique: false, default: nil)
            specs.bool("battery")
            specs.bool("tabActive")
            specs.string("uri")
            specs.string("webGLVendor")
            specs.string("webGLVersion")
            specs.string("webGLLanguage")
            specs.string("webGLRenderer")
            specs.int("cores")
        })
    }
    
}
