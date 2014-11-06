//
//  ForwardingElement.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 29.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class ForwardingElement: FormElement {
  
  public init(_ name: String) {
    super.init(name, cellClass: FormCell.self)
    self.accessibilityLabel = "ForwardingElement"
  }
  
  public override func update(cell: FormCell) {
    cell.accessoryType = .DisclosureIndicator
    super.update(cell)
  }
  
}
