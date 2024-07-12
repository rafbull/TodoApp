//
//  FileCachable.swift
//  
//
//  Created by Rafis on 10.07.2024.
//

import Foundation

public protocol FileCachable {
    var id: String { get }
    var json: Any { get }
    var csv: Any { get }
    
    static func parse(json: Any) -> Self?
    static func parse(csv: Any) -> Self?
}
