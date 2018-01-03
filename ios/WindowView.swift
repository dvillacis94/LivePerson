//
//  WindowView.swift
//  LivePerson
//
//  Created by David Villacis on 1/3/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit

class WindowView: UIView {

  // MARK: - Properties
  
  // MessagingConversation Reference
  private var messagingViewController: WindowModeViewController?
  
  /// Override Layout
  override func layoutSubviews() {
    // Super Init
    super.layoutSubviews()
    // Check if MessagingViewController has been set
    if self.messagingViewController != nil {
      // Set Frame
      messagingViewController!.view.frame = bounds
    } else {
      // Embed ViewController
      self.embed()
    }
  }
  
  /// Init View
  ///
  /// - Parameter frame: Frame
  override init(frame: CGRect) {
    // Init Super
    super.init(frame: frame)
  }
  
  /// Super Init
  required init?(coder aDecoder: NSCoder) {
    // Log
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Embed Controller with View
  private func embed() {
    // Get Parent ViewController
    guard let parent = parentViewController else {
      // if Error Escape
      return
    }
    // Reference to MessagingViewController
    let messaging = WindowModeViewController()
    // Add Controller to ParentController
    parent.addChildViewController(messaging)
    // Add MessagingView
    addSubview(messaging.view)
    // Set Frame
    messaging.view.frame = bounds
    // MessagingController did Move
    messaging.didMove(toParentViewController: parent)
    // Set MessagingViewController Reference
    self.messagingViewController = messaging
  }
}
/// TODO : This code is commented here to avoid crashing, because is already defined on the MessagingView.swift,
/// needs to be uncommented when implementing Window Mode and MessagingView.swift is not present
//extension UIView {
//  // Get Parent Controller
//  var parentViewController: UIViewController? {
//    // Get Responder
//    var parentResponder: UIResponder? = self
//    // Iterate Responder
//    while parentResponder != nil {
//      // Get Next Responder
//      parentResponder = parentResponder!.next
//      // Get Responder View Controller
//      if let viewController = parentResponder as? UIViewController {
//        // Return Controller
//        return viewController
//      }
//    }
//    // Return Nil if no Controller Found
//    return nil
//  }
//}

