//
//  FormDataSource.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit
import SwiftHelpers

public class FormDataSource: NSObject, UITableViewDataSource {

  public init(form: Form) {
    self.form = form
    super.init()
    form.dataSource = self
  }
  
  public var form: Form
  weak var tableView: UITableView?

  func register(tableView: UITableView) {
    self.tableView = tableView

    for section in form {
      for field in section {
        field.registerReusableView(tableView)
      }
    }
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

}
