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
      return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100.0))
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
    // Label Hieght
    let labelHeight = view.frame.height-10
    // Label Width
    let labelWidth = view.frame.width-10
    // Create new Label
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight))
    // Set Label Origin
    label.frame.origin = CGPoint(x: view.frame.origin.x+10, y: view.frame.origin.y+10)
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
}
