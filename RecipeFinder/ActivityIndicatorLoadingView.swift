//
//  ActivityIndicatorLoadingView.swift
//  RecipeFinder
//
//  Created by Marquis Dennis on 5/8/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class ActivityIndicatorLoadingView: UIView {
	//MARK: Views
	var activityIndicator:UIActivityIndicatorView!
	
	//MARK: Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit(frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit(CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
	}
	
	private func commonInit(frame: CGRect) {
		//activity indicator view background
		self.frame = frame
		backgroundColor = UIColor(red: 107/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.7)
		clipsToBounds = true
		layer.cornerRadius = 10
		hidden = true
		
		let loadingViewHeight = frame.size.height
		let loadingViewWidth = frame.size.width
		
		//activity view indicator
		activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: loadingViewWidth * 0.625, height: loadingViewWidth * 0.625))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .WhiteLarge
		activityIndicator.hidden = true
		activityIndicator.center = CGPoint(x: loadingViewWidth / 2 , y: loadingViewHeight / 2)
		
		addSubview(activityIndicator)
	}
	
	//MARK: ViewMethods
	private func startAnimatingIndicator() {
		activityIndicator.startAnimating()
	}
	
	private func stopAnimatingIndicator() {
		activityIndicator.stopAnimating()
	}
	
	func show() {
		hidden = false
		
		activityIndicator.hidden = false
		startAnimatingIndicator()
	}
	
	func hide() {
		hidden = true
		stopAnimatingIndicator()
	}
}
