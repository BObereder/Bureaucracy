//
//  FormDataProtocol.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

protocol FormDataProtocol {
  
  typealias Type
  typealias Representation
  typealias Internal

  func option(index: Int) -> Type
  var optionCount: Int { get }

  var value: Type? { get set }
  var previousValue: Type? { get set }

  func representation(index: Int) -> Representation?

  var internalValue: Internal? { get set }
  
  var valueTransformer: Type -> Internal { get set }
  var reverseValueTransformer: Internal -> Type { get set }
  var representationTransformer: (Type -> Representation)? { get set }
  var validator: (Type -> NSError?)? { get set }
  var error: NSError? { get set }
  
}
