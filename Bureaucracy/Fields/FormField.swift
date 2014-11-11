//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type: Equatable, Internal, Representation>: FormElement, FormDataProtocol {
  
  public init(_ name: String, value: Type, cellClass: AnyClass, transformer: Type -> Internal, reverse: Internal -> Type) {
    valueTransformer = transformer
    reverseValueTransformer = reverse
    self.value = value
    super.init(name, cellClass: cellClass)
  }
  
  // MARK: PreviousValue
  
  var previousValue: Type?

  // MARK: Value
  
  public var value: Type? {
    didSet {
      if previousValue != value {
        didSetValue(oldValue: oldValue, newValue: value)
      }
    }
  }

  var internalValue: Internal? {
    get {
      return FormUtilities.convertValue(value, transformer: valueTransformer)
    }
    set {
      (value, error) = FormUtilities.convertInternalValue(newValue, transformer: reverseValueTransformer, validator: validator)
    }
  }

  var valueTransformer: Type -> Internal
  var reverseValueTransformer: Internal -> Type

  func didSetValue(#oldValue: Type?, newValue: Type?) {
    error = FormUtilities.validateValue(newValue, validator: validator)
    if error == nil {
      section?.didUpdate(field: self)
    }
    else {
      previousValue = oldValue
      value = oldValue
    }
  }

  // MARK: Values

  var options: [Type] = []

  func option(index: Int) -> Type {
    return options[index]
  }

  var optionCount: Int {
    return options.count
  }

  func representation(index: Int) -> Representation? {
    return representationTransformer?(option(index))
  }

  var representationTransformer: (Type -> Representation)?

  // MARK: Validation

  public var validator: ((Type) -> (NSError?))? 
  public var error: NSError?

  // MARK: Serialization

  public override func serialize() -> (String, Any?) {
    return (name, value)
  }

}
