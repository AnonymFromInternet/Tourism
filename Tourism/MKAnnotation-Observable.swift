//
//  MKAnnotation-Observable.swift
//  Tourism
//
//  Created by AnonymFromInternet on 19.09.21.
//

import SwiftUI

import MapKit
//MARK:- Struct for work with TextField in Edit Struct. These are wrapped properties for saving title and subtitle
extension MKPointAnnotation: ObservableObject {

    public var wrappedTitle: String {
        
        get {
            self.title ?? "Unknown value"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        
        get {
            self.subtitle ?? "Unknown value"
        }
        
        set {
            subtitle = newValue
        }
    }
}
