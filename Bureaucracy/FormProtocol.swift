//
//  FormProtocol.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

// MARK: - FormElementProtocol

public protocol FormElementProtocol: Equatable {

  // MARK: Section relationship

  weak var section: FormSection? { get set }
  var fieldIndex: Int? { get }

  // MARK: Titles

  var name: String { get set }
  var localizedTitle: String? { get set }

  // MARK: Interface

  var cellReuseIdentifier: String { get }
  func register(tableView: UITableView)
  func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell
  func configureCell(cell: FormCell, tableView: UITableView)

  // MARK: Callbacks

  func cellDidChangeInternalValue(cell: FormCell)
  func didSelect()

  // MARK: Serialization

  func serialize() -> (String, Any?)

  // MARK: Reset

  /// Returns field to the previous value
  func undo(shouldReload: Bool)
  /// Returns field to the initial value
  func revert(shouldReload: Bool)
  /// Resets field to empty value
  func reset(shouldReload: Bool)
  
}

// MARK: - FormRepresentationProtocol

public protocol FormRepresentationProtocol {

  typealias Type
  typealias Representation

  func typeToInternal(value: Type?) -> Representation?

}

// MARK: - FormSectionProtocol

public protocol FormSectionProtocol: Equatable, CollectionType {

  // MARK: Form relationship

  weak var form: Form? { get set }
  var sectionIndex: Int? { get }

  // MARK: Titles

  var name: String { get set }
  var localizedTitle: String? { get set }

  // MARK: Serialization

  func serialize() -> [String: Any?]

  // MARK: Interface

  func register(tableView: UITableView)
  func configureCell(cell: FormCell, tableView: UITableView, field: FormElement)

  // MARK: Callbacks

  func didUpdate(#field: FormElement?)

  // MARK: Reset

  /// Returns section to the previous value
  func undo(shouldReload: Bool)
  /// Returns section to the initial value
  func revert(shouldReload: Bool)
  /// Resets section to empty value
  func reset(shouldReload: Bool)

  // MARK: Reload

  func reload(rowAnimation animation: UITableViewRowAnimation)

}

// MARK: - FormDataProtocol

public protocol FormDataProtocol {

  typealias Type
  typealias Internal

  // MARK: Options

  func option(position: Int) -> Type
  func optionIndex(option: Type) -> Int
  var optionCount: Int { get }

  // MARK: Values

  var currentValue: Type? { get set }
  var previousValue: Type? { get set }
  var internalValue: Internal? { get set }
  func didSetInternalValue(#oldValue: Type?)

  // MARK: Value transformers

  func typeToInternal(value: Type?) -> Internal?
  func internalToType(internalValue: Internal?) -> Type?

  // MARK: Validation

  func validate(value: Type?) -> NSError?
  var error: NSError? { get set }

}