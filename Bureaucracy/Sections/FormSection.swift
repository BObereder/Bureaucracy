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

public class FormSection: SequenceType, Equatable {

  public init(_ name: String) {
    self.name = name
  }

  public var name: String
  public var localizedTitle: String?
  public var form: Form?

  var items: [FormElement] = []

  public func item(index: Int) -> FormElement {
    return items[index]
  }

  public var count: Int {
    return items.count
  }

  public var index: Int {
    return find(form!.sections, self)!
  }

  public func append(item: FormElement) -> FormElement {
    item.section = self
    items.append(item)
    return item
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

  public func didUpdate(#item: FormElement?) {
    form?.didUpdate(section: self, item: item)
  }

  // MARK: - SequenceType

  public func generate() -> GenericGenerator<FormElement> {
    return GenericGenerator(items: self.items)
  }

}
