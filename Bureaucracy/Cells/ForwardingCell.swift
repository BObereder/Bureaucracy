//
//  ForwardingCell.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 27.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class ForwardingCell: FormCell {

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .DisclosureIndicator
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override class func description() -> String {
    return "ForwardingCell"
  }
  
}
