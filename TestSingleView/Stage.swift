//
//  Stage.swift
//  TestSingleView
//
//  Created by footruck on 12/4/15.
//  Copyright © 2015 footruck. All rights reserved.
//

import UIKit

struct StageKey {
    static let stageName = "stageName"
    static let stageSteps = "stageSteps"
}

// model for MVC
class Stage : NSObject, NSCoding {
    let name : String
    var steps : [Step]
    
    static let DocumentDirectory = NSFileManager().URLsForDirectory(
        .DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("stages")
    
    init(name : String, steps : [Step]) {
        self.name = name
        self.steps = steps
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(StageKey.stageName) as! String
        let steps = aDecoder.decodeObjectForKey(StageKey.stageSteps) as! [Step]
        self.init(name: name, steps: steps)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: StageKey.stageName)
        aCoder.encodeObject(steps, forKey: StageKey.stageSteps)
    }
    
    // load the list content from the storage
    static func loadStagesFromStorage() -> [Stage]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Stage.ArchiveURL.path!) as? [Stage]
    }
    
    // save the list content to storage
    static func saveStages() {
        let saveDone = NSKeyedArchiver.archiveRootObject(DataContainerSingleton.getInstance().stages, toFile: Stage.ArchiveURL.path!)
        if !saveDone {
            print("failed to save")
        } else {
            print("done saving")
        }
    }
}
