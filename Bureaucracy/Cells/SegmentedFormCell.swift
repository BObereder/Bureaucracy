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
    formElement?.didChangeInternalValue(self)
  }
  
  public override var accessibilityLabel: String! {
    didSet {
      segmentedControl.accessibilityLabel = accessibilityLabel
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

}
