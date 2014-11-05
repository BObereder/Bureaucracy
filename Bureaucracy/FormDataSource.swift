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

  var form: Form

  public init(form: Form) {
    self.form = form
    super.init()
  }

  func registerReusableViews(tableView: UITableView) {
    SwiftHelpers.each(form) { (var section) in
      SwiftHelpers.each(section) { (var item) in
        item.registerReusableView(tableView)
      }
    }
  }

  // MARK: - UITableViewDataSource

  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return form.sections.count
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return form.sections[section].count
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let field = form.item(indexPath: indexPath)
    return field.dequeueReusableView(tableView, forIndexPath: indexPath)
  }

}
