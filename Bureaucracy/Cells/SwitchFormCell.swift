//
//  SwitchFormCell.swift
//  Stylight
//
//  Created by Bernhard Obereder on 13.01.15.
//  Copyright (c) 2015 Stylight. All rights reserved.
//

import Bureaucracy
import UIKit

public class SwitchFormCell: FormCell {

  @IBOutlet public weak var switchControl: UISwitch!
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    accessoryType = .None
    switchControl.layer.zPosition = 1
    selectionStyle = .None
  }
  @IBAction func cellSwitchValueChanged(sender: AnyObject) {
    formElement?.cellDidChangeInternalValue(self)
  }

}