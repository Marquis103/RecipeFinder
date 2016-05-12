//
//  AddFavoriteButton.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/11/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class AddFavoriteButton: UIButton {

	override var selected: Bool {
		didSet {
			if selected {
				setImage(UIImage(named: "remove_favorite"), forState: .Normal)
			} else {
				setImage(UIImage(named: "add_favorite"), forState: .Normal)
			}
		}
	}
	
	func configureButton() {
		layer.cornerRadius = 8.0
	}
}
