//
//  FormProtocol.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

// MARK: - FormElementProtocol

public protocol FormElementProtocol: Equatable {

  // MARK: Section relationship

  weak var section: FormSection? { get set }
  var fieldIndex: Int? { get }

  // MARK: Titles

  var name: String { get set }
  var localizedTitle: String? { get set }
  var accessibilityLabel: String? { get set }

  // MARK: Interface

  var cellClass: AnyClass { get set }
  func registerReusableView(tableView: UITableView)
  func dequeueReusableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> FormCell
  func configureCell(cell: FormCell)

  // MARK: Callbacks

  func didChangeInternalValue(cell: FormCell)
  func didSelect()

  // MARK: Serialization

  func serialize() -> (String, Any?)
  
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

  // MARK: Callbacks

  func didUpdate(#field: FormElement?)

}

// MARK: - FormDataProtocol

public protocol FormDataProtocol {

  typealias Type
  typealias Representation
  typealias Internal

  // MARK: Options

  func option(position: Int) -> Type
  func optionIndex(option: Type) -> Int
  var optionCount: Int { get }

  // MARK: Values

  var currentValue: Type? { get set }
  var previousValue: Type? { get set }
  var internalValue: Internal? { get set }
  func didSetValue(#oldValue: Type?, newValue: Type?)

  // MARK: Value transformers

  func typeToInternal(value: Type?) -> Internal?
  func internalToType(internalValue: Internal?) -> Type?
  func typeToRepresentation(value: Type?) -> Representation?

  // MARK: Validation

  func validate(value: Type?) -> NSError?
  var error: NSError? { get set }

}