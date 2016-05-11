//
//  UIBlackBox.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/11/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

func getUIAlertController(withActvityTitle alertTitle:String, message:String, actionTitle:String) -> UIAlertController {
	let alert = UIAlertController(title: "Internet Connection Required", message: "An Internet connection will be required to search for recipes.", preferredStyle: .Alert)
	let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
	alert.addAction(action)
	return alert
}