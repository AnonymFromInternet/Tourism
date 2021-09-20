//
//  Result.swift
//  Tourism
//
//  Created by AnonymFromInternet on 19.09.21.
//

import SwiftUI

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    //MARK:- Adapting for Comparable
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    //MARK:- This property shows description when it does not exist in Wikipedia
    var description: String {
        terms?["description"]?.first ?? "No further Information"
    }
}


