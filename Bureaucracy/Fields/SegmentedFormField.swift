//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class SegmentedFormField<Type, Internal, Representation>: FormField<Type, Int, String> {

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.cellClass)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: self.cellClass.description())
  }

  public init(value: Type, values: [Type]) {
    super.init(cellClass: SegmentedFormCell.self, value: value)
    self.values = values
  }

  
  public var didChangeValue: (cell: FormCell) -> () = { (let cell) in
    println("valueChanged")
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
  
  public override func cellDidChangeValue(cell: FormCell) {
    if let realCell = cell as? SegmentedFormCell {
      if let field = realCell.formElement as? SegmentedFormField<Type, Int, String> {
        field.internalValue = realCell.segmentedControl.selectedSegmentIndex
        field.didChangeValue(cell: cell)
        super.notifyDidChangeValue()
      }
    }
  }
  
}
