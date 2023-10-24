//
//  NewViewController.swift
//  WordHunt
//
//  Created by Neosoft on 08/09/23.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var answerLbl: PaddingLabel!
    @IBOutlet weak var collView: UICollectionView!
    
    let chars = ["A","B","C","D","E","F","G","H","I","J"]
    var selectedIndexPaths: [IndexPath] = []
    var processedIndexPaths: Set<IndexPath> = []
    
    var answer = ""{
        didSet{
            answerLbl.text = answer
        }
    }
    
//    hello
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0){
            self.collView.collectionViewLayout = CircularCollectionViewLayout(cellSize: CGSize(width: 50, height: 50))
            self.collView.isHidden = false
        }
//        collView.layer.cornerRadius = 100
        collView.register(UINib(nibName: "NewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewCollectionViewCell")
        collView.dataSource = self
        collView.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        collView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: collView)
        
        switch gesture.state {
        case .began:
            processedIndexPaths.removeAll() // Reset the processed index paths when a new gesture begins
            
            // Find the indexPath of the cell at the swipe location
            if let indexPath = collView.indexPathForItem(at: location) {
                // Select the cell at the indexPath
                collView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                let cell = collView.cellForItem(at: indexPath) as? NewCollectionViewCell
                cell?.backgroundColor = .green
                answer += (cell?.alphabetLbl.text)!
                processedIndexPaths.insert(indexPath)
            }
        case .changed:
            if let indexPath = collView.indexPathForItem(at: location) {
                if processedIndexPaths.contains(indexPath) {
                    return
                }
                collView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                let cell = collView.cellForItem(at: indexPath) as? NewCollectionViewCell
                answer += (cell?.alphabetLbl.text)!
                cell?.backgroundColor = .green
                processedIndexPaths.insert(indexPath)
            }
        case .ended, .cancelled:
            // Deselect all the cells when the swipe ends or gets cancelled
            for indexPath in processedIndexPaths {
                collView.deselectItem(at: indexPath, animated: true)
                let cell = collView.cellForItem(at: indexPath) as? NewCollectionViewCell
                cell?.backgroundColor = .white // Revert the cell to its normal state
            }
            answer = ""
            processedIndexPaths.removeAll()
        default:
            break
        }
    }

}

extension NewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewCollectionViewCell", for: indexPath) as! NewCollectionViewCell
        cell.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            cell.layer.cornerRadius = cell.frame.height/2
            cell.alphabetLbl.text = self.chars[indexPath.row]
        }
        return cell
    }
    
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    private var itemSize: CGSize = CGSize(width: 50, height: 50)
    private var center: CGPoint = .zero
    private var radius: CGFloat = 100
    private var cellCount: Int = 0
    private var attributesCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    init(cellSize:CGSize){
        super.init()
        self.itemSize = cellSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
//            itemSize = CGSize(width: 200, height: 200)
            radius = min(collectionView.bounds.width, collectionView.bounds.height) / 3
        } else {
//            itemSize = CGSize(width: 70, height: 70)
            radius = min(collectionView.bounds.width, collectionView.bounds.height) / 2.8
        }
        collectionView.layer.cornerRadius = collectionView.frame.height/2
        center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        cellCount = collectionView.numberOfItems(inSection: 0)
        attributesCache.removeAll()

        let angleStep: CGFloat = (2 * CGFloat.pi) / CGFloat(cellCount)
        for item in 0..<cellCount {
            let indexPath = IndexPath(item: item, section: 0)
            let angle = CGFloat(item) * angleStep
            let xPosition = center.x + radius * cos(angle) - itemSize.width / 2
            let yPosition = center.y + radius * sin(angle) - itemSize.height / 2
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xPosition, y: yPosition, width: itemSize.width, height: itemSize.height)
            attributesCache[indexPath] = attributes
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []

        for (_, attributes) in attributesCache {
            if rect.intersects(attributes.frame) {
                layoutAttributesArray.append(attributes)
            }
        }

        return layoutAttributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath]
    }
}

class CircularCollectionViewLayoutNew: UICollectionViewLayout {
    private var itemSize: CGSize = CGSize(width: 50, height: 50)
    private var center: CGPoint = .zero
    private var radius: CGFloat = 100
    private var cellCount: Int = 0
    private var attributesCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    init(cellSize: CGSize) {
        super.init()
        self.itemSize = cellSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }
        
        radius = min(collectionView.bounds.width, collectionView.bounds.height) / 3
        collectionView.layer.cornerRadius = collectionView.frame.height / 2
        center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        cellCount = collectionView.numberOfItems(inSection: 0)
        attributesCache.removeAll()

        let angleStep: CGFloat = (2 * CGFloat.pi) / CGFloat(cellCount)
        for item in 0..<cellCount {
            let indexPath = IndexPath(item: item, section: 0)
            let angle = CGFloat(item) * angleStep
            let xPosition = center.x + radius * cos(angle) - itemSize.width / 2
            let yPosition = center.y + radius * sin(angle) - itemSize.height / 2
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xPosition, y: yPosition, width: itemSize.width, height: itemSize.height)
            attributesCache[indexPath] = attributes
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []

        for (_, attributes) in attributesCache {
            if rect.intersects(attributes.frame) {
                layoutAttributesArray.append(attributes)
            }
        }

        return layoutAttributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath]
    }
}

