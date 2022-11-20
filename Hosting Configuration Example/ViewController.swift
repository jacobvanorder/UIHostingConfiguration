//
//  ViewController.swift
//  Hosting Configuration Example
//
//  Created by Jacob Van Order on 11/19/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    typealias CellRegistration = UICollectionView.CellRegistration<SymbolCell, String>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias CellProvider = DiffableDataSource.CellProvider
    
    let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: UICollectionViewLayout())
    lazy var diffableDataSource: DiffableDataSource = {
        return ViewController.dataSource(forCollectionView: self.collectionView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = type(of: self).composableLayout()
        self.collectionView.dataSource = self.diffableDataSource
        self.collectionView.frame = self.view.bounds
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        var snapshot = self.diffableDataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(symbols, toSection: 0)
        self.diffableDataSource.apply(snapshot)
    }
}

extension ViewController {
    static func composableLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    
    static func dataSource(forCollectionView collectionView: UICollectionView) -> DiffableDataSource {
        let registration = self.cellRegistration()
        return DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, symbolString in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: symbolString)
        }
    }
    
    static func cellRegistration() -> CellRegistration {
        return CellRegistration { cell, indexPath, symbolString in
            let state = UICellConfigurationState(traitCollection: cell.traitCollection)
            cell.load(symbolNameString: symbolString, state: state)
        }
    }
}

class SymbolCell: UICollectionViewCell {
    func load(symbolNameString: String, state: UICellConfigurationState) {
        self.contentConfiguration = UIHostingConfiguration(content: { SymbolCell.createCellContent(symbolNameString: symbolNameString, state: state)})
        
        self.configurationUpdateHandler = {(cell, updatedState) in
            cell.contentConfiguration = UIHostingConfiguration(content: { SymbolCell.createCellContent(symbolNameString: symbolNameString, state: updatedState) })
        }
    }
    
    @ViewBuilder static func createCellContent(symbolNameString: String, state: UICellConfigurationState) -> some View {
        HStack(spacing: 12.0) {
            Image(systemName: symbolNameString)
                .resizable()
                .scaledToFit()
                .frame(width: 44.0, height: 44.0)
                .foregroundColor(state.isSelected ? .red : .black)
            Text(symbolNameString)
                .font(.body)
                .foregroundColor(state.isSelected ? .red : .black)
            Spacer()
        }
    }
}

let symbols: [String] = ["square.and.arrow.up",
                         "square.and.arrow.up.fill",
                         "square.and.arrow.up.circle",
                         "square.and.arrow.up.circle.fill",
                         "square.and.arrow.up.trianglebadge.exclamationmark",
                         "square.and.arrow.down",
                         "square.and.arrow.down.fill",
                         "square.and.arrow.down.on.square",
                         "square.and.arrow.down.on.square.fill",
                         "rectangle.portrait.and.arrow.right",
                         "rectangle.portrait.and.arrow.right.fill",
                         "rectangle.portrait.and.arrow.forward",
                         "rectangle.portrait.and.arrow.forward.fill",
                         "pencil",
                         "pencil.slash",
                         "pencil.line",
                         "eraser",
                         "eraser.fill",
                         "eraser.line.dashed",
                         "eraser.line.dashed.fill",
                         "square.and.pencil",
                         "rectangle.and.pencil.and.ellipsis",
                         "scribble",
                         "scribble.variable",
                         "highlighter",
                         "pencil.and.outline",
                         "pencil.tip",
                         "pencil.tip.crop.circle",
                         "pencil.tip.crop.circle.badge.arrow.forward",
                         "lasso",
                         "lasso.and.sparkles",
                         "trash",
                         "trash.fill",
                         "trash.circle",
                         "trash.circle.fill",
                         "trash.slash",
                         "trash.slash.fill",
                         "trash.slash.circle",
                         "trash.slash.circle.fill",
                         "trash.slash.square",
                         "trash.slash.square.fill",
                         "folder"]

