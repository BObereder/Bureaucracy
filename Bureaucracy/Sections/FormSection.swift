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

public class FormSection: Equatable, CollectionType {

  public init(_ name: String) {
    self.name = name
  }

  // MARK: - Form relationship

  public var form: Form?

  public var index: Int {
    return find(form!.sections, self)!
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

  // MARK: - Callbacks

  public func didUpdate(#field: FormElement?) {
    form?.didUpdate(section: self, field: field)
  }

  // MARK: - SequenceType

  public func generate() -> GeneratorOf<FormElement> {
    var i = 0
    return GeneratorOf<FormElement> {
      return i == self.count ? .None : self[i++]
    }
  }

}
