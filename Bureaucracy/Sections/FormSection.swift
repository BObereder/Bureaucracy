//
//  FormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class FormSection: SequenceType {

  
  public init(form: Form, name: String) {
    self.form = form
    self.name = name
  }

  public var name: String
  public var localizedTitle: String?
  public var form: Form
  public var items: [FormElement] = []

  public var count: Int {
    return items.count
  }

  public func addElement(element: FormElement) -> FormElement {
    element.formSection = self
    elements += [element]
    return item
  }

  public func addField <Type, Internal, Representation> (field: FormField<Type, Internal, Representation>) -> FormField <Type, Internal, Representation> {
    field.formSection = self
    elements += [field]
    return field
  }

  public func serialize() -> [String: Any?] {
    return items
      .map { (var el) -> (String, Any?) in
        el.serialize()
      }
      .reduce([:]) { (var dict, tuple) -> [String: Any?] in
        var (key, value) = tuple
        dict[key] = value
        return dict
      }
  }

  // MARK: - SequenceType

  public func generate() -> GenericGenerator<FormElement> {
    return GenericGenerator(items: self.items)
  }

}
