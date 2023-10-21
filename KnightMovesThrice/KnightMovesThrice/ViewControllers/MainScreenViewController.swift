//
//  ViewController.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var squares: [[ChessBoardSquare]] = []
    let columnsCount = 8
    let rowsCount = 8
    
    init() {
        super.init(nibName: "MainScreenViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSquares()
        self.setupCollectionView()
    }
    
    private func setUpSquares() {
        let columns = Array(repeating: ChessBoardSquare(), count: columnsCount)
        self.squares = Array(repeating: columns, count: rowsCount)
        
        for (indexRow, squareRow) in squares.enumerated() {
            for (indexColumn, squareColumn) in squareRow.enumerated() {
                if indexRow % 2 == 0 {
                    if indexColumn % 2 == 0 {
                        squareColumn.mode = .black
                    } else {
                        squareColumn.mode = .white
                    }
                } else {
                    if indexColumn % 2 == 0 {
                        squareColumn.mode = .white
                    } else {
                        squareColumn.mode = .black
                    }
                }
            }
        }
    }
    
    private func setupCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(
            UINib.init(
                nibName: ChessSquareCollectionViewCell.cellId,
                bundle: .main
            ),
            forCellWithReuseIdentifier: ChessSquareCollectionViewCell.cellId)
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.squares.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.squares[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let square = self.squares[indexPath.row][indexPath.section]
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChessSquareCollectionViewCell.cellId,
            for: indexPath
        ) as? ChessSquareCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.update(square: square, delegate: self)
        
        return cell
    }
    
}

extension MainScreenViewController: ChessSquareCollectionViewCellDelegate {
    func squaredTapped(_ square: ChessBoardSquare) {
        
        print(square)
    }
}

