//
//  TokenSelectorFormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 19.12.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class TokenSelectorFormSection<Type: protocol<Equatable, Printable>>: SelectorFormSection<Type> {

  public typealias Internal = Int
  public typealias Representation = String
  public typealias Field = TokenSelectorGroupFormField<Type, Type>

  public override init(_ name: String, value: Type?, options: [Type]) {
    super.init(name, value: value, options: options)
  }

  // MARK: - CollectionType

  public override subscript(position: Int) -> FormElement {
    if position == endIndex {
      let object = option(position) as Type
      let value: Type? = object == currentValue ? object : nil
      let element = append(Field("\(name).\(position)", value: value, options: [object]))
      element.localizedTitle = typeToRepresentation(object)
      return element
    }
    else {
      return super[position]
    }
  }

  // MARK: - Values

  public override var currentValue: Type? {
    set {
      error = validate(newValue)
      if error == nil && newValue != _currentValue {
        previousValue = _currentValue
        _currentValue = newValue

        for x in self {
          if newValue != nil && x.fieldIndex == optionIndex(newValue!) {
            (x as? Field)?.currentValue = newValue
            continue
          }
          (x as? Field)?.currentValue = nil
        }
      }
    }
    get {
      return _currentValue
    }
  }

  public override func didSetInternalValue() {
    let field = filter(self) { return ($0 as? Field)?.currentValue == self.currentValue }
    form?.didUpdate(section: self, field: field.first)
  }

  // MARK: - Callbacks

  public override func didUpdate(#field: FormElement?) {
    for x in self {
      if field == x {
        internalValue = field?.fieldIndex
      }
      else {
        (x as? Field)?.currentValue = nil
      }
    }
  }

}
