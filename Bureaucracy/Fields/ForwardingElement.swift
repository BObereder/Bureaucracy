//
//  ForwardingElement.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 29.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class ForwardingElement: FormElement {
  
  public override func configureCell(cell: FormCell) {
    cell.accessoryType = .DisclosureIndicator
    super.configureCell(cell)
  }
  
}
