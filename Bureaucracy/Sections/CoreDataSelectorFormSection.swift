//
//  CoreDataSelectorFormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 10.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import UIKit
import SwiftHelpers
import CoreData

public class CoreDataSelectorFormSection<Type: AnyObject>: FormSection, FormDataProtocol, NSFetchedResultsControllerDelegate {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext) {
    self.fetchRequest = fetchRequest
    self.managedObjectContext = managedObjectContext
    super.init(name)
  }

  // MARK: FormDataProtocol

  func option(index: Int) -> Type {
    let indexPath = NSIndexPath(forItem: index, inSection: 0)
    return fetchedResultsController.objectAtIndexPath(indexPath) as Type
  }

  var optionCount: Int {
    if let section: NSFetchedResultsSectionInfo = fetchedResultsController.sections?.first as? NSFetchedResultsSectionInfo {
      return section.numberOfObjects
    }
    return 0
  }

  public var value: Type?

  var previousValue: Type?

  var internalValue: Internal? {
    get {
      return FormUtilities.convertValue(value, transformer: valueTransformer)
    }
    set {
      (value, error) = FormUtilities.convertInternalValue(internalValue, transformer: reverseValueTransformer, validator: validator)
    }
  }

  lazy var valueTransformer: Type -> Internal = {
    return self.fetchedResultsController.indexPathForObject($0)!.item
  }

  lazy var reverseValueTransformer: Internal -> Type = {
    return self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forItem: $0, inSection: 0)) as Type
  }

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

  public var representationTransformer: (Type -> Representation)?
  public var validator: (Type -> NSError?)?
  public var error: NSError?

  // MARK: FormSection

  public override func item(index: Int) -> FormElement {
    if (index == items.count) {
      let object: Type = option(index)
      let element = SelectorGroupFormField("\(name).\(index)", value: value == nil ? false : object === value!)
      let field = append(element)
      field.localizedTitle = representationTransformer?(object)
      return field
    }

    return items[index]
  }

  public override var count: Int {
    return optionCount
  }

  // MARK: CoreData

  var fetchRequest: NSFetchRequest

  var managedObjectContext: NSManagedObjectContext

  lazy var fetchedResultsController: NSFetchedResultsController = {
    let controller = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: self.name)
    controller.delegate = self

    var error: NSError?
    if !controller.performFetch(&error) {
      println("\(error?.localizedDescription)")
    }

    return controller
  }()

  public func controllerDidChangeContent(controller: NSFetchedResultsController) {
    items.removeAll(keepCapacity: false)
    form?.reloadInterface()
  }

}
