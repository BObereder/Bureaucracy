//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type, Internal, Representation>: FormElement, FormDataProtocol {
  
  public init(_ name: String, value: Type, cellClass: AnyClass, transformer: Type -> Internal, reverse: Internal -> Type) {
    valueTransformer = transformer
    reverseValueTransformer = reverse
    self.value = value
    super.init(name, cellClass: cellClass)
  }

  // MARK: Value

  public var value: Type? {
    didSet {
      if !processingUndoo {
        didSetValue(oldValue: oldValue, newValue: value)
      }
    }
  }

  public var internalValue: Internal? {
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
      formSection?.didUpdate(item: self)
    }
    else {
      undoValueChange(oldValue)
    }
  }
  
  var processingUndoo: Bool = false
  
  func undoValueChange(oldValue: Type?) {
    processingUndoo = true
    value = oldValue
  }

  // MARK: Values

  var values: [Type] = []

  public var representationValues: [Representation]? {
    return FormUtilities.convertToRepresenationValues(values, representationTransformer: representationTransformer)
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
