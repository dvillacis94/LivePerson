//
//  UIImage+LivePerson.swift
//  SampleSDK30
//
//  Created by David Villacis on 3/6/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//
import UIKit

extension UIImageView {
  
  /// Will set Image with Contents of URL
  ///
  /// - Parameter url: Image URL
  func setImage(url : String){
    // Transform to URL Object
    if let url = URL(string: url){
      // Get Data from URL
      if let data = NSData(contentsOf: url) as Data?{
        // Set Image with URL Data
        self.image = UIImage(data: data)
      }
    }
  }
}
