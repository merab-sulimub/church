//Created for churchApp  (18.10.2020 )

import UIKit
import SwiftUI

struct FeedView: View {
    var body: some View {
 
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Image("avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40, alignment: .leading)
                        .padding()
                    
                    Spacer()
                }
                
                HStack {
                    Image("C3NYC-logo-small")
                }
            }
            
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Welcome to your feed")
                        .font(Font(commonAppearance.InterSemiBold.withSize(24)))
                        .foregroundColor(Color("Grey 1"))
                         
                        .padding([.top, .bottom], 8)
                    
                    Text("This is where updates from the church will appear. As you get connected, this is where you’ll also get Dinner Party and events reminders, as well as your latest messages from friends in the church.")
                        .font(Font(commonAppearance.InterRegular.withSize(16)))
                        .foregroundColor(Color("Grey 3"))
                    
                    
                    
                    
                }.padding([.leading, .trailing], 24)
                
                 
                DividerView()
                
                NavigationLink(
                    destination: FindDPController(),
                    label: {
                        AppButton { print("Find DP tapped") }
                    })
                
                DividerView()
                
                
                VStack{
                    HStack {
                        Text("Latest message".uppercased())
                            .font(Font(commonAppearance.InterSemiBold.withSize(12)))
                            .foregroundColor(Color("Grey 4"))
                        Spacer()
                    }
                    
                    
                    Image("lstMsgFeed")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        //.background(Color("Grey 1"))
                    
                    
                    HStack {
                        Text("Tap to watch or listen to this weeks’ message.")
                            .font(Font(commonAppearance.InterRegular .withSize(14)))
                            .foregroundColor(Color("Grey 4"))
                        Spacer()
                    }
                    
                    
                }.padding([.leading, .trailing], 24)
                
                
                
                
                
                
                
                
                 
                
                Spacer()
            }
            //.padding([.leading, .trailing], 24)
            
        }
    }
}

struct FeedSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedView()
            //FeedSwiftUIView().previewDevice("iPhone 8")
        }
    }
}


class FeedHostingController: UIHostingController<FeedView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: FeedView());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


struct FindDPController: UIViewControllerRepresentable {
    
    
    
    func makeUIViewController(context: Context) -> FindDinnerViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "FindDinnerViewController") as! FindDinnerViewController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: FindDinnerViewController, context: Context) {
    }
    
    typealias UIViewControllerType = FindDinnerViewController
}



 
