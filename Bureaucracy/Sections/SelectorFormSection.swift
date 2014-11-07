//
//  SelectorFormSection.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 28.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class SelectorFormSection<Type: protocol<Equatable, Printable>>: FormSection, FormDataProtocol {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, value: Type, values: [Type]) {
    self.values = values
    super.init(name)
    internalValue = valueTransformer?(value)

    valueTransformer = { (var x) -> Internal in return find(values, x)! }
    reverseValueTransformer = { (var idx) -> Type in return values[idx] }
    representationTransformer = { (var x) -> Representation in
      if let theRepresentation = self.representation {
        if let idx = find(values, x) {
          return theRepresentation[idx]
        }
      }
      return "\(x)"
    }

    for i in 0..<values.count {
      var x = values[i]
      let field = append(SelectorGroupFormField("\(name).\(i)", value: x == value))
      field.localizedTitle = representationTransformer?(x)
    }
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

  public var representation: [Representation]?

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

  // MARK: FormSection

  public override func didUpdate(#item: FormElement) {
    for aItem in items {
      if item !== aItem {
        if let theItem = aItem as? SelectorGroupFormField {
          theItem.value = false
        }
      }
    }

    form?.didUpdate(section: self, item: item)
  }

}
