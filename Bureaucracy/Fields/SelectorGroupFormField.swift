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
    let transformer: Type -> Internal = { return $0 as Internal }
    let reverse: Internal -> Type = { return $0 as Type }

    super.init(name, value: value, cellClass: FormCell.self, transformer: transformer, reverse: reverse)
    values = [true, false]
    accessibilityLabel = "SelectorGroupFormField"
    representationTransformer = { return $0 as Representation }
    didSelect = { self.internalValue = true }
  }

  override func didSetValue(#oldValue: Type?, newValue: Type?) {
    error = FormUtilities.validateValue(newValue, validator: validator)
    if error == nil {
      if let theValue = newValue as? Bool {
        if theValue == true {
          formSection?.didUpdate(item: self)
        }
      }
    }
  }
}
