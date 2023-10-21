//
//  ViewController.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import UIKit

class ChessboardMainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var boardSizeSlider: UISlider!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var findPathButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private var viewModel = ChessboardMainViewModel()
    
    var chessboard = Chessboard(size: 2)
    
    init() {
        super.init(nibName: "ChessboardMainViewController", bundle: .main)
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
        self.setupButtons()
        self.setupViewModel()
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
    
    private func setupButtons() {
        self.findPathButton.backgroundColor = .blue
        self.findPathButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        self.findPathButton.layer.cornerRadius = 8
        
        self.resetButton.backgroundColor = .clear
        self.resetButton.layer.borderColor = UIColor.red.cgColor
        self.resetButton.tintColor = .red
        self.resetButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        self.resetButton.layer.cornerRadius = 8
        self.resetButton.layer.borderWidth = 1
        
        self.resetButton.setNeedsLayout()
    }
    
    private func setupViewModel() {
        self.viewModel = ChessboardMainViewModel(delegate: self)
    }

    @IBAction func sliderMoved(_ sender: UISlider) {
        self.viewModel.sliderDragged(to: sender.value)
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        self.viewModel.switchToogled(to: sender.isOn)
    }
    
    @IBAction func findPathButtonTapped(_ sender: Any) {
        self.viewModel.findPathButtonTapped()
    }
    
    
    @IBAction func resetBoardButtonTapped(_ sender: Any) {
        self.viewModel.resetButtonTapped()
    }
}

extension ChessboardMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension ChessboardMainViewController: ChessSquareCollectionViewCellDelegate {
    func squaredTapped(_ square: ChessboardSquare) {
        self.viewModel.squareTapped(square: square)
    }
}

extension ChessboardMainViewController: ChessboardMainViewModelDelegate {
    func update(state: ChessboardMainStates) {
        switch state {
        case .newChessboardState(let chessboard):
            self.handleNewChessboardState(chessboard: chessboard)
        case .sliderValueChangedState(let value):
            self.handleSliderValueChangedState(value: value)
        case .newSquareState(let newSquare, let oldSquare):
            self.handleNewSquareState(newSquare: newSquare, oldSquare: oldSquare)
        case .drawPathState:
            self.handleDrawPathState()
        case .dummyState:
            break
        }
    }
    
    private func handleNewChessboardState(chessboard: Chessboard) {
        self.chessboard = chessboard
        self.collectionView.reloadData()
    }
    
    private func handleSliderValueChangedState(value: Float) {
        self.boardSizeSlider.setValue(value, animated: true)
    }
    
    private func handleNewSquareState(newSquare: ChessboardSquare, oldSquare: ChessboardSquare) {
        UIView.performWithoutAnimation {
            self.collectionView.reloadItems(at: [
                IndexPath(item: newSquare.position.column, section: newSquare.position.row),
                IndexPath(item: oldSquare.position.column, section: oldSquare.position.row)
            ])
        }
    }
    
    private func handleDrawPathState() {
        
    }
}

