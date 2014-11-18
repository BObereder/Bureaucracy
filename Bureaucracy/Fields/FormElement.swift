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
    self.accessibilityLabel = name
  }

  // MARK: - Section relationship

  public weak var section: FormSection?

  public var fieldIndex: Int? {
    if let elements = section {
      return find(elements, self)
    }
    return nil
  }

  // MARK: - Titles
  
  public var name: String
  public var localizedTitle: String?
  public var accessibilityLabel: String?

  // MARK: - Interface

  public func registerReusableView(tableView: UITableView) {
    tableView.registerClass(FormCell.self, forCellReuseIdentifier: name)
  }

  public func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath) as FormCell
    cell.formElement = self
    return cell
  }

  public func configureCell(cell: FormCell) {
    cell.textLabel!.text = localizedTitle ?? name
    cell.accessibilityLabel = "\(accessibilityLabel).cell"
  }

  // MARK: - Callbacks

  // FIXME: Workaround for UIKit not supporting Generics, should be moved into FormField and accept Internal type
  public func didChangeInternalValue(cell: FormCell) {
    // noop
  }

  public func didSelect() {
    // noop
  }

  // MARK: - Serialization

  public func serialize() -> (String, Any?) {
    return (name, nil)
  }

}
