//
//  SelectorGroupFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 6.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

typealias SelectorGroupFormField = _SelectorGroupFormField<Bool, Bool, Bool>

public class _SelectorGroupFormField<Type: BooleanLiteralConvertible, Internal: BooleanLiteralConvertible, Representation>: FormField<Type, Internal, Representation> {

  public init(_ name: String, value: Type) {
    super.init(name, value: value, cellClass: FormCell.self)
    values = [true, false]
    accessibilityLabel = "SelectorGroupFormField"
    valueTransformer = { return $0 as Internal }
    reverseValueTransformer = { return $0 as Type }
    representationTransformer = { return $0 as Representation }
    didSelect = { self.internalValue = true }
  }

  public override var value: Type? {
    didSet {
      error = FormUtilities.validateValue(value, validator: validator)
      if error == nil {
        if let theValue = value as? Bool {
          if theValue == true {
            formSection?.didUpdate(item: self)
          }
        }
      }
    }
  }
}
