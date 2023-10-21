//
//  ViewController.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var boardSizeSlider: UISlider!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    var chessboard = Chessboard()
    var mode = ChessboardSquareMode.knight
    init() {
        super.init(nibName: "MainScreenViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.setupCollectionViewFlowLayout()
        self.setupSlider()
        self.setupSwitch()
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
    }
    
    private func setupCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupSlider() {
        self.boardSizeSlider.isContinuous = true
        self.boardSizeSlider.value = Float(self.chessboard.size)
    }
    
    private func setupSwitch() {
        self.modeSwitch.isOn = false
        self.modeSwitch.backgroundColor = .lightGray
        self.modeSwitch.onTintColor = .green
        self.modeSwitch.layer.cornerRadius = 16
    }

    @IBAction func sliderMoved(_ sender: UISlider) {
        let roundedValue = lroundf(self.boardSizeSlider.value)
        sender.setValue(Float(roundedValue), animated: true)
        
        self.chessboard.size = roundedValue
        self.collectionView.reloadData()
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        self.mode = sender.isOn ? .goal : .knight
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.chessboard.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chessboard.board[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let square = self.chessboard.board[indexPath.section][indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChessSquareCollectionViewCell.cellId,
            for: indexPath
        ) as? ChessSquareCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.update(square: square, delegate: self)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.size.width
        
        let squareSize = floor(deviceWidth / CGFloat(self.chessboard.size))
        return CGSize(width: squareSize, height:squareSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MainScreenViewController: ChessSquareCollectionViewCellDelegate {
    func squaredTapped(_ square: ChessboardSquare) {
        square.mode = self.mode
        
        UIView.performWithoutAnimation {
            self.collectionView.reloadItems(at: [IndexPath(item: square.position.column, section: square.position.row)])
        }
    }
}

