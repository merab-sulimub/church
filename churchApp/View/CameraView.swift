//Created for churchApp  (30.10.2020 )

import SwiftUI

enum AppCameraType {
    case selfie, live, video, profilePhoto
}

struct CameraView: View {
    @EnvironmentObject var model: CameraModel
     
    @Binding var isPresented: Bool
    @State var photoData: Data? = nil
    
    
    var type: AppCameraType
    var fromStoryBoard = false
    
    
    //@State var isError = false
    //@State var error = ""
       
    var body: some View {
            ZStack(alignment: .topLeading) {
                 
                CameraPreview(session: model.session)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        model.configure()
                        
                        if type == .profilePhoto {
                            model.flipCamera()
                        }
                    }
//                        .onDisappear {
//                            model.session.stopRunning()
//                        }
                    .alert(isPresented: $model.showAlertError, content: {
                        Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                            model.alertError.primaryAction?()
                        }))
                    })
                    .overlay(
                        Group {
                             
                            if model.willCapturePhoto {
                                Color.black
                            }
                            
                            if model.shouldShowSpinner {
                                Color.black
                            }
                        }
                    )
                    .animation(.easeInOut)
                  
                 
                if !fromStoryBoard {
                    Button(action: { self.isPresented = false }, label: {
                        Image("close-icon")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .padding(24)
                    })
                }
                 
                
                if type == .live {
                    VStack(spacing: 0) {
                        Rectangle().foregroundColor(Color("Grey 1")).opacity(0.4).frame(height: 100)
                        Rectangle().foregroundColor(Color("Grey 1")).opacity(0.4) .clipShape(ShapeWithRoundedRectangle())
                        Rectangle().foregroundColor(Color("Grey 1")).opacity(0.4)
                    }.edgesIgnoringSafeArea(.all)
                }
                 
                VStack(alignment: .center) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        Button(action: {
                            print("SwiftUI: capture tapped")
                            model.capturePhoto() {
                                isPresented = false
                                print("COMPLETION !")
                            } 
                        }, label: {
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .clipShape(CircleWithTranspShape())
                                     
                                AppText(text: appearance(), weight: .semiBold, size: 12.0, color: .white)
                            }
                        }).padding(.bottom, 40)
                        Spacer()
                    }
                }
                .hideNavigationBar()
            }
            
            //
            //remove the default Navigation Bar space:
            
//
//        .alert(isPresented: $isError, content: {
//            Alert(title: Text(error), dismissButton: .default(Text("OK"), action: { self.isPresented = false }))
//        })
    }
     
    func appearance() ->  String  {
        
        var title = ""
        
        
        switch type {
        case .selfie:
            title = "Take a selfie".uppercased()
        case .video:
            title =  "Record".uppercased()
        case .live:
            title =  "Start Live video".uppercased()
        case .profilePhoto:
            title = "Take photo".uppercased()
        }
        
        return (title)
    }
}





struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(isPresented: .constant(false), type: .profilePhoto)
    }
}






//ViewModifiers.swift

//struct HiddenNavigationBar: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarHidden(true)
//    }
//}
//
//extension View {
//    func hiddenNavigationBarStyle() -> some View {
//        modifier( HiddenNavigationBar() )
//    }
//}


public struct NavigationBarHider: ViewModifier {
    @State var isHidden: Bool = false

    public func body(content: Content) -> some View {
        content
            .navigationBarTitle("")
            .navigationBarHidden(isHidden)
            .onAppear { self.isHidden = true }
    }
}

extension View {
    public func hideNavigationBar() -> some View {
        modifier(NavigationBarHider())
    }
}
