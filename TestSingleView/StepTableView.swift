//
//  StepTableView.swift
//  TestSingleView
//
//  Created by Kevin on 12/19/15.
//  Copyright © 2015 KT. All rights reserved.
//

import UIKit

class StepTableView: UITableView {

    override func reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        print("reloading from table view")
        for indexPath in indexPaths {
            let stages = DataContainerSingleton.getInstance().stages
            if (stages[indexPath.section].steps[indexPath.row].isSelected) {
                print("trying to select cell")
                selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
            }
        }

    }
}
