//
//  UserModel.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 11/12/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import Foundation
class UserModel: NSObject {
    
    var FirstName: String?
    var LastName: String?
    var userAge: String?
    var email: String?
    var friends: Dictionary<String, FriendsModel>?
    
    
}
