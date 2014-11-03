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
  public weak var formSection: FormSection?

  public init(formSection: FormSection, cellClass: AnyClass) {
    self.formSection = formSection
    self.cellClass = cellClass
  }

  public func registerReusableView(tableView: UITableView) {
    tableView.registerClass(cellClass, forCellReuseIdentifier: self.cellClass.description())
  }

  public func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.cellClass.description(), forIndexPath: indexPath) as FormCell
    cell.formElement = self
    return cell
  }

  public var didSelect: () -> () = {
    println("selected")
  }
  
  public func update(cell: FormCell) {
    cell.textLabel.text = title
  }
  
  public func cellDidChangeValue(cell: FormCell) {
    notifyDidChangeValue()
  }
  
  public func notifyDidChangeValue() {
    if let realSection = formSection {
      realSection.form.delegate?.didUpdateForm(realSection.form)
    }
  }
  
  public func valueDict() -> [String: Any]? {
    return nil
  }
  
}
