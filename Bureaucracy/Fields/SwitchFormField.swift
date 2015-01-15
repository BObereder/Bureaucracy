//
//  SwitchFormField.swift
//  Stylight
//
//  Created by Bernhard Obereder on 13.01.15.
//  Copyright (c) 2015 Stylight. All rights reserved.
//

import Foundation
import SwiftHelpers

public class SwitchFormField<Type: Equatable, Internal: BooleanLiteralConvertible>: FormField<Type, Internal>, FormRepresentationProtocol {
  
  public init(_ name: String, value: Type, options: [Type]?) {
    super.init(name, value: value, options: options)
  }
  
  // MARK: - Interface
  
  public override var cellReuseIdentifier: String {
    return SwitchFormCell.description()
  }
  
  public override func register(tableView: UITableView) {
    let bundle = NSBundle(forClass: SwitchFormCell.self)
    let nib: UINib! = UINib(nibName: "SwitchFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  public override func configureCell(cell: FormCell) {
    cell.accessibilityIdentifier = "\(name).cell"
    cell.switchControl.accessibilityIdentifier = "\(name).switch"
    
    if let cell = cell as? SwitchFormCell {
      cell.textLabel?.text = localizedTitle
      cell.switchControl.on = internalValue as Bool
    }
    section?.configureCell(field: self, cell: cell)
  }
  
  // MARK: Callbacks
  
  public override func cellDidChangeInternalValue(cell: FormCell) {
    if let field = cell.formElement as? SwitchFormField {
      field.internalValue = (cell as? SwitchFormCell)?.switchControl.on as? Internal
    }
    super.cellDidChangeInternalValue(cell)
  }
  
  // MARK: Values
  
  public override func didSetInternalValue(#oldValue: Type?) {
    super.didSetInternalValue(oldValue: oldValue)
    if let currentCell = currentCell as? SwitchFormCell {
      currentCell.switchControl.setOn(internalValue as Bool, animated: true)
    }
  }

}