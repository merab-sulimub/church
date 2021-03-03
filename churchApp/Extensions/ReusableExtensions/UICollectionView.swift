//Created for churchApp  (25.09.2020 )
 
import UIKit

extension UICollectionView {
    func dequeueReusableCell<ResultedCollectionViewCell>(for indexPath: IndexPath) -> ResultedCollectionViewCell
        where ResultedCollectionViewCell: UICollectionViewCell
        /*, ResultedCollectionViewCell != UICollectionViewCell */
    {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: ResultedCollectionViewCell.self), for: indexPath) as! ResultedCollectionViewCell
    }
    
    func dequeueReusableSupplementaryView<ResultedCollectionView>(ofKind kind: String, for indexPath: IndexPath) -> ResultedCollectionView
        where ResultedCollectionView: UICollectionReusableView
        /*, ResultedCollectionView != UICollectionReusableViewCell */
    {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: ResultedCollectionView.self), for: indexPath) as! ResultedCollectionView
    }
}
