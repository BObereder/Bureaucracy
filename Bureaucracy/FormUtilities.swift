//
//  FormUtilities.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

class FormUtilities {
  class func convertInternalValue<Type, Internal>(value: Internal?, transformer: ((Internal) -> (Type))?, validator: ((Type) -> (NSError?))?) -> (value: Type?, error: NSError?) {
    
    var returnValue: Type?
    var error: NSError?
    
    if let realInternalValue = value {
      if let reversed = transformer?(realInternalValue) {
        if let validatorError = validator?(reversed) {
          error = validatorError
        }
        if error == nil {
          returnValue = reversed
        }
      }
    }
    return (returnValue, error)
  }
  
  class func convertValue<Type, Internal>(value: Type?, transformer: ((Type) -> (Internal))?) -> Internal? {
    if let realValue = value {
      return transformer?(realValue)
    }
    return nil
  }
  
  class func validateValue<Type>(value: Type?, validator: ((Type) -> (NSError?))?) -> NSError? {
    if let realValue = value {
      return validator?(realValue)
    }
    return nil
  }
  
  class func convertToRepresenationValues<Type, Representation>(values: [Type], representationTransformer: ((Type) -> (Representation))?) -> [Representation]? {
    if let realTransformer = representationTransformer  {
      return values.map(realTransformer)
    }
    return nil
  }
  
}