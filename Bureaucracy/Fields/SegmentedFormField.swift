//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class SegmentedFormField<Type: Equatable>: FormField<Type, Int>, FormRepresentationProtocol {

  public override init(_ name: String, value: Type, options: [Type]) {
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
    if let segmentedCell = cell as? SegmentedFormCell {
      segmentedCell.segmentedControl.accessibilityLabel = "SegmentedControl"
      segmentedCell.segmentedControl.removeAllSegments()

      for i in 0..<optionCount {
        if let title = typeToRepresentation(option(i)) {
          segmentedCell.segmentedControl.insertSegmentWithTitle(title, atIndex: segmentedCell.segmentedControl.numberOfSegments, animated: false)
        }
      }

      if let index = internalValue {
        segmentedCell.segmentedControl.selectedSegmentIndex = index
      }
    }
  }

  // MARK: Callbacks

  public override func didChangeInternalValue(cell: FormCell) {
    if let field = cell.formElement as? SegmentedFormField {
      field.internalValue = (cell as? SegmentedFormCell)?.segmentedControl.selectedSegmentIndex
    }
    super.didChangeInternalValue(cell)
  }

  // MARK: - FormDataProtocol

  // MARK: Values

  public override func didSetValue(#oldValue: Type?, newValue: Type?) {
    super.didSetValue(oldValue: oldValue, newValue: newValue)
    if let index = internalValue {
      (currentCell as? SegmentedFormCell)?.segmentedControl.selectedSegmentIndex = index
    }
  }

  public override var internalValue: Int? {
    get {
      return typeToInternal(currentValue)
    }
    set(newOption) {
      currentValue = internalToType(newOption)
    }
  }

  // MARK: Value transformers

  public override func typeToInternal(value: Type?) -> Int? {
    if value == nil {
      return -1
    }
    else {
      return optionIndex(value!)
    }
  }

  public override func internalToType(internalValue: Int?) -> Type? {
    if internalValue == nil {
      return nil
    }
    else {
      return option(internalValue!)
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
