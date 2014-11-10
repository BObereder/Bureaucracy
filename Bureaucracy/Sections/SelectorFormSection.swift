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

  public init(_ name: String, value: Type, options: [Type]) {
    valueTransformer = { return find(options, $0)! }
    reverseValueTransformer = { return options[$0] }

    super.init(name)

    self.options = options
    self.value = value
    internalValue = valueTransformer(value)

    representationTransformer = { (var x) -> Representation in
      return "\(x)"
    }

    for i in 0..<options.count {
      var x = options[i]
      let field = append(SelectorGroupFormField("\(name).\(i)", value: x == value))
      field.localizedTitle = representationTransformer?(x)
    }
  }
  
  // MARK: FormDataProtocol

  var options: [Type] = []

  func option(index: Int) -> Type {
    return options[index]
  }

  var optionCount: Int {
    return options.count
  }

  public var value: Type? {
    didSet {
      if previousValue != value {
        didSetValue(oldValue: oldValue, newValue: value)
      }
    }
  }

  var previousValue: Type?

  var internalValue: Internal? {
    get {
      return FormUtilities.convertValue(value, transformer: valueTransformer)
    }
    set {
      (value, error) = FormUtilities.convertInternalValue(internalValue, transformer: reverseValueTransformer, validator: validator)
    }
  }

  var valueTransformer: Type -> Internal
  var reverseValueTransformer: Internal -> Type

  func didSetValue(#oldValue: Type?, newValue: Type?) {
    error = FormUtilities.validateValue(newValue, validator: validator)
    if error != nil {
      previousValue = oldValue
      value = oldValue
    }
  }

  func representation(index: Int) -> Representation? {
    return representationTransformer?(option(index))
  }

  public var representationTransformer: ((Type) -> (Representation))?

  public var validator: ((Type) -> (NSError?))?
  public var error: NSError?

  public override func serialize() -> [String: Any?] {
    return [name: value]
  }

  // MARK: FormSection

  public override func didUpdate(#item: FormElement?) {
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
