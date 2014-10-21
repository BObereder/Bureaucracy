//
//  SegmentedFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class SegmentedFormField<T, String, Int>: FormField<T, String, Int> {

  public var segments: [String] = []

  public override func registerReusableView(tableView: UITableView) {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib: UINib! = UINib(nibName: self.description(), bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: self.description())
  }

//  public func description() -> String {
//    return "SegmentedFormField"
//  }

}
