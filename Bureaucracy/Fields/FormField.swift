//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class FormField {

  public var title: String?
  public var formValue: AnyObject?

  public var value: AnyObject? {
    get {
      return formValue
    }

    set {
      formValue = value
    }
  }

  public func registerReusableView(tableView: UITableView) {
    tableView.registerClass(FormField.self, forCellReuseIdentifier: self.description())
  }

  public func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.description(), forIndexPath: indexPath) as FormCell
    cell.formField = self
    return cell
  }

  public func description() -> String {
    return "FormField"
  }

  public func didSelect() { }

}
