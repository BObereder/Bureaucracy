//
//  SelectorGroupFormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 6.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

typealias SelectorGroupFormField = _SelectorGroupFormField<Bool, Bool, Bool>

public class _SelectorGroupFormField<Type, Internal, Representation>: FormField<Type, Internal, Representation> {

  public typealias Type = Bool
  public typealias Internal = Bool
  public typealias Representation = Bool

  public init(_ name: String, value: Type, values: [Type]) {
    super.init(name, value: value, cellClass: FormCell.self)
    valueTransformer = { return $0 }
    reverseValueTransformer = { return $0 }
    representationTransformer = { return $0 }
    didSelect = { self.internalValue = true }
  }

}
