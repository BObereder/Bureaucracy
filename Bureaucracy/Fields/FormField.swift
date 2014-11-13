//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type: Equatable, Internal, Representation>: FormElement, FormDataProtocol {
  
  public init(_ name: String, value: Type, options: [Type], cellClass: AnyClass) {
    self.options = options
    currentValue = value
    super.init(name, cellClass: cellClass)
  }

  // MARK: - FormElementProtocol

  // MARK: Serialization

  public override func serialize() -> (String, Any?) {
    return (name, currentValue)
  }

  // MARK: - FormDataProtocol

  // MARK: Options

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

  // MARK: Values

  public final var currentValue: Type? {
    didSet {
      didSetValue(oldValue: oldValue, newValue: currentValue)
    }
  }

  public func didSetValue(#oldValue: Type?, newValue: Type?) {
    if previousValue == newValue {
      return
    }

    error = validate(newValue)
    if error != nil {
      currentValue = previousValue
    }
    else {
      previousValue = oldValue
      section?.didUpdate(field: self)
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

  public func typeToRepresentation(value: Type?) -> Representation? {
    if value == nil {
      return nil
    }
    else {
      return value as? Representation
    }
  }

  // MARK: - Validation

  public func validate(value: Type?) -> NSError? {
    return nil
  }

  public var error: NSError?

}
