//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type, Internal, Representation>: FormElement, FormDataProtocol {
  
  public init(formSection: FormSection, cellClass: AnyClass, value: Type) {
    self.value = value
    super.init(formSection: formSection, cellClass: cellClass)
    internalValue = valueTransformer?(value)
  }

  public var values: [Type] = []

  public var value: Type? {
    didSet {
      error = FormUtilities.validateValue(value, validator: validator)
    }
  }

  public var representationValues: [Representation]? {
    return FormUtilities.convertToRepresenationValues(values, representationTransformer: representationTransformer)
  }

  public var internalValue: Internal? {
    didSet {
      (value, error) = FormUtilities.convertInternalValue(internalValue, transformer: reverseValueTransformer, validator: validator)
    }
  }

  public var valueTransformer: ((Type) -> (Internal))? {
    didSet {
      internalValue = FormUtilities.convertValue(value, transformer: valueTransformer)
    }
  }

  public var reverseValueTransformer: ((Internal) -> (Type))?
  public var representationTransformer: ((Type) -> (Representation))?
  public var validator: ((Type) -> (NSError?))? 
  public var error: NSError?
  
  public override func serialize() -> [String: Any]? {
    if let realTitle = title {
      if let realValue = value {
        var dict = [realTitle : realValue as Any]
        return dict
      }
    }
    return nil
  }

}
