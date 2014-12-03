//
//  CoreDataSelectorFormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 10.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import CoreData
import Foundation
import SwiftHelpers
import UIKit

public func ==<Type: NSManagedObject>(lhs: CoreDataSelectorFormSection<Type>, rhs: CoreDataSelectorFormSection<Type>) -> Bool {
  return lhs === rhs
}

public class CoreDataSelectorFormSection<Type: NSManagedObject>: FormSection, FormDataProtocol, NSFetchedResultsControllerDelegate {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, value: Type?, fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext) {
    self.fetchRequest = fetchRequest
    self.managedObjectContext = managedObjectContext
    super.init(name)
    currentValue = value
    initialValue = value
  }

  // MARK: - Fields

  public override var count: Int {
    if let section = fetchedResultsController.sections?[0] as? NSFetchedResultsSectionInfo {
      return section.numberOfObjects
    }
    else {
      return 0
    }
  }

  // MARK: - CollectionType

  public override subscript(position: Int) -> FormElement {
    if (position == endIndex) {
      let object = option(position)
      let element = append(SelectorGroupFormField("\(name).\(position)", value: object == currentValue))
      element.localizedTitle = typeToRepresentation(object)
      return element
    }
    else {
      return super[position]
    }
  }

  // MARK: - Options

  public func option(position: Int) -> Type {
    let indexPath = NSIndexPath(forItem: position, inSection: 0)
    return fetchedResultsController.objectAtIndexPath(indexPath) as Type
  }

  public func optionIndex(option: Type) -> Int {
    if let indexPath = fetchedResultsController.indexPathForObject(option) {
      return indexPath.item
    }
    return NSNotFound
  }

  public var optionCount: Int {
    if let section: NSFetchedResultsSectionInfo = fetchedResultsController.sections?.first as? NSFetchedResultsSectionInfo {
      return section.numberOfObjects
    }
    else {
      return 0
    }
  }

  // MARK: - Values

  var initialValue: Type?

  private var _currentValue: Type?

  public final var currentValue: Type? {
    set {
      error = validate(newValue)
      if error == nil {
        previousValue = _currentValue
        _currentValue = newValue

        for x in self {
          if newValue != nil && x.fieldIndex == optionIndex(newValue!) {
            (x as? SelectorGroupFormField)?.currentValue = true
            continue
          }
          (x as? SelectorGroupFormField)?.currentValue = false
        }
      }
    }
    get {
      return _currentValue
    }
  }

  public var previousValue: Type?

  public var internalValue: Internal? {
    get {
      return typeToInternal(currentValue)
    }
    set(newOption) {
      currentValue = internalToType(newOption)
      if error == nil && currentValue != previousValue {
        didSetInternalValue()
      }
    }
  }

  public func didSetInternalValue() {
    let field = filter(self) { return ($0 as? SelectorGroupFormField)?.currentValue == true }
    form?.didUpdate(section: self, field: field.first)
  }

  // MARK: - Value transformers

  public func typeToInternal(value: Type?) -> Internal? {
    if value == nil {
      return nil
    }
    else {
      return optionIndex(value!)
    }
  }

  public func internalToType(internalValue: Internal?) -> Type? {
    if internalValue == nil {
      return nil
    }
    else {
      return self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forItem: internalValue!, inSection: 0)) as? Type
    }
  }

  public func typeToRepresentation(value: Type?) -> Representation? {
    return value?.description
  }

  // MARK: - Validators

  public func validate(value: Type?) -> NSError? {
    return nil
  }

  public var error: NSError?

  // MARK: - Serialization

  public override func serialize() -> [String: Any?] {
    return [name: currentValue]
  }

  // MARK: Reset

  public override func reset() {
    currentValue = initialValue
  }

  // MARK: - Callbacks

  public override func didUpdate(#field: FormElement?) {
    for x in self {
      if field == x {
        internalValue = field?.fieldIndex
      }
      else {
        (x as? SelectorGroupFormField)?.currentValue = false
      }
    }
  }

  // MARK: - CoreData

  var fetchRequest: NSFetchRequest

  var managedObjectContext: NSManagedObjectContext

  lazy var fetchedResultsController: NSFetchedResultsController = {
    let controller = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: self.name)
    controller.delegate = self
    controller.performFetch(&self.error)
    return controller
  }()

  public func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.removeAll()
    form?.reloadForm()
  }

}
