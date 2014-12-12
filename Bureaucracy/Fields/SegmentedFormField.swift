//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class SegmentedFormField<Type: Equatable, Internal: IntegerType>: FormField<Type, Internal>, FormRepresentationProtocol {

  public override init(_ name: String, value: Type?, options: [Type]?) {
    super.init(name, value: value, options: options)
  }

  // MARK: - FormElementProtocol

  // MARK: Interface

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: FormCell.self)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: name)
  }

  public override func configureCell(cell: FormCell) {
    cell.accessibilityIdentifier = "\(name).cell"

    if let cell = cell as? SegmentedFormCell {
      let control = cell.segmentedControl

      control.accessibilityIdentifier = "\(cell.accessibilityIdentifier).segmentedControl"
      control.removeAllSegments()

      for i in 0..<optionCount {
        if let title = typeToRepresentation(option(i)) {
          control.insertSegmentWithTitle(title, atIndex: control.numberOfSegments, animated: false)
        }
      }

      if let index = internalValue {
        control.selectedSegmentIndex = index as Int
      }
    }
  }

  // MARK: Callbacks

  public override func cellDidChangeInternalValue(cell: FormCell) {
    if let field = cell.formElement as? SegmentedFormField {
      field.internalValue = (cell as? SegmentedFormCell)?.segmentedControl.selectedSegmentIndex as? Internal
    }
    super.cellDidChangeInternalValue(cell)
  }

  // MARK: - FormDataProtocol

  // MARK: Values

  public override func didSetInternalValue() {
    super.didSetInternalValue()
    if let index = internalValue {
      (currentCell as? SegmentedFormCell)?.segmentedControl.selectedSegmentIndex = index as Int
    }
  }

  // MARK: Value transformers

  public override func typeToInternal(value: Type?) -> Internal? {
    if value == nil {
      return -1
    }
    else {
      return optionIndex(value!) as? Internal
    }
  }

  public override func internalToType(internalValue: Internal?) -> Type? {
    if internalValue == nil {
      return nil
    }
    else {
      return option(internalValue! as Int)
    }
  }

  public func typeToRepresentation(value: Type?) -> String? {
    if let aValue = value {
      return "\(aValue)"
    }
    else {
      return nil
    }
  }

}
