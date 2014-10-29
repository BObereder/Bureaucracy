//
//  ForwardingElement.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 29.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class ForwardingElement: FormElement {
  
  public init(formSection: FormSection) {
    super.init(formSection: formSection, cellClass: FormCell.self)
  }
  
  public override func update(cell: FormCell) {
    cell.accessoryType = .DisclosureIndicator
    super.update(cell)
  }
  
}
