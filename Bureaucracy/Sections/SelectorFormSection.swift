//
//  SelectorFormSection.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public func ==<Type>(lhs: SelectorFormSection<Type>, rhs: SelectorFormSection<Type>) -> Bool {
  return lhs === rhs
}

public class SelectorFormSection<Type: protocol<Equatable, Printable>>: FormSection, FormDataSectionProtocol {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, value: Type?, options: [Type]) {
    self.options = options
    self.value = value
    super.init(name)
  }

  // MARK: - Fields

  public override var count: Int {
    return options.count
  }

  // MARK: - CollectionType

  public override subscript(position: Int) -> FormElement {
    if (position == endIndex) {
      let object = option(position)
      let element = append(SelectorGroupFormField("\(name).\(position)", value: object == value))
      element.localizedTitle = typeToRepresentation(object)
      return element
    }
    else {
      return super[position]
    }
  }
  
  // MARK: - Options

  private var options: [Type]

  func option(index: Int) -> Type {
    return options[index]
  }

  var optionCount: Int {
    return options.count
  }

  // MARK: - Values

  public final var value: Type? {
    didSet {
      didSetValue(oldValue: oldValue, newValue: value)
    }
  }

  func didSetValue(#oldValue: Type?, newValue: Type?) {
    if previousValue == newValue {
      return
    }

    error = validate(newValue)
    if error != nil {
      previousValue = oldValue
      value = oldValue
    }
  }

  var previousValue: Type?

  var internalValue: Internal? {
    get {
      return typeToInternal(value)
    }
    set(newOption) {
      value = internalToType(newOption)
    }
  }

  // MARK: - Value transformers

  public func typeToInternal(value: Type?) -> Internal? {
    if value == nil {
      return nil
    }
    else {
      return find(options, value!)
    }
  }

  public func internalToType(internalValue: Internal?) -> Type? {
    if internalValue == nil {
      return nil
    }
    else {
      return options[internalValue!]
    }
  }

  public func typeToRepresentation(value: Type?) -> Representation? {
    if value == nil {
      return nil
    }
    else {
      return value!.description
    }
  }

  // MARK: - Validation

  func validate(value: Type?) -> NSError? {
    return nil
  }

  public var error: NSError?

  // MARK: - Serialization

  public override func serialize() -> [String: Any?] {
    return [name: value]
  }

  // MARK: - Callbacks

  public override func didUpdate(#field: FormElement?) {
    for x in self {
      if field == x {
        internalValue = field?.index
      }
      else {
        (x as? SelectorGroupFormField)?.value = false
      }
    }

    form?.didUpdate(section: self, field: field)
  }

}
