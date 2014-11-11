//
//  SelectorGroupFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 6.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public typealias SelectorGroupFormField = _SelectorGroupFormField<Bool, Bool, Bool>

public class _SelectorGroupFormField<Type: protocol<Equatable, BooleanLiteralConvertible>, Internal: BooleanLiteralConvertible, Representation>: FormField<Type, Internal, Representation> {

  public init(_ name: String, value: Type) {
    super.init(name, value: value, options: [true, false], cellClass: FormCell.self)
    accessibilityLabel = name
  }

  // MARK: - FormElementProtocol

  public override func didSelect() {
    internalValue = true
  }

  // MARK: - FormDataProtocol

  // MARK: Options

  public override func didSetValue(#oldValue: Type?, newValue: Type?) {
    super.didSetValue(oldValue: oldValue, newValue: newValue)
    if error == nil {
      if let theValue = newValue as? Bool {
        if theValue == true {
          section?.didUpdate(field: self)
        }
      }
    }
  }

  // MARK: Value transformers

  public override func typeToInternal(value: Type?) -> Internal? {
    return value as? Internal
  }

  public override func internalToType(internalValue: Internal?) -> Type? {
    return internalValue as? Type
  }

  public override func typeToRepresentation(value: Type?) -> Representation? {
    return value as? Representation
  }

}
