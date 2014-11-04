//
//  FormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class FormSection {

  public var name: String
  public var localizedTitle: String?

  public var form: Form

  public var elements: [FormElement] = []

  public init(form: Form, name: String) {
    self.form = form
    self.name = name
  }

  public func numberOfFields() -> Int {
    return elements.count
  }

  public func addElement(element: FormElement) -> FormElement {
    elements += [element]
    return element
  }

  public func addField <Type, Internal, Representation> (field: FormField<Type, Internal, Representation>) -> FormField <Type, Internal, Representation> {
    elements += [field]
    return field
  }

  public func values() -> [[String: Any?]] {
    return elements.map { ($0 as FormElement).serialize() }
  }

}
