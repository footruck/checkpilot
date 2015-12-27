//
//  DataContainerSingleton.swift
//  TestSingleView
//
//  Created by footruck on 12/13/15.
//  Copyright © 2015 footruck. All rights reserved.
//

import UIKit

class DataContainerSingleton {
    private var _stages = [Stage]()
    // the inner data
    var stages : [Stage] {
        get {
            return _stages
        }
        set(newValue) {
            _stages = newValue
        }
    }

    private static let _instance = DataContainerSingleton()
    static func getInstance() -> DataContainerSingleton {
        return _instance
    }
    
    func enableCellsFrom(stageId : Int, stepId : Int) {
        let stageCount = stages.count

        for (var i = stageId; i < stageCount; ++i) {
            let steps = stages[i].steps
            let stepCount = steps.count

            for (var j = (i == stageId ? stepId : 0); j < stepCount; ++j) {
                if (steps[j].isSelected) {
                    steps[j].isSelected = false
                } else {
                    print("returning at stage \(i) step \(j)")
                    return
                }
            }
        }
    }
}
