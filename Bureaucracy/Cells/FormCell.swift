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

  public var formField: FormField? {
    didSet {
      update()
    }
  }

  public func update() { }

  public override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  public override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
