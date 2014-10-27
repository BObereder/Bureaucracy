//
//  FormField.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 22.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormField<Type, Internal, Representation>: FormElement {

  public init(cellClass: AnyClass, value: Type) {
    self.value = value
    super.init(cellClass: cellClass)
    internalValue = valueTransformer?(value)
  }
  
//  public init(cellClass: AnyClass, value: Type, valueTransformer: (Type) -> (Internal), reverseValueTransformer: (Internal) -> (Type)) {
//    self.value = value
//    super.init(cellClass:cellClass)
//    self.valueTransformer = valueTransformer
//    self.reverseValueTransformer = reverseValueTransformer
//    internalValue = valueTransformer(value)
//  }

  public var values: [Type] = []
  public var value: Type? {
    didSet {
      error = validator(value!)
    }
  }

  public var representationValues: [Representation]? {
    if let realTransformer = representationTransformer  {
      return values.map(realTransformer)
    }
    return nil
  }

  public var internalValue: Internal? {
    didSet {
      
      if let reversed = reverseValueTransformer?(internalValue!) {
        error = validator(reversed)
        if error == nil {
          value = reversed
        }
      }
    }
  }

  public var valueTransformer: ((Type) -> (Internal))? = { (var t) -> (Internal) in return t as Internal } {
    didSet {
      if let realValue = value {
        internalValue = valueTransformer?(realValue)
      }
    }
  }
  public var reverseValueTransformer: ((Internal) -> (Type))? = { (var i) -> (Type) in return i as Type } 
  public var representationTransformer: ((Type) -> (Representation))? = { (var t) -> (Representation) in return t as Representation }
  public var validator: (Type) -> (NSError?) = { (var t) -> (NSError?) in return nil }
  public var error: NSError?
  
  public override func description() -> String {
    return "FormField"
  }
  
}
