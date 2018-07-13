//
//  Note.swift
//  Notes
//
//  Created by Michal Černý on 13/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import Foundation

struct Note {
    let id: Int
    let title: String
    
    init?(json: [String: Any]) {
        id = json["id"] as! Int
        title = json["title"] as! String
    }
}
