//Created for churchApp  (13.11.2020 )

import SwiftUI
 
struct appInputField: UIViewRepresentable {
    @Binding var text: String // Declare a binding value
    var placeholder: String
    
    var height: CGFloat = 70
    
    var type: UIKeyboardType = .default
    
    
    func makeUIView(context: Context) -> CAPlacehorderTextField {
        let v = CAPlacehorderTextField()
        
        v.keyboardType = type
        v.doneAccessory = true
        
        v.placeholder = placeholder
        
        v.delegate = context.coordinator
         
        v.setTopPlaceholder(placeholder)
        
        return v
    }
    
    func updateUIView(_ uiView: CAPlacehorderTextField, context: Context) {
        uiView.text = text // Read the binded
        uiView.textDidChange()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? "" //Write to the binded
            }
        }
    }
}
