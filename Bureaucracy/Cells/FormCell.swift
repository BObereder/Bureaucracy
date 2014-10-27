//
//  FormCell.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import SwiftHelpers
import UIKit

public class FormCell: UITableViewCell {

  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  public var formElement: FormElement? {
    didSet {
      if let realElement = formElement {
        realElement.update(self)
      }
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}
