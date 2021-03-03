//Created for churchApp  (29.10.2020 )

import SwiftUI

struct LeaderHelpView: View {
    
    @Binding var isPresented: Bool
    
    @State var questionText: String = "Enter your question"
    @State private var textStyle = UIFont.TextStyle.body
    var body: some View {
        
        
        
        VStack(alignment: .leading) {
            
            // MARK: - HEADER
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    AppText(text: "Members Help", weight: .semiBold, size: 24)
                    AppText(text: "Reach out to church staff with any questions or help you need and we’ll be in touch as soon as possible.", weight: .regular, size: 14, colorName: "Grey 3")
                }
            }.padding(.top, 40)
            
            TextView(text: $questionText, textStyle: $textStyle).frame(height: 240, alignment: .leading).padding()
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("borderColor 1"), lineWidth: 2)).padding(.top, 24)
            
            VStack(alignment: .center, spacing: 0, content: {
                AppButton(type: .findDinnerParty, shadowsRadius: 0, title: "Submit", LRpaddings: 0) {
                    print("Submit tapped")
                }
                .padding(.top, 24)
                 
                Button("Cancel") { self.isPresented = false }
                    .padding(.top, 24)
                .foregroundColor(.gray)
            })
              
            Spacer()
        }.padding([.leading, .trailing], 24)
        
    }
    
}

//struct LeaderHelpView_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderHelpView()
//    }
//}


//MARK: - Option 1

struct TextView: UIViewRepresentable {
 
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
 
    var onDone: (() -> Void)?
    var placeholderText: String?
    var showDone = true
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
 
        if showDone {
            textView.addDoneButton()
        }
        
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
     
    
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(text: $text, onDone: onDone)
//    }
//
//    final class Coordinator: NSObject, UITextViewDelegate {
//        var text: Binding<String>
//        var onDone: (() -> Void)?
//
//        init(text: Binding<String>, onDone: (() -> Void)? = nil) {
//            self.text = text
//            self.onDone = onDone
//        }

//        func textViewDidChange(_ uiView: UITextView) {
//            text.wrappedValue = uiView.text
//        }
        
//        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//            if textView.text == placeholderText {
//                textView.text = ""
//            }
//            return true
//        }
//
//        func textViewDidEndEditing(_ textView: UITextView) {
//            if textView.text.isEmpty {
//                textView.text = placeholderText.wrappedValue
//            }
//        }

//        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//            if let onDone = self.onDone, text == "\n" {
//                textView.resignFirstResponder()
//                onDone()
//                return false
//            }
//            return true
//        }
//    }
}





//MARK: - Option 2



fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}


struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}
