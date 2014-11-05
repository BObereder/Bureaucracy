//
//  FormElement.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 21.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class FormElement {

  public init(cellClass: AnyClass, name: String) {
    self.cellClass = cellClass
    self.name = name
  }
  
  public var name: String
  public var localizedTitle: String?
  public var cellClass: AnyClass
  public weak var formSection: FormSection?

  public func registerReusableView(tableView: UITableView) {
    tableView.registerClass(cellClass, forCellReuseIdentifier: self.cellClass.description())
  }

  public func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.cellClass.description(), forIndexPath: indexPath) as FormCell
    cell.formElement = self
    return cell
  }
  
  public func update(cell: FormCell) {
    cell.textLabel.text = localizedTitle ?? name
  }

  public func serialize() -> (String, Any?){
    return (name, nil)
  }

  public var didSelect: () -> () = {
    println("selected")
  }

  // FIXME: Workaround for UIKit not supporting Generics, should be moved into FormField and accept Internal type
  public func didChangeInternalValue(cell: FormCell) {
    // noop
  }
  
}
