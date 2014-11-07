//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type, Internal, Representation>: FormElement, FormDataProtocol {
  
  public init(_ name: String, value: Type, cellClass: AnyClass) {
    self.value = value
    super.init(name, cellClass: cellClass)
    internalValue = valueTransformer?(value)
  }

  // MARK: Value

  public var value: Type? {
    didSet {
      error = FormUtilities.validateValue(value, validator: validator)
      if error == nil {
        formSection?.didUpdate(item: self)
      }
    }
  }

  public var internalValue: Internal? {
    didSet {
      if let transformer = reverseValueTransformer {
        (value, error) = FormUtilities.convertInternalValue(internalValue, transformer: transformer, validator: validator)
      }
    }
  }

  public var valueTransformer: ((Type) -> (Internal))? {
    didSet {
      internalValue = FormUtilities.convertValue(value, transformer: valueTransformer)
    }
  }

  public var reverseValueTransformer: ((Internal) -> (Type))?

  // MARK: Values

  public var values: [Type] = []

  public var representationValues: [Representation]? {
    return FormUtilities.convertToRepresenationValues(values, representationTransformer: representationTransformer)
  }

  public var representationTransformer: ((Type) -> (Representation))?

  // MARK: Validation

  public var validator: ((Type) -> (NSError?))? 
  public var error: NSError?

  // MARK: Serialization

  public override func serialize() -> (String, Any?) {
    return (name, value)
  }

}
