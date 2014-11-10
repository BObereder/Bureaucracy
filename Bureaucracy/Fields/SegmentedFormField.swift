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

  public init(_ name: String, value: Type, options: [Type], transformer: Type -> Internal, reverse: Internal -> Type) {
    super.init(name, value: value, cellClass: SegmentedFormCell.self, transformer: transformer, reverse: reverse)
    self.options = options

    accessibilityLabel = "SegmentedFormField"
    
    representationTransformer = { (var x) -> Representation in
      if let theRepresentation = self.representation {
        if let idx = find(options, x) {
          return theRepresentation[idx]
        }
      }
      return "\(x)"
    }
  }
  
  public convenience init(_ name: String, value: Type, options: [Type]) {
    let transformer: Type -> Internal = { (var x) -> Internal in return find(options, x)! }
    let reverse: Internal -> Type = { (var idx) -> Type in return options[idx] }
    self.init(name, value: value, options: options, transformer: transformer, reverse: reverse)
  }

  public var representation: [Representation]?

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.cellClass)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: self.cellClass.description())
  }

  public override func update(cell: FormCell) {
    if let realCell = cell as? SegmentedFormCell {
      realCell.segmentedControl.accessibilityLabel = accessibilityLabel
      realCell.segmentedControl.removeAllSegments()
  
      if let field = cell.formElement as? SegmentedFormField<Type, Int, String> {
        for i in 0..<field.optionCount {
          if let title = field.representation(i) {
            realCell.segmentedControl.insertSegmentWithTitle(title, atIndex: realCell.segmentedControl.numberOfSegments, animated: false)
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
