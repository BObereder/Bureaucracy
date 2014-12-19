//
//  TokenSelectorGroupFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 19.12.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class TokenSelectorGroupFormField<Type: protocol<Equatable, Printable>, Internal: protocol<Printable>>: FormField<Type, Internal>, FormRepresentationProtocol {

  public override init(_ name: String, value: Type?, options: [Type]?) {
    super.init(name, value: value, options: options)
  }

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: FormTokenCell.self)
    let nib: UINib! = UINib(nibName: "FormTokenCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: name)
  }

  public override func configureCell(cell: FormCell) {
    cell.accessibilityIdentifier = "\(name).cell"

    if let cell = cell as? FormTokenCell {
      cell.textLabel?.text = localizedTitle
      if let currentValue = currentValue {
        if let title = typeToRepresentation(currentValue) {
          cell.tokenButton?.hidden = true
          cell.tokenButton?.setTitle(title, forState: .Normal)
        }
      }
      else {
        cell.tokenButton?.hidden = true
      }
    }
  }

  // MARK: Value transformers

  public override func typeToInternal(value: Type?) -> Internal? {
    return value as? Internal
  }

  public override func internalToType(internalValue: Internal?) -> Type? {
    return internalValue as? Type
  }

  public func typeToRepresentation(value: Type?) -> String? {
    if let value = value {
      return "\(value)"
    }
    else {
      return nil
    }
  }

}
