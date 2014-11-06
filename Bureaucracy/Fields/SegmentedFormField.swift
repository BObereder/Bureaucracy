//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class SegmentedFormField<Type: Equatable, Internal, Representation>: FormField<Type, Internal, Representation> {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, value: Type, values: [Type]) {
    super.init(name, value: value, cellClass: SegmentedFormCell.self)
    self.values = values

    valueTransformer = { (var x) -> Internal in return find(values, x)! }
    reverseValueTransformer = { (var idx) -> Type in return values[idx] }
    representationTransformer = { (var x) -> Representation in
      if let theRepresentation = self.representation {
        if let idx = find(values, x) {
          return theRepresentation[idx]
        }
      }
      return "\(x)"
    }
  }

  public var representation: [Representation]?

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.cellClass)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: self.cellClass.description())
  }

  public override func update(cell: FormCell) {
    if let realCell = cell as? SegmentedFormCell {
      realCell.segmentedControl.removeAllSegments()
  
      if let field = cell.formElement as? SegmentedFormField<Type, Int, String> {
        if let realValues = field.representationValues {
          for v in realValues {
            realCell.segmentedControl.insertSegmentWithTitle(v, atIndex: realCell.segmentedControl.numberOfSegments, animated: false)
          }
          if let index = field.internalValue {
            realCell.segmentedControl.selectedSegmentIndex = index
          }
        }
      }
    }
  }
  
  public override func didChangeInternalValue(cell: FormCell) {
    if let field = cell.formElement as? SegmentedFormField {
      field.internalValue = (cell as SegmentedFormCell).segmentedControl.selectedSegmentIndex
    }
    super.didChangeInternalValue(cell)
  }

}
