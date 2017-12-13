//
//  clcell.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 12/10/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class clcell: UITableViewCell {

    let cDB = challengeDB()
    var challengeID: String?
    var createorID: String?
    var challengerID: String?
    
    @IBOutlet weak var challenge: UILabel!
    @IBOutlet weak var complete: UIButton!
    
   
    
    
}
