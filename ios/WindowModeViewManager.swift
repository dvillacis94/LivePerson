//
//  WindowModeViewManager.swift
//  LivePerson
//
//  Created by David Villacis on 1/3/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@objc(WindowModeViewManager)
class WindowModeViewManager: RCTViewManager {
  
  /// Will Return Messaging View to RCTViewManager (React-Native)
  ///
  /// - Returns: Messaging View for Window Mode
  override func view() -> UIView!{
    // Return Messaging View
    return WindowView()
  }
}
