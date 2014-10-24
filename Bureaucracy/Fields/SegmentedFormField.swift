//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class SegmentedFormField<T, Int, String>: FormField<T, Int, String> {

  public var segments: [String] = []

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.cellClass)
    let nib: UINib! = UINib(nibName: "SegmentedFormCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: "SegmentedFormField")
  }
  
  public override func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SegmentedFormField", forIndexPath: indexPath) as FormCell
    cell.formElement = self
    return cell
  }
  
  public init(value: T, segments:[String]) {
    self.segments = segments
    super.init(cellClass: SegmentedFormCell.self, value: value)
  }

//  public func description() -> String {
//    return "SegmentedFormField"
//  }

}
