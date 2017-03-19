//
//  User.swift
//  analysis-server
//
//  Created by Max de Dumast on 24/01/2017.
//
//

import Vapor
import Fluent
import Foundation

final class User: Model {
    var id: Node?
    var exists: Bool = false

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        exists = false
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id
            ])
    }
    
    func specs() throws -> Children<Specs> {
        return children()
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("users", closure: { users in
            users.id()
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}

// MARK: Re-usable Date Formatter

private var _df: DateFormatter?
private var dateFormatter: DateFormatter {
    if let df = _df {
        return df
    }
    
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    _df = df
    return df
}
