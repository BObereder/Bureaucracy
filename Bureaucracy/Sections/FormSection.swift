//
//  FormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public func ==(lhs: FormSection, rhs: FormSection) -> Bool {
  return lhs === rhs
}

public class FormSection: FormSectionProtocol {

  public init(_ name: String) {
    self.name = name
  }

  // MARK: - Form relationship

  public weak var form: Form?

  public var sectionIndex: Int? {
    if let sections = form?.sections {
      return find(sections, self)
    }
    return nil
  }

  // MARK: - Titles

  public var name: String
  public var localizedTitle: String?

  // MARK: - Fields

  private var fields: [FormElement] = []

  public func append(field: FormElement) -> FormElement {
    field.section = self
    fields.append(field)
    return field
  }

  public func removeAll() {
    fields.removeAll(keepCapacity: false)
  }

  public var count: Int {
    return fields.count
  }

  // MARK: - CollectionType

  public subscript(position: Int) -> FormElement {
    return fields[position]
  }

  public final var startIndex: Int {
    return 0
  }

  public final var endIndex: Int {
    return fields.count
  }

  // MARK: - Serialization

  public func serialize() -> [String: Any?] {
    var dict = [String: Any?]()

    for x in self {
      let (key, value) = x.serialize()
      dict[key] = value
    }

    return dict
  }

  // MARK: Reset

  public func undo() {
    for x in self {
      x.undo()
    }
    form?.reloadSection(self)
  }

  public func revert() {
    for x in self {
      x.revert()
    }
    form?.reloadSection(self)
  }

  public func reset() {
    for x in self {
      x.reset()
    }
    form?.reloadSection(self)
  }

  // MARK: - Callbacks

  public func didUpdate(#field: FormElement?) {
    form?.didUpdate(section: self, field: field)
  }

  public func accessoryType(#field: FormElement) -> UITableViewCellAccessoryType? {
    return nil
  }

  // MARK: - SequenceType

  public func generate() -> GeneratorOf<FormElement> {
    var i = 0
    return GeneratorOf<FormElement> {
      return i == self.count ? .None : self[i++]
    }
  }

}
