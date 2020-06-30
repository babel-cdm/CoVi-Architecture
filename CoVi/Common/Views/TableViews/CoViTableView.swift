//
//  CoViTableView.swift
//  ViperArchitecture
//
//  Created by Jorge Guilabert Ibáñez on 06/02/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

/**
 CoVi base table view.
 */
open class CoViTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    public typealias CellConfigurator = (UITableView, IndexPath) -> UITableViewCell

    @objc(CellEditingStyle)
    public enum CellEditingStyle: Int {
        case none = 0
        case delete = 1
        case insert = 2
    }

    // MARK: - Properties

    /// Preserve the row selection when `reloadData()` function is called.
    public var preserveRowsSelected = false

    private weak var tableViewDataSource: CoViTableViewDataSource?
    private weak var tableViewDelegate: CoViTableViewDelegate?
    private var cellForRowAtConfigurator: CellConfigurator?

    // MARK: - Functions

    /**
     Function to set the data source of table view.

     The data source must adopt the `CoViTableViewDataSource` protocol. The data source is not retained.

     - Parameter dataSource: The object that acts as the data source of the table view.
     */
    public func setupDataSource(_ dataSource: CoViTableViewDataSource?) {
        self.dataSource = self
        self.tableViewDataSource = dataSource
    }

    /**
     Function to set the delegate of table view.

     The delegate must adopt the `CoViTableViewDataSource` protocol. The delegate is not retained.

     - Parameter delegate: The object that acts as the delegate of the table view.
     */
    public func setupDelegate(_ delegate: CoViTableViewDelegate?) {
        self.delegate = self
        self.tableViewDelegate = delegate
    }

    /**
     Reload data of table view.

     - Parameter cellForRowAtConfigurator: Completion handler to bind the 'cellForRowAt' event of data source.
     */
    open func reloadData(cellForRowAtConfigurator: @escaping CellConfigurator) {
        self.cellForRowAtConfigurator = cellForRowAtConfigurator

        var indexPathsSelected = [IndexPath]()
        if preserveRowsSelected, let indexPathsForSelectedRows = indexPathsForSelectedRows {
            indexPathsSelected = indexPathsForSelectedRows
        }

        self.reloadData()

        indexPathsSelected.forEach { selectRow(at: $0, animated: false, scrollPosition: .none) }
    }

    // MARK: - UITableViewDataSource

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.numberOfRowsInSection(tableView.tag, section) ?? 0
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        if let numberOfSections = tableViewDataSource?.numberOfSections {
            return numberOfSections(tableView.tag)
        }
        return 1
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let cellForRowAtConfigurator = cellForRowAtConfigurator {
            cell = cellForRowAtConfigurator(tableView, indexPath)

            /// Set disclosure indicator color
            if let coviCell = cell as? CoViTableViewCell,
                let disclosureIndicatorColor = coviCell.disclosureIndicatorColor {
                if cell.accessoryType == .disclosureIndicator || cell.accessoryType == .detailDisclosureButton {
                    if let imageView = cell.subviews.last?.subviews.first as? UIImageView {
                        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                        imageView.tintColor = disclosureIndicatorColor
                    }
                }
            }
        } else {
            cell = UITableViewCell()
        }

        return cell
    }

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let canEditRowAt = tableViewDataSource?.canEditRowAt {
            return canEditRowAt(tableView.tag, indexPath)
        }
        return false
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let canMoveRowAt = tableViewDataSource?.canMoveRowAt {
            return canMoveRowAt(tableView.tag, indexPath)
        }
        return false
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let commit = tableViewDataSource?.commit {
            let cellEditingStyle: CellEditingStyle
            switch editingStyle {
            case .delete:
                cellEditingStyle = .delete
            case .insert:
                cellEditingStyle = .insert
            default:
                cellEditingStyle = .none
            }

            commit(tableView.tag, cellEditingStyle, indexPath)
        }
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let moveRowAt = tableViewDataSource?.moveRowAt {
            moveRowAt(tableView.tag, sourceIndexPath, destinationIndexPath)
        }
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let titleForHeaderInSection = tableViewDataSource?.titleForHeaderInSection {
            return titleForHeaderInSection(tableView.tag, section)
        }
        return nil
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let titleForFooterInSection = tableViewDataSource?.titleForFooterInSection {
            return titleForFooterInSection(tableView.tag, section)
        }
        return nil
    }

    // MARK: - UITableViewDelegate

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let heightForRowAt = tableViewDelegate?.heightForRowAt {
            return CGFloat(heightForRowAt(tableView.tag, indexPath))
        }
        return UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let estimatedHeightForRowAt = tableViewDelegate?.estimatedHeightForRowAt {
            return CGFloat(estimatedHeightForRowAt(tableView.tag, indexPath))
        }
        return UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectRowAt = tableViewDelegate?.didSelectRowAt {
            didSelectRowAt(tableView.tag, indexPath)
        }
    }

    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let didDeselectRowAt = tableViewDelegate?.didDeselectRowAt {
            didDeselectRowAt(tableView.tag, indexPath)
        }
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let willDisplay = tableViewDelegate?.willDisplay {
            willDisplay(tableView.tag, indexPath)
        }
    }

    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let shouldHighlightRowAt = tableViewDelegate?.shouldHighlightRowAt {
            return shouldHighlightRowAt(tableView.tag, indexPath)
        }
        return true
    }

    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let didHighlightRowAt = tableViewDelegate?.didHighlightRowAt {
            didHighlightRowAt(tableView.tag, indexPath)
        }

        /// Set highlight color
        if let coviCell = tableView.cellForRow(at: indexPath) as? CoViTableViewCell,
            let highlightColor = coviCell.highlightColor {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = highlightColor

            if coviCell.selectedBackgroundView != nil {
                coviCell.selectedBackgroundView?.addSubview(childView: selectedBackgroundView,
                                                        constraintType: .container)
            } else {
                coviCell.insertSubview(childView: selectedBackgroundView,
                                   at: 0,
                                   constraintType: .container)
            }
        }
    }

    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let didUnhighlightRowAt = tableViewDelegate?.didUnhighlightRowAt {
            didUnhighlightRowAt(tableView.tag, indexPath)
        }

        /// Remove highlight color
        if let coviCell = tableView.cellForRow(at: indexPath) as? CoViTableViewCell,
            let _ = coviCell.highlightColor {
            if coviCell.selectedBackgroundView != nil {
                coviCell.setSelected(coviCell.isSelected, animated: true)
            } else {
                coviCell.subviews.first?.removeFromSuperview()
            }
        }
    }

}
