//Created for churchApp  (08.11.2020 )

import SwiftUI

struct DPInfoView: View {
    
    var dp: FindPartyResponse
    
    @State var going = false
    @State var chatList: [InboxDemoData] = [inboxDemoData]
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 0, content: {
                
                //MARK: - Header Image(gradient) block
                ZStack(alignment: .bottomLeading) {
                    ZStack {
                        Image("Rectangle 73")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                              
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(LinearGradient(gradient: Gradient(colors: [.clear, Color.black.opacity(0.66)]), startPoint: .top, endPoint: .bottom))
                            
                    }
                    .frame(height: 280)
                    
                     
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            AppText(text: dp.title, weight: .semiBold, size: 28.0, color: .white)
                                .lineLimit(1)
                            
                            AppText(text: dp.date.formated(.dayAtTime), weight: .regular, size: 16.0, colorName: "Grey 5")
                                .lineLimit(1)
                        }
                        Spacer()
                        Image("btn-map-icon")
                    }
                    .padding(.bottom, 16)
                    .padding([.leading, .trailing], 24)
                }.clipped()
                
                //MARK: - Sub Header Title/Date/RSVP btn
                HStack {
                    VStack(alignment: .leading) {
                        AppText(text: "This Week", weight: .semiBold, size: 24, colorName: "Grey 1")
                        AppText(text: dp.date.formated(.DayMonAtDate), weight: .regular, size: 14, colorName: "Grey 3")
                    }
                    Spacer()
                    
                    if going {
                        AppButton(type: .roundedWhiteWithBorder, shadowsRadius: 0, lineLimit: 1, textPading: 16, title: "Going", enableHstack: false, LRpaddings: 0) { }
                            .foregroundColor(.green)
                    } else {
                        AppButton(type: .roundedWhiteWithBlackBorder, shadowsRadius: 0, lineLimit: 1, textPading: 16, title: "RSVP", enableHstack: false, LRpaddings: 0) { }
                    }
                }
                .padding([.leading, .trailing], 24)
                .padding([.top, .bottom], 32)
                
                //MARK: - Members + Invite Block
                HStack(alignment: .center, spacing: 16, content: {
                    // MARK: Block: Left side
                    MembersBlockView(members: dp.members)
                    Spacer()
                    // MARK: Block: Right side
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                AppText(text: "INVITE".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 2")
                                Spacer()
                                Image("small-arrow-icon")
                            }
                            AppText(text: "Share Dinner Party with friends.", weight: .regular, size: 14, colorName: "Grey 2")
                             
                        }
                        .padding(16)
                        .background(Color("Grey 6"))
                        .cornerRadius(16.0)
                        
                    }
                }).padding([.leading, .trailing], 24)
                
                DividerView()
                
                //MARK: - Last messages Block
                VStack( alignment: .leading,spacing: 8) {
                    AppText(text: "latest message".uppercased(), weight: .semiBold, size: 12.0, colorName: "Grey 4").lineLimit(1)
                    
                    
                    // set 16:9 as aspect ratio
                    Image("lstMsgFeed").resizable()
                        .aspectRatio(1.77, contentMode: .fit)//.frame(height: 250)
                     
                }.padding([.leading, .trailing], 24)
                 
                // MARK: - Podcasts Block
                HStack(spacing: 16) {
                    AppText(text: "Podcast", weight: .semiBold, size: 18)
                    Spacer()
                    PodcastButton(type: .spotify) { }
                    PodcastButton(type: .podcast) { }
                    PodcastButton(type: .youtube) { }
                    
                }.padding([.leading, .trailing], 24)
                // MARK: - Discussion Guide Block
                HStack() {
                    AppText(text: "Discussion Guide", weight: .semiBold, size: 18.0, colorName: "Grey 1")
                    Spacer()
                    
                    
                    Button(action: {}, label: {
                        AppText(text: "Read", weight: .semiBold, size: 12, colorName: "Grey 1")
                            .padding([.leading, .trailing], 16)
                            .padding([.top , .bottom], 8)
                    }).overlay(Capsule().stroke(Color("borderColor 1"), lineWidth: 2)  )
                               
                                
                }
                .padding([.leading, .trailing], 24)
                .padding(.top, 26)
                
                DividerView()
                // MARK: - Chat Block
                Group {
                    VStack(alignment: .leading) {
                        HStack() {
                            AppText(text: "Chat", weight: .semiBold, size: 24.0, colorName: "Grey 1")
                            Spacer()

                            AppButton(type: .roundedWhiteWithBorder, shadowsRadius: 0, textPading: 16, title: "New Topic", enableHstack: false, LRpaddings: 0) { }
                        }
                        ////
                        ForEach(chatList, id: \.id) { chat in
                            InboxViewRow(data: chat)
                        }
                        
                    }.padding([.leading, .trailing], 24)
                    .padding(.top, 5)
                     
                    DividerView()
                // MARK: - Highlights Block
                    VStack(alignment: .leading) {
                    HStack() {
                        AppText(text: "Highlights", weight: .semiBold, size: 18.0, colorName: "Grey 1")
                         
                    }
                    Image("Screen Shot 2020-04-15 at 3.11").cornerRadius(16)
                     
                    }.padding([.leading, .trailing], 24)
                }
                Spacer()
            })
        }.edgesIgnoringSafeArea(.top)
    }
}

 

struct DPInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DPInfoView(dp: FindPartyResponse(DinnerPartyDB())  )
    }
}
