//
//  FriendsModel.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 10/30/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class FriendsModel {
    var status: String?
    var first: String?
    var last: String?
    var friendID: String?
    var yourID: String?
    var friendProfilePic: String?
    
    func clear(){
        status = nil
        first = nil
        last = nil
        friendID = nil
        yourID = nil
        friendProfilePic = nil
    }
}
