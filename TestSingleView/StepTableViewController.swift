//
//  StepTableViewController.swift
//  TestSingleView
//
//  Created by footruck on 12/2/15.
//  Copyright © 2015 footruck. All rights reserved.
//

import UIKit

class StepTableViewController: UITableViewController {

    // the list of stages
    var stages : [Stage] {
        get {
            return DataContainerSingleton.getInstance().stages
        }
        set(newValue) {
            DataContainerSingleton.getInstance().stages = newValue
        }
    }

    override func viewWillAppear(animated: Bool) {
        print("table view will appear")
        super.viewWillAppear(animated)
        
        // always refresh table onResume
        self.tableView.reloadData()
    }
    
    /* load the default checklist */
    func loadDefaultStages() -> [Stage] {
        let beforeEngineStart = Stage(name : "BeforeEngineStart", steps: [Step(name:"clear prop"), Step(name:"mixture rich"), Step(name:"quarter throttle")])
        let beforeTaxi = Stage(name : "BeforeTaxi", steps: [Step(name:"ground clearance"), Step(name:"mixture lean")])
        let beforeTakeoff = Stage(name : "BeforeTakeoff", steps: [Step(name: "heading indicator"), Step(name:"mixture rich"), Step(name: "safety on")])
        return [beforeEngineStart, beforeTaxi, beforeTakeoff]
    }
    
    /* load the default or stored checklist */
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedStages = Stage.loadStagesFromStorage() {
            print("loaded from storage")
            stages = savedStages
        } else {
            print("using default")
            stages = loadDefaultStages();
        }
        
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.allowsSelection = true

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    /* pass in the index for the checklist item */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueAddStep") {
            let indexPath = sender as! NSIndexPath
            print("prepare segue \(indexPath.row)")
            let destination = segue.destinationViewController as!ChecklistItemAddViewController
            destination.stageId = indexPath.section
            destination.stepId = indexPath.row
        }
    }
    
    // handler for long tap
    func longTapCaptured(sender : UILongPressGestureRecognizer) {
        
        if (sender.state == .Began) {
            let location = sender.locationInView(self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(location)
            
            if (stages[indexPath!.section].steps[indexPath!.row].isSelected) {
                print("not handling long tap for selected cell")
                return
            }
            
            print("long tap down captured \(indexPath?.section) row \(indexPath?.row)")
            self.performSegueWithIdentifier("segueAddStep", sender: indexPath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return stages.count
    }
    
    /* 
     * returns true if all previous checklist items have been selected;
     * false otherwise
     */
    private func previousCellsSelected(indexPath : NSIndexPath) -> Bool {
        var stageId = indexPath.section
        let stepId = indexPath.row
        if (stepId == 0) {
            if (stageId == 0) {
                return true
            } else {
                var previousStageStepCount = stages[--stageId].steps.count
                while (previousStageStepCount == 0 && stageId > 0) {
                    previousStageStepCount = stages[--stageId].steps.count
                }
                
                if (previousStageStepCount == 0) {
                    // exhaust all the previous steps
                    return true
                }
                
                if (stages[stageId].steps[previousStageStepCount-1].isSelected) {
                    return true
                } else {
                    return false
                }
            }
        } else {
            if (stages[stageId].steps[stepId-1].isSelected) {
                return true
            } else {
                return false
            }
        }
    }
    
    /* proceed if all previous items have been selected */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (!previousCellsSelected(indexPath)) {
            print("all previous cells must be selected first")
            return
        }
        
        print("Trying to select cell \(stages[indexPath.section].steps[indexPath.row].name)")
        stages[indexPath.section].steps[indexPath.row].isSelected = true
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.grayColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages[section].steps.count
    }
    
    /* if any item is re-enabled, all the following items will be as well */
    private func clearFollowingCells(indexPath: NSIndexPath) {
        //self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        
        DataContainerSingleton.getInstance().enableCellsFrom(indexPath.section, stepId: indexPath.row)

        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView,editActionsForRowAtIndexPath indexPath: NSIndexPath) ->[UITableViewRowAction]? {

        let stageId = indexPath.section
        let stepId = indexPath.row
        
        if (stages[stageId].steps[stepId].isSelected) {
            let enableAction = UITableViewRowAction(style: .Default, title: "Enable", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                    self.clearFollowingCells(indexPath)
                }
            )
            enableAction.backgroundColor = UIColor.blueColor()
            return [enableAction]
        } else {
            let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                    self.stages[indexPath.section].steps.removeAtIndex(indexPath.row)
                    Stage.saveStages()
                    // Delete the row from the data source
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            )
            deleteAction.backgroundColor = UIColor.redColor()
            return [deleteAction]
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StepTableViewCell", forIndexPath: indexPath) as! StepTableViewCell

        cell.nameLabel.text = stages[indexPath.section].steps[indexPath.row].name
        cell.stageId = indexPath.section
        cell.stepId = indexPath.row
        
        // set up long tap recognizer
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: "longTapCaptured:")
        longTapRecognizer.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longTapRecognizer)
        
        if (stages[indexPath.section].steps[indexPath.row].isSelected) {
            print("about to be selected \(cell.nameLabel.text)")
            cell.backgroundColor = UIColor.grayColor()
        } else {
            cell.backgroundColor = UIColor.lightTextColor()
        }
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stages[section].name
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
