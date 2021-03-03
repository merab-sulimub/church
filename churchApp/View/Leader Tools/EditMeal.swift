//Created for churchApp  (28.10.2020 )

import SwiftUI
import Combine
 
struct EditMeal: View {
    
    @State var mealList: [MealResponse] = []
    @State var fullMealList: [MealResponse] = []
    
    @State var searchText: String = ""
    
    var RowsEdgeInsets = EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
       
    @State var isError = false
    @State var errorString = ""
     
    var body: some View {
        let binding = Binding<String>(get: { self.searchText },
                        set: { self.searchText = $0
                    // do whatever you want here
                    filterResult(by: $0)
                    print($0)
                })
        
        VStack(alignment: .leading) {
            //HStack {Spacer()}
            
            AppText(text: "Meal", weight: .semiBold, size: 24).padding(.top, 40)
            AppText(text: "Week of October 28, 2020", weight: .regular, size: 14, colorName: "Grey 3")
            /// Search box
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).frame(height: 48).foregroundColor(Color("Grey 6"))
                    TextField("Search", text: binding).padding([.leading, .trailing], 16)
                }
            }
            
            List {
                ForEach(mealList, id: \.id) { meal in // todo
                    EditMealRow(data: meal).listRowInsets(RowsEdgeInsets)
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .alert(isPresented: $isError) { () -> Alert in
            Alert(title: Text(""), message: Text(errorString), dismissButton: .default(Text("Ok")) {
                    self.isError = false
                    self.errorString = ""
            }  )
             
        }
        .onAppear() { updateList() }
    }
    
    func updateList() {
        DPManager.shared.getMealsList { (result) in
            switch result {
            case .failure(let err):
                self.errorString = err.getDescription()
                self.isError = true
            case .success(let res):
                res.mealsList.forEach({self.mealList.append($0) })
                res.mealsList.forEach({self.fullMealList.append($0) })
            }
        }
    }
    func filterResult(by string: String) {
        if string.isEmpty {
            self.mealList = fullMealList
        } else {
            self.mealList = fullMealList.filter({ $0.name.lowercased().contains(string.lowercased())})
        }
    }
}


struct EditMealRow: View {
    @State var isOpen = false
    
    var data: MealResponse
     
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(Color.white)
            VStack(alignment: .leading, spacing: 0) {
                AppText(text: data.name, weight: .semiBold, size: 17)
                 
                if !isOpen {
                    AppText(text: "\(data.ingredients.count) Ingredients", weight: .regular, size: 14, colorName: "Grey 3")
                } else {
                    // Using '\.self', we can refer to each element directly,
                    // and use the element's own value as its identifier:
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(data.ingredients, id: \.self) { ingredient in
                            AppText(text: ingredient, weight: .regular, size: 14, colorName: "Grey 2")
                        }
                        
                        HStack(spacing: 16) {
                            AppButton(type: .roundedWhite, shadowsRadius: 0, textPading: 24, title: "Cancel", enableHstack: false) {
                            }.overlay(Capsule().stroke(Color("borderColor 1"), lineWidth: 2))
                             
                            AppButton(type: .newMessage, shadowsRadius: 0, textPading: 12, title: "Select Meal") {
                            }.onTapGesture(count: 1, perform: {
                                print("Select Meal tapped")
                            })
                        }
                    }.padding(.top, 20)
                }
            }
        } 
        .onTapGesture(count: 1, perform: {  isOpen.toggle() })
    }
}



struct EditMeal_Previews: PreviewProvider {
    static var previews: some View {
        EditMeal()
    }
}
