//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class SegmentedFormField<Type, Internal, Representation>: FormField<Type, Int, String> {

  public var segments: [String] = []

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.cellClass)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: self.description())
  }

  public init(value: Type, segments:[String], valueTransformer: (Type) -> (Int), reverseValueTransformer: (Int) -> (Type)) {
    self.segments = segments
    super.init(cellClass: SegmentedFormCell.self, value: value, valueTransformer: valueTransformer, reverseValueTransformer: reverseValueTransformer)
    self.valueTransformer = valueTransformer
    self.reverseValueTransformer = reverseValueTransformer
  }

  public override func description() -> String {
    return "SegmentedFormField"
  }

  public override func didSelect() {
  
  }
  
  public var onValueChanged: () -> () = {
    println("valueChanged")
  }
}
