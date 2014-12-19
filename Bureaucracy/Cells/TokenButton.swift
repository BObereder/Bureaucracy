//
//  TokenView.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 19.12.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

@IBDesignable

class TokenButton: UIButton {

  var label: UILabel = UILabel()

  private func initialize() {
    backgroundColor = UIColor.redColor()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }

  override func contentRectForBounds(bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 25, y: bounds.origin.y, width: bounds.size.width - 50, height: bounds.size.height)
  }

}
