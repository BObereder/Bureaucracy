//
//  SelectorFormSection.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class SelectorFormSection<Type, Internal, Representation>: FormSection, FormDataProtocol {

  public init(_ name: String, value: Type, values: [Type]) {
    self.values = values
    super.init(name)
    internalValue = valueTransformer?(value)
  }

  // MARK: Value

  public var value: Type? {
    didSet {
      error = FormUtilities.validateValue(value, validator: validator)
    }
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

  public override func serialize() -> [String: Any?] {
    return [name: value]
  }

}
