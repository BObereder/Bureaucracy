//
//  FormElement.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 21.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class FormElement {

  public var title: String?
  public var cellClass: AnyClass

  public init(cellClass: AnyClass) {
    self.cellClass = cellClass
  }

  public func registerReusableView(tableView: UITableView) {
    tableView.registerClass(cellClass, forCellReuseIdentifier: self.description())
  }

  public func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.description(), forIndexPath: indexPath) as FormCell
    cell.formElement = self
    return cell
  }

  public func description() -> String {
    return "FormElement"
  }

  public var didSelect: () -> () = {
    println("selected")
  }
  
  public func update(cell: FormCell) {
    cell.textLabel.text = title
  }
  
  public func didChangeValue(cell: FormCell) {

  }

}
