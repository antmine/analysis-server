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
    var user_id: Node? = nil
    static var entity = "specs"
    var exists: Bool = false
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.hashsPerSecond = try node.extract("hashs_per_second")
        self.GPU = try node.extract("gpu")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
                "id": id,
                "hashs_per_second" : hashsPerSecond,
                "gpu": GPU,
                "user_id": user_id
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
        //
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
        })
    }
    
}
