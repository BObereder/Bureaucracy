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

public class SelectorFormSection<Type: protocol<Equatable, Printable>>: FormSection, FormDataProtocol {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, value: Type?, options: [Type]) {
    self.options = options
    super.init(name)
    currentValue = value
  }

  // MARK: - Fields

  public override var count: Int {
    return options.count
  }

  // MARK: - CollectionType

  public override subscript(position: Int) -> FormElement {
    if (position == endIndex) {
      let object = option(position)
      let element = append(SelectorGroupFormField("\(name).\(position)", value: object == currentValue))
      element.localizedTitle = typeToRepresentation(object)
      return element
    }
    else {
      return super[position]
    }
  }
  
  // MARK: - Options

  private var options: [Type]

  public func option(position: Int) -> Type {
    return options[position]
  }

  public func optionIndex(option: Type) -> Int {
    return find(options, option)!
  }

  public var optionCount: Int {
    return options.count
  }

  // MARK: - Values

  private var _currentValue: Type?

  public final var currentValue: Type? {
    set {
      error = validate(newValue)
      if error == nil && newValue != _currentValue {
        previousValue = _currentValue
        _currentValue = newValue
        didSetValue()

        for x in self {
          if newValue != nil && x.fieldIndex == optionIndex(newValue!) {
            (x as? SelectorGroupFormField)?.currentValue = true
            continue
          }
          (x as? SelectorGroupFormField)?.currentValue = false
        }
      }
    }
    get {
      return _currentValue
    }
  }

  public func didSetValue() {
    let field = filter(self) { return ($0 as? SelectorGroupFormField)?.currentValue == true }
    form?.didUpdate(section: self, field: field.first)
  }

  public var previousValue: Type?

  public var internalValue: Internal? {
    get {
      return typeToInternal(currentValue)
    }
    set(newOption) {
      currentValue = internalToType(newOption)
    }
  }

  // MARK: - Value transformers

  public func typeToInternal(value: Type?) -> Internal? {
    if value == nil {
      return nil
    }
    else {
      return optionIndex(value!)
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
    return value?.description
  }

  // MARK: - Validation

  public func validate(value: Type?) -> NSError? {
    return nil
  }

  public var error: NSError?

  // MARK: - Serialization

  public override func serialize() -> [String: Any?] {
    return [name: currentValue]
  }

  // MARK: - Callbacks

  public override func didUpdate(#field: FormElement?) {
    for x in self {
      if field == x {
        internalValue = field?.fieldIndex
      }
      else {
        (x as? SelectorGroupFormField)?.currentValue = false
      }
    }
  }

}
