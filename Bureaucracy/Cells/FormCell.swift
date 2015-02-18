//
//  FormCell.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit
import SwiftHelpers

public class FormCell: UITableViewCell {

  public var formElement: FormElement?

  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .None
    selectionStyle = .None
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
