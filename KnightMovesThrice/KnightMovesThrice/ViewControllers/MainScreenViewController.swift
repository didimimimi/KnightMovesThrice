//
//  ViewController.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var squares: Chessboard = []
    let boardSize = 8
    
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
        self.squares = ChessboardHelper().createChessboard(ofSize: self.boardSize)
    }
    
    private func setupCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            UINib.init(
                nibName: ChessSquareCollectionViewCell.cellId,
                bundle: .main
            ),
            forCellWithReuseIdentifier: ChessSquareCollectionViewCell.cellId)
        
        let layout = UICollectionViewFlowLayout()
        layout.collectionView?.delegate = self
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let deviceWidth = UIScreen.main.bounds.size.width
        let squareSize = floor(deviceWidth / CGFloat(self.squares.count))
        layout.itemSize = CGSize(width: squareSize, height: squareSize)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
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
        let square = self.squares[indexPath.section][indexPath.row]
        
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
    func squaredTapped(_ square: ChessboardSquare) {
        
        print(square.description)
    }
}

