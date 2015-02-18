//
//  FormElement.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 21.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public func ==(lhs: FormElement, rhs: FormElement) -> Bool {
  return lhs === rhs
}

public class FormElement: FormElementProtocol {

  public init(_ name: String) {
    self.name = name
  }

  // MARK: - Section relationship

  public weak var section: FormSection?
  public weak var currentCell: FormCell?

  public var fieldIndex: Int? {
    if let elements = section {
      return find(elements, self)
    }
    return nil
  }

  // MARK: - Titles
  
  public var name: String
  public var localizedTitle: String?

  // MARK: - Interface

  public var cellReuseIdentifier: String {
    return FormCell.description()
  }

  public func register(tableView: UITableView) {
    tableView.registerClass(FormCell.self, forCellReuseIdentifier: cellReuseIdentifier)
  }

  public func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as FormCell
    cell.formElement = self
    currentCell = cell
    return cell
  }

  public func configureCell(cell: FormCell) {
    cell.textLabel?.text = localizedTitle ?? name
    cell.accessibilityIdentifier = "\(name).cell"
    section?.configureCell(cell, field: self)
  }

  // MARK: - Callbacks

  // FIXME: Workaround for UIKit not supporting Generics, should be moved into FormField and accept Internal type
  public func cellDidChangeInternalValue(cell: FormCell) {
    // noop
  }

  public func didSelect() {
    // noop
  }

  // MARK: - Serialization

  public func serialize() -> (String, Any?) {
    return (name, nil)
  }

  // MARK: Reset

  public func undo(_ shouldReload: Bool = true) {
    // noop
  }

  public func revert(_ shouldReload: Bool = true) {
    // noop
  }

  public func reset(_ shouldReload: Bool = true) {
    // noop
  }

  // MARK: Reload

  public func reload(rowAnimation animation: UITableViewRowAnimation = .Automatic) {
    section?.form?.reloadField(self, withRowAnimation: animation)
  }

}
