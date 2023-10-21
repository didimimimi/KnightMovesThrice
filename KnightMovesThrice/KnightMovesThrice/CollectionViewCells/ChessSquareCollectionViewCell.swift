//
//  ChessSquareCollectionViewCell.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import UIKit

protocol ChessSquareCollectionViewCellDelegate: AnyObject {
    func squaredTapped(_ square: ChessboardSquare)
}

class ChessSquareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var markerLabel: UILabel!
    
    private var square = ChessboardSquare()
    private weak var delegate: ChessSquareCollectionViewCellDelegate?
    static let cellId = "ChessSquareCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(square: ChessboardSquare, delegate: ChessSquareCollectionViewCellDelegate) {
        self.square = square
        self.delegate = delegate
        
        self.updateBasedOnSquareMode()
    }
    
    private func updateBasedOnSquareMode() {
        switch self.square.mode {
        case .knight:
            self.updateSquareUI(backgroundColor: .lightGray, markerText: "Knight", textColor: .black)
        case .goal:
            self.updateSquareUI(backgroundColor: .green, markerText: "Goal", textColor: .black)
        case .black:
            self.updateSquareUI(backgroundColor: .black, markerText: nil, textColor: .white)
        case .white:
            self.updateSquareUI(backgroundColor: .white, markerText: nil, textColor: .black)
        }
    }
    
    private func updateSquareUI(backgroundColor: UIColor, markerText: String?, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.markerLabel.text = markerText
        self.markerLabel.textColor = textColor
    }
    
    @IBAction func squaredTapped(_ sender: Any) {
        self.delegate?.squaredTapped(self.square)
    }
}
