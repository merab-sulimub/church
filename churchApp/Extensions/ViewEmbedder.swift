//Created for churchApp  (28.10.2020 )

import UIKit

class ViewEmbedder {
class func embed(
    parent:UIViewController,
    container:UIView,
    child:UIViewController,
    previous:UIViewController?){

    if let previous = previous {
        removeFromParent(vc: previous)
    }
    child.willMove(toParent: parent)
    parent.addChild(child)
    container.addSubview(child.view)
    child.didMove(toParent: parent)
    let w = container.frame.size.width;
    let h = container.frame.size.height;
    child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
}

class func removeFromParent(vc:UIViewController){
    vc.willMove(toParent: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParent()
}

class func embed(withIdentifier id:String,
                 parent:UIViewController,
                 container:UIView,
                 removePrevious: Bool = true,
                 completion:((UIViewController)->Void)? = nil){
    let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
    embed(
        parent: parent,
        container: container,
        child: vc,
        previous: removePrevious ? parent.children.first : nil
    )
    completion?(vc)
}
}
