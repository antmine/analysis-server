//
//  UserController.swift
//  analysis-server
//
//  Created by Max de Dumast on 24/01/2017.
//
//

import Foundation
import Vapor
import HTTP

final class UserController {
    let drop: Droplet
    
    init(_ drop: Droplet) {
        self.drop = drop
    }
    
    // Thread pool to send algorithm updates to
    let queue: DispatchQueue = DispatchQueue(
        label: "com.antmine.analysis-server.sql",
        qos: .background
    )
    
    /// Gets algorithm from cache, making sure to update it if it is older
    /// than one week
    ///
    /// - Parameter userID: id of user to update
    /// - Returns: path of algorithm to be used by user
    /// - Throws: 404 if user does not exist
    private func getAlgorithm(for userID: Int) throws -> String {
        var currency: String?
        let cacheForUser = try drop.cache.get("\(userID)")?.array
        
        if let currencyFromRedis = cacheForUser?[1].string,
            let lastUpdatedString = cacheForUser?[0].string {
            
            currency = currencyFromRedis
            
            if let lastUpdated = dateFormatter.date(from: lastUpdatedString) {
                if lastUpdated.addingTimeInterval(-60 * 60 * 24 * 7) > lastUpdated {
                    // Run algorithm again
                    print("Updating algorithm")
                    currency = "/coins/bitcoin.js"
                    try drop.cache.set("\(userID)",
                        [
                            Node(dateFormatter.string(from: Date())),
                            Node(currency ?? "/coins/bitcoin.js")
                        ])
                }
            }
        } else {
            // Nothing found in Redis
            guard var _ = try User.query().filter("id", userID).first() else {
                // User does not exist
                throw Abort.notFound
            }
            currency = "/coins/bitcoin.js"
            try drop.cache.set("\(userID)",
                [
                    Node(dateFormatter.string(from: Date())),
                    Node(currency ?? "/coins/bitcoin.js")
                ])
        }
        
        return currency!
        // Force unwrapped because we want an error
        // if it is nil, this should not happen
    }
    
    /// Same as above but returns a Node
    ///
    /// - Parameter userID: user's id
    /// - Returns: path of algorithm to use as Node
    /// - Throws: 404 if user does not exist
    private func getAlgorithm(for userID: Int) throws -> Node {
        let algorithm: String = try getAlgorithm(for: userID)
        return Node(algorithm)
    }
    
    // MARK: Public methods
    
    /// Lists all users
    ///
    /// - Parameter request: vapor request
    /// - Returns: A list of all users
    /// - Throws:
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }
    
    /// Creates a user
    /// POST /users
    ///
    /// - Parameter request:
    /// - Returns: path of algorithm to use
    /// - Throws:
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        var specs = try Specs(node: request.json?["specs"])
        
        try user.save()
        
        specs.user_id = user.id
        try specs.save()
        
        return JSON([
            "userID": user.id ?? -1,
            "coin": try getAlgorithm(for: (user.id?.int)!)
            ])
    }
    
    /// GET /users/:id
    ///
    /// - Parameters:
    ///   - request:
    ///   - userID: user's id
    /// - Returns: path of algorithm to use
    /// - Throws: if user is not found
    func show(request: Request, userID: Int) throws -> ResponseRepresentable {
        let algorithmPath: String = try "Public" + getAlgorithm(for: userID)
        let algorithm = try String(contentsOfFile: drop.workDir + algorithmPath)
        return algorithm
    }
    
    /// Updates a users battery and/or tab status
    ///
    /// PUT /users/:id
    ///
    /// Only call that requires to update SQL everytime.
    /// Might be possible once algorithms are in place to avoid this by knowing
    /// that a battery status change can trigger a predefined replacement algorithm
    /// depending on current algorithm in use
    ///
    /// - Parameters:
    ///   - request: vapor request
    ///   - userID: user's id
    /// - Returns: path of algorithm to use
    /// - Throws: 
    func update(request: Request, userID: Int) throws -> ResponseRepresentable {
        guard let user = try User.query().filter("id", userID).first(),
            var specs = try user.specs().first() else {
                throw Abort.notFound
        }
        
        if let battery = request.json?["specs"]?["battery"]?.bool {
            specs.battery = battery
        }
        
        if let tabActive = request.json?["specs"]?["tabActive"]?.bool {
            specs.tabActive = tabActive
        }
        
        specs.user_id = user.id
        try specs.save()
        
        let algorithmPath: String = try "Public" + getAlgorithm(for: userID)
        let algorithm = try String(contentsOfFile: drop.workDir + algorithmPath)
        return algorithm
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
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
