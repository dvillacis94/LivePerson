//
//  MessagingVIewManager.swift
//  LivePerson
//
//  Created by David Villacis on 12/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

@objc(MessagingViewManager)
class MessagingViewManager: RCTViewManager {
  
  /// Will Return Messaging View to RCTViewManager (React-Native)
  ///
  /// - Returns: Messaging View
  override func view() -> UIView!{
    // Return Messaging View
    return MessagingView()
  }
}
