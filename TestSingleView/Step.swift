//
//  Step.swift
//  TestSingleView
//
//  Created by footruck on 12/16/15.
//  Copyright © 2015 footruck. All rights reserved.
//

import UIKit

struct StepKey {
    static let IS_SELECTED = "isSelected"
    static let NAME = "name"
}

class Step : NSObject, NSCoding {
    var isSelected : Bool
    var name : String
    
    init(name: String) {
        self.isSelected = false
        self.name = name
    }
    
    init(isSelected: Bool, name: String) {
        self.isSelected = isSelected
        self.name = name
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let isSelected = aDecoder.decodeBoolForKey(StepKey.IS_SELECTED)
        let name = aDecoder.decodeObjectForKey(StepKey.NAME) as! String
        self.init(isSelected : isSelected, name : name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(isSelected, forKey: StepKey.IS_SELECTED)
        aCoder.encodeObject(name, forKey: StepKey.NAME)
    }
}
