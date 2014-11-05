//
//  FormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class FormSection {

  public var title: String?
  
  public var form: Form

  public var elements: [FormElement] = []

  public init(form: Form) {
    self.form = form
  }

  public func numberOfFields() -> Int {
    return elements.count
  }
  
  public func addElement(element: FormElement) -> FormElement {
    element.formSection = self
    elements += [element]
    return element
  }
  
  public func addField <Type, Internal, Representation> (field: FormField<Type, Internal, Representation>) -> FormField <Type, Internal, Representation> {
    field.formSection = self
    elements += [field]
    return field
  }
  
  public func values() -> [[String: Any]] {
    var values: [[String: Any]] = []
    for element in elements {
        if let dict = element.valueDict() {
          values.append(dict)
        }
    }
    return values
  }

}
