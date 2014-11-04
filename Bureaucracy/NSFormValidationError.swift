//
//  NSFormValidationError.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 21.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class NSFormValidationError: NSError {

  init() {
    super.init(domain: "com.bureaucracy", code: 1, userInfo: nil)
  }

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
