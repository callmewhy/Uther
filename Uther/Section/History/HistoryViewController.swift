//
//  HistoryViewController.swift
//  Uther
//
//  Created by why on 8/2/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import Async

class HistoryViewController: UIViewController {
    let dataSource = HistoryDataSource()
    fileprivate var isLoading = false
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 44.0;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = dataSource.loadFromDatabase()
    }

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true) {}
    }
}

// MARK: - Private
extension HistoryViewController {
    func setupHeaderMask() {
        guard var v = tableView.indexPathsForVisibleRows else {
            return
        }
        if let first = v.first {
            if first.row > 0 {
                v.append(IndexPath(row: first.row - 1, section: first.section))
            }
        }

        for i in v {
            let headerHeight = tableView.delegate!.tableView!(tableView, heightForHeaderInSection: i.section)
            let cell = tableView.dataSource!.tableView(tableView, cellForRowAt: i)
            let height = tableView.contentOffset.y + headerHeight - cell.frame.origin.y;
            if (height > 0 && height < cell.height) {
                let maskLayer = CAShapeLayer()
                maskLayer.path = CGPath(rect: CGRect(x: 0, y: height, width: cell.width, height: cell.height - height), transform: nil)
                cell.layer.mask = maskLayer
            } else if height < 0 {
                cell.layer.mask = nil
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = tableView.delegate!.tableView!(tableView, heightForHeaderInSection: section)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: height))
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        let label = UILabel(frame: view.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = dataSource.tableView(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor(hexString: "f5f5f5", alpha: 0.5)
        view.addSubview(label)
        return view
    }
}


// MARK: - UIScrollViewDelegate
extension HistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.setupHeaderMask()
        if isLoading {
            return
        }
        let contentHeight = tableView.contentSize.height
        if tableView.contentOffset.y + tableView.height > contentHeight {
            isLoading = true
            Async.background {
                let count = self.dataSource.loadFromDatabase()
                if count == 0 {
                    return
                }
                Async.main {
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    self.isLoading = false
                }
            }
        }
    }
}
