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

  deinit {
    tableView.dataSource = nil
    tableView.delegate = nil
    form?.delegate = nil
  }

  public var dataSource: FormDataSource?

  public var form: Form? {
    didSet {
      if let form = form {
        form.delegate = self
        dataSource = dataSource(form)
        tableView.dataSource = dataSource
        dataSource?.register(tableView)
        tableView.reloadData()
      }
    }
  }

  public func dataSource(form: Form) -> FormDataSource {
    return BasicDataSource(form: form)
  }

  // MARK: - FormDelegate

  public func didUpdateForm(form: Form, section: FormSection?, field: FormElement?) {
    Utility.mustOverride()
  }

  // MARK: - UITableViewDelegate

  public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    form?.item(indexPath: indexPath).didSelect()
  }

}
