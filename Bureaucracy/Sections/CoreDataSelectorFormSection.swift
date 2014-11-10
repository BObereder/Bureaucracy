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

public class CoreDataSelectorFormSection<Type: AnyObject>: FormSection, NSFetchedResultsControllerDelegate {

  public typealias Internal = Int
  public typealias Representation = String

  public init(_ name: String, fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext) {
    self.fetchRequest = fetchRequest
    self.managedObjectContext = managedObjectContext
    super.init(name)
  }

  // MARK: FormSection

  public var value: Type?

  public override func item(index: Int) -> FormElement {
    if (index == items.count) {
      let indexPath = NSIndexPath(forItem: index, inSection: 0)
      let object: Type = fetchedResultsController.objectAtIndexPath(indexPath) as Type
      let element = SelectorGroupFormField("\(name).\(index)", value: value == nil ? false : object === value!)
      let field = append(element)
      field.localizedTitle = representationTransformer?(object)
      return field
    }

    return items[index]
  }

  public override var count: Int {
    if let section: NSFetchedResultsSectionInfo = fetchedResultsController.sections?.first as? NSFetchedResultsSectionInfo {
      return section.numberOfObjects
    }
    return 0
  }

  public var representationTransformer: ((Type) -> (Representation))?

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
