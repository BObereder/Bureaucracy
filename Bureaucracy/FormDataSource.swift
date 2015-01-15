//
//  FormDataSource.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit
import SwiftHelpers

public protocol FormDataSource: UITableViewDataSource {

  init(form: Form)

  func register(tableView: UITableView)
  func reloadTable()
  func reloadSection(section: Int, withRowAnimation animation: UITableViewRowAnimation)
  func reloadRow(row: NSIndexPath, withRowAnimation animation: UITableViewRowAnimation)

}

public class BasicDataSource: NSObject, FormDataSource {

  public required init(form: Form) {
    self.form = form
    super.init()
    form.dataSource = self
  }
  
  public var form: Form
  weak var tableView: UITableView?

  public func register(tableView: UITableView) {
    self.tableView = tableView
    form.register(tableView)
  }

  public func reloadTable() {
    if let tableView = tableView {
      register(tableView)
      tableView.reloadData()
    }
  }

  public func reloadSection(section: Int, withRowAnimation animation: UITableViewRowAnimation = .Automatic) {
    tableView?.reloadSections(NSIndexSet(index: section), withRowAnimation: animation)
  }

  public func reloadRow(row: NSIndexPath, withRowAnimation animation: UITableViewRowAnimation = .Automatic) {
    tableView?.reloadRowsAtIndexPaths([row], withRowAnimation: animation)
  }

  // MARK: - UITableViewDataSource

  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return form.numberOfSections
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return form.sections[section].count
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let field = form.item(indexPath: indexPath)
    return field.dequeueReusableView(tableView, forIndexPath: indexPath)
  }

  public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return form[section].localizedTitle
  }

}
