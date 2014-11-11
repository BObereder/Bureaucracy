//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class SegmentedFormField<Type: protocol<Equatable, Printable>, Internal, Representation>: FormField<Type, Internal, Representation> {

  public init(_ name: String, value: Type, options: [Type]) {
    super.init(name, value: value, options: options, cellClass: SegmentedFormCell.self)
    accessibilityLabel = "SegmentedFormField"
  }

  // MARK: - FormElementProtocol

  // MARK: Interface

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.cellClass)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: self.cellClass.description())
  }

  public override func configureCell(cell: FormCell) {
    if let realCell = cell as? SegmentedFormCell {
      realCell.segmentedControl.accessibilityLabel = "SegmentedControl"
      realCell.segmentedControl.removeAllSegments()

      for i in 0..<optionCount {
        if let title = typeToRepresentation(option(i)) as? String {
          realCell.segmentedControl.insertSegmentWithTitle(title, atIndex: realCell.segmentedControl.numberOfSegments, animated: false)
        }
      }

      if let index = internalValue {
        realCell.segmentedControl.selectedSegmentIndex = index as Int
      }
    }
  }

  // MARK: Callbacks

  public override func didChangeInternalValue(cell: FormCell) {
    if let field = cell.formElement as? SegmentedFormField {
      field.internalValue = (cell as? SegmentedFormCell)?.segmentedControl.selectedSegmentIndex as? Internal
    }
    super.didChangeInternalValue(cell)
  }

  // MARK: - FormDataProtocol

  // MARK: Value transformers

  public override func typeToInternal(value: Type?) -> Internal? {
    if value == nil {
      return nil
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

  public override func typeToRepresentation(value: Type?) -> Representation? {
    return value?.description as? Representation
  }

}
