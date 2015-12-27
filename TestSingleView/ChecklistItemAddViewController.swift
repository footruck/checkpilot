//
//  ChecklistItemAddViewController.swift
//  TestSingleView
//
//  Created by footruck on 12/13/15.
//  Copyright © 2015 footruck. All rights reserved.
//

import UIKit

class ChecklistItemAddViewController: UIViewController {

    @IBOutlet weak var newStep: UITextField!
    
    var stageId = 0
    var stepId = 0

    @IBAction func addAfterClicked(sender: UIButton) {
        let dc = DataContainerSingleton.getInstance()

        print("add AFTER for stage \(stageId) and step \(stepId) and text \(newStep.text)")
        dc.stages[stageId].steps.insert(Step(name:newStep.text!), atIndex: stepId + 1)
        
        Stage.saveStages()
        dismissSelf()
    }
    
    @IBAction func addBeforeClicked(sender: UIButton) {
        let dc = DataContainerSingleton.getInstance()

        print("add BEFORE for stage \(stageId) and step \(stepId) and text \(newStep.text)")
        
        dc.stages[stageId].steps.insert(Step(name:newStep.text!), atIndex: stepId)

        Stage.saveStages()
        dismissSelf()
    }
    
    private func dismissSelf() {
        print("dismiss add dialog")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
