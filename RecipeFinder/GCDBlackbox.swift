//
//  GCDBlackbox.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/9/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

//MARK: Global queue variables
var GlobalMainQueue: dispatch_queue_t {
	return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
	return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}


var GlobalUserInitiatedQueue: dispatch_queue_t {
	return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
	return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
	return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}


//MARK: Global gcd functions
func performUIUpdatesOnMain(updates: () -> Void) {
	dispatch_async(GlobalMainQueue) { 
		updates()
	}
}

func performImageNetworkOperations(operations: () -> Void) {
	dispatch_async(GlobalUserInitiatedQueue) { 
		operations()
	}
}
