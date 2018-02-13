//
//  Toast.swift
//  LivePerson
//
//  Created by David Villacis on 1/2/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
import UIKit

class Toast: UIView {
  
  /// Will return Status Bar Height
  private var statusBarHeight : CGFloat {
    get {
      return UIApplication.shared.statusBarFrame.height
    }
  }
  /// Will return a UIView that handles multiple Devices
  private var viewForToast : UIView {
    get {
      // Check if Device is iPhone X
      if Device.IS_IPHONE_X {
        // Init Toast View for iPhone X
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 110.0))
      } else if Device.IS_IPAD {
        // Create new Toast for iPads
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150.0))
      } else {
        // Create new Toast for Other iPhones
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80.0))
      }
    }
  }
  
  /**
   * Will Create a Custom View for Local Notification
   * @message - text to show on the Toast
   **/
  public func getView( message : String ) -> UIView {
    // Create new View for Toast Message
    let view = self.viewForToast
    // Set Toast View - Frame Origin (top-left) - You can change the CGPoint(x: 0, y: NEW_VALUE) to give the Toast a TopPadding
    view.frame.origin = CGPoint(x: 0, y: 0)
    // Set Toast View Background Color
    view.backgroundColor = UIColor(red:0.04, green:0.00, blue:0.00, alpha:0.8)
    // Create new Label
    let label = UILabel()
    // Add Constrains between the Label and the View
    self.addViewConstrains(view: label, relatedTo: view)
    // Set Label Origin
    label.frame.origin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y)
    // Create new Text for Notification
    let notificationText = NSAttributedString(string:message, attributes: [
      // Set Text Color
      NSAttributedStringKey.foregroundColor: UIColor.white,
      // Set Text Font & Size
      NSAttributedStringKey.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 15.0)!,
      ]
    )
    // Set Notification Text
    label.attributedText = notificationText
    // Set Text AlignmentsendToMessaging
    label.textAlignment = .center
    // Set Line Break
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    // Set Number of Lines
    label.numberOfLines = 3
    // Add Label to View
    view.addSubview(label)
    // Enable Touch
    view.isUserInteractionEnabled = true
    // Add Tag to View
    view.tag = 66666
    // Return View
    return view
  }
  
  /// Will add Constrains to ImageView (Button Background Image)
  private func addViewConstrains( view: UIView, relatedTo reference: UIView){
    // Cancel Autoresizing Mask
    view.translatesAutoresizingMaskIntoConstraints = false
    // This constraint centers the imageView Horizontally in the View
    let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: reference, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    // You should also set some constraint about the height of the imageView
    // or attach it to some item placed right under it in the view such as the
    // BottomMargin of the parent view or another object's Top attribute.
    // Will hold Constrains for View Height
    let height : NSLayoutConstraint?
    // Will hold Constrains for CenterY
    let centerY : NSLayoutConstraint?
    // Check Device
    if Device.IS_IPHONE_X {
      // Set Height Constrains for iPhone X
      height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .lessThanOrEqual, toItem: reference, attribute: .height, multiplier: 0.8, constant: 0.0)
      // This constraint centers the Label Vertically in the View
      centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: reference, attribute: .centerY, multiplier: 1.2, constant: 0.0)
    } else {
      // Set Height Constrains for Regular iPhone
      height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .lessThanOrEqual, toItem: reference, attribute: .height, multiplier: 1.0, constant: 0.0)
      // This constraint centers the Label Vertically in the View
      centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: reference, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    }
    // Set Weidth Constrains for iPhone
    let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .lessThanOrEqual, toItem: reference, attribute: .width, multiplier: 0.8, constant: 0.0)
    // Activate the constraints
    reference.addConstraints([centerX, centerY!, height!, width])
  }
}
