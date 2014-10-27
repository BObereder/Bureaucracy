//
//  FormDataSource.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import SwiftHelpers
import UIKit

public class FormDataSource: NSObject, UITableViewDataSource {

  var form: Form

  public init(form: Form) {
    self.form = form
    super.init()
  }

  func registerReusableViews(tableView: UITableView) {
    for section in form.sections {
      for field in section.elements {
        field.registerReusableView(tableView)
      }
    }
  }

  // MARK: - UITableViewDataSource

  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return form.sections.count
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return form.sections[section].numberOfFields()
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let field = form.sections[indexPath.section].elements[indexPath.row]
    return field.dequeueReusableView(tableView, forIndexPath: indexPath)
  }

}
