////
////  SelectorFormSection.swift
////  Bureaucracy
////
////  Created by Bernhard Obereder on 28.10.14.
////  Copyright (c) 2014 Alexander Kolov. All rights reserved.
////
//
//import UIKit
//
//public class SelectorFormSection<Type, Internal, Representation>: FormSection, FormDataProtocol {
//  
//  public var showAccessoryIndicator: Bool
//  public var values: [Type] = []
//  public var value: Type? {
//    didSet {
//      if let realValue = value {
//        if let validatorError = validator?(realValue) {
//          error = validatorError
//        }
//      }
//    }
//  }
//  
//  public var representationValues: [Representation]? {
//    if let realTransformer = representationTransformer  {
//      return values.map(realTransformer)
//    }
//    return nil
//  }
//  
//  public var internalValue: Internal? {
//    didSet {
//      (value, error) = FormUtilities.convertInternalValue(internalValue, transformer: reverseValueTransformer, validator: validator)
//    }
//  }
//  
//  public var valueTransformer: ((Type) -> (Internal))? {
//    didSet {
//      internalValue = FormUtilities.convertValue(value, transformer: valueTransformer)
//    }
//  }
//  public var reverseValueTransformer: ((Internal) -> (Type))?
//  public var representationTransformer: ((Type) -> (Representation))?
//  public var validator: ((Type) -> (NSError?))?
//  public var error: NSError?
//  
//  public init(form: Form) {
//    super.init(form)
//  }
////
////  func createElements() {
////  
////    for v in values {
////      self.addElement(FormElement())
////    }
////  
////  }
//  
//}
