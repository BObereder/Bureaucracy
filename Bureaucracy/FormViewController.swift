//
//  FormViewController.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import SwiftHelpers
import UIKit

public class FormViewController: UITableViewController, FormDelegate {

  public var dataSource: FormDataSource? {
    didSet {
      tableView.dataSource = dataSource
      dataSource?.register(tableView)
      dataSource?.form.delegate = self
      tableView.reloadData()
    }
  }

  // MARK: - FormDelegate

  public func didUpdateForm(form: Form, section: FormSection?, field: FormElement?) {
    Utility.mustOverride()
  }

  // MARK: - UITableViewDelegate

  public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    dataSource?.form.item(indexPath: indexPath).didSelect()
  }

}
