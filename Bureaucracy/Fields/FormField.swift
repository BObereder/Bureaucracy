//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type: Equatable, Internal>: FormElement, FormDataProtocol {
  
  public init(_ name: String, value: Type?, options: [Type]?) {
    self.options = options
    super.init(name)
    currentValue = value
    initialValue = value
  }

  // MARK: - FormElementProtocol

  // MARK: Serialization

  public override func serialize() -> (String, Any?) {
    return (name, currentValue)
  }

  // MARK: Reset

  public override func undo() {
    currentValue = previousValue
  }

  public override func revert() {
    currentValue = initialValue
  }

  public override func reset() {
    currentValue = nil
  }

  // MARK: - FormDataProtocol

  // MARK: Options

  private var options: [Type]?

  public func option(position: Int) -> Type {
    return options![position]
  }

  public func optionIndex(option: Type) -> Int {
    return find(options!, option)!
  }

  public var optionCount: Int {
    return options!.count
  }

  // MARK: Values

  var initialValue: Type?

  private var _currentValue: Type?

  public final var currentValue: Type? {
    get {
      return _currentValue
    }
    set {
      error = validate(newValue)
      if error == nil && newValue != _currentValue {
        previousValue = _currentValue
        _currentValue = newValue
        didSetInternalValue()
      }
    }
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

  public func didSetInternalValue() {
    section?.didUpdate(field: self)
  }
  
  // MARK: - Value transformers

  public func typeToInternal(value: Type?) -> Internal? {
    if value == nil {
      return nil
    }
    else {
      return value as? Internal
    }
  }

  public func internalToType(internalValue: Internal?) -> Type? {
    if internalValue == nil {
      return nil
    }
    else {
      return internalValue as? Type
    }
  }

  // MARK: - Validation

  public func validate(value: Type?) -> NSError? {
    return nil
  }

  public var error: NSError?

}
