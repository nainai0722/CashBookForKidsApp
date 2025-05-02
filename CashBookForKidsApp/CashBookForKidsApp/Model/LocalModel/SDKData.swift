//
//  SDKData.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/19.
//
import Foundation

public struct SDKState: Identifiable, Codable {
    public var id: UUID = UUID()
    public var revision: String
    public var version: String
    
    enum CodingKeys: String, CodingKey {
        case revision
        case version
    }
}

public struct SDKData: Identifiable, Codable {
    public var id: UUID = UUID()
    public var identity: String
    public var kind: String
    public var location: String
    public var state: SDKState
    
    enum CodingKeys: String, CodingKey {
        case identity
        case kind
        case location
        case state
    }
    
}

public struct SDKResolved: Codable {
    public var pins: [SDKData]
}

