//
//  SegmentedFormCell.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class SegmentedFormCell: FormCell {

  @IBOutlet weak var segmentedControl: UISegmentedControl!

  @IBAction public func didChangeValue(sender: UISegmentedControl) {
    if let realElement = formElement {
      realElement.cellDidChangeValue(self)
    }
  }
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .None
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    selectionStyle = .None
  }
  
  public override class func description() -> String {
    return "SegmentedFormCell"
  }
}
