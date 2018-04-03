//
//  UINavigationBar+LivePerson.swift
//  SampleSDK30
//
//  Created by David Villacis on 3/12/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//
import UIKit
import LPInfra

extension UINavigationController {
  
  // MARK: - NavigationBar TitleView
  
  /// Will Create a new View for the Navigation Controller - Title Vi
  ///
  /// - Parameter agent: (firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid)
  /// - Returns: Navigation Controller - Title View
  public func setNavigationViewTitle(agent : LPUser ) {
    // Get Navigation Bar Width
    let navigationBarWidth = self.view.frame.width
    // Get NavigationBar Height
    let navigationBarHeight = self.view.frame.height
    // Create new Title View ( X is Back Button Width, so TitleView Starts where Back Button Ends)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: navigationBarWidth, height: navigationBarHeight))
    // Get Agent Image
    let agentImageView = self.getAgentImageView(url: agent.profileImageURL)
    // Get Title for Navigation Bar - Only 23 Characters Long, longer Strings will be trim
    let title = (agent.firstName != nil) ? self.getAttributedTitle(agent.firstName!) : self.getAttributedTitle("LivePerson")
    // Add Agent Image to new TitleView
    view.addSubview(agentImageView)
    // Add Title to new TitleView
    view.addSubview(title)
    // Padding Factor in Relation to the Label Width
    let factor = (agentImageView.frame.width/2)
    // Add Constraints - Title
    self.addAgentNameConstrains(view: title, mainView: view, withFactor: factor)
    // Add Constraints - Agent Image View
    self.addAgentImageViewConstrains(image: agentImageView, relatedTo: title, mainView: view, withFactor: -5.0)
    // Return new Title View
    self.navigationBar.topItem?.titleView = view
  }
  
  /// Will create a new UILabel with Attributed String
  ///
  /// - Parameter title: New Title
  /// - Returns: UILabel with new Attributed String
  public func getAttributedTitle(_ title : String ) -> UILabel{
    // Create Label to Hold new Title
    let view = UILabel()
    // Set Title
    var newTitle = title
    // Create Attributes for Title
    let attributes : [ NSAttributedStringKey : Any ] = [
      .foregroundColor : UIColor.white,
      .font : UIFont(name: "ArialMT", size: 16.0)!
    ]
    // Limit to 15 Chars
    if ( title.length > 23 ){
      // Trim Title
      newTitle = title.subString(0, length: 20)
      // Append Ellipsis
      newTitle.append("...")
    }
    // Create new Title String
    let text = NSAttributedString(string: newTitle, attributes: attributes)
    // Set Title
    view.attributedText = text
    // Return new UILabel
    return view
  }
  
  /// Will add Constrains to ImageView (Button Background Image)
  ///
  /// - Parameters:
  ///   - view: Agent Name Label
  ///   - mainView: Title View
  ///   - factor: Padding (Image | Padding | Label)
  private func addAgentNameConstrains( view: UILabel, mainView : UIView, withFactor factor : CGFloat){
    // Cancel Autoresizing Mask
    view.translatesAutoresizingMaskIntoConstraints = false
    // Set Height Constrains for Title
    let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .lessThanOrEqual, toItem: mainView, attribute: .height, multiplier: 0.8, constant: 0.0)
    // This constraint centers the Label Vertically in the View
    let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    // This constrains center the Label Horizontally in the View
    let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: factor)
    // Activate the constraints
    mainView.addConstraints([centerY, centerX, height])
  }
  
  /// Will create a new UIImageView with Agent Picture
  ///
  /// - Parameter url: Agent Picture URL
  /// - Returns: UIImageView
  private func getAgentImageView(url : String?) -> UIImageView {
    // Create ImageView holder for Agent Picture - Bar Buttons 44 per Apple UI GuideLines
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    // Check if URL was pass
    if (url != nil || url == ""){
      // Set Image with URL
      imageView.setImage(url: url!)
    } else {
      // Set Default Image
      imageView.image = UIImage(named: "DefaultUserIcon")
    }
    // Set Image ContentMode to Scale to Fit
    imageView.contentMode = .scaleAspectFit
    // Set Round Corners for Image View
    imageView.layer.cornerRadius = (imageView.frame.width/2)
    // Mask Borders - This sets the Round Corners
    imageView.layer.masksToBounds = true
    // Return Image View
    return imageView
  }
  
  /// Will add Constrains to ImageView (Button Background Image)
  ///
  /// - Parameters:
  ///   - image: Agent Image View
  ///   - reference: Agent Name Label
  ///   - mainView: Title View
  ///   - factor: Padding Factor (Image | Padding | Label)
  private func addAgentImageViewConstrains( image: UIImageView, relatedTo reference: UILabel, mainView : UIView, withFactor factor : CGFloat){
    // Cancel Autoresizing Mask
    image.translatesAutoresizingMaskIntoConstraints = false
    // This constraint centers the Label Vertically in the View
    let centerY = NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    // Set Height Constrain
    let height = NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.6, constant: 40.0)
    // Set Weidth Constrain
    let width = NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.6, constant: 40.0)
    // Set Leading Constrain
    let leading = NSLayoutConstraint(item: image, attribute: .right, relatedBy: .lessThanOrEqual, toItem: reference, attribute: .left, multiplier: 1.0, constant: factor)
    // Activate the constraints
    mainView.addConstraints([centerY, height, width, leading])
  }
}
