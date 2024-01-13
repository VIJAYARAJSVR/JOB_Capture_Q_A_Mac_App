//
//  ContentView.swift
//  Question_Answer_Capture
//
//  Created by Web_Dev on 4/1/23.
//





import SwiftUI

struct MainView: View {
    
    //    Category--->  Command + y
    
    //    Question--->  Command + t
   
    //    Answer--->    Command + U
    
    //    Save --->     Command + S

    //    Clear --->    Command + K
    
    
    
    @State var Category:String = ""
    @State var Question:String = ""
    @State var Answer:String = ""
    

    
    @State var statusInfo = "Not Yet Saved"
    @State var status = SaveStatus.Failure
    
    enum SaveStatus:Error {
        case Success
        case Failure
    }
    
    func ClearAllState() {
        Category = ""
        Question = ""
        Answer = ""
//        statusInfo = ""
    }
    
    
    func Get_Current_DateTime_forFileName() -> String {
        let dt = Date()
        let dateFormatter = DateFormatter()
        // Set Date/Time Style
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd_MM_YYYY"
        let currentDate = dateFormatter.string(from: dt)
        
        
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = dateFormatter.string(from: dt)

//         let AMPM = hrs >= 12 ? `PM` : `AM`;
//         hrs = (hrs - 12 * parseInt(hrs / 12));
//         hrs = hrs ? hrs : 12;
//         mnts = mnts < 10 ? `0` + mnts : mnts;
        
        let arrTime = time.components(separatedBy: ":")
        var hrs = Int(arrTime[0])!
        let mnts = Int(arrTime[1])!
        let sec = Int(arrTime[2])!
        
        let AMPM = (hrs >= 12) ? "PM": "AM";
        hrs = hrs - 12 * (hrs / 12)
        hrs = (hrs != 0) ? hrs : 12
        
        let minutes = (mnts < 10) ? "0" + String(mnts) : String(mnts)
        
        //Applied_JOB_info 28_01_2023  2_24 AM  45 sec
        
        let current_DateTime = currentDate+"  "+String(hrs)+"_"+minutes+" "+AMPM+"  "+String(sec)+" sec"
        
        return current_DateTime
        
    }
    
    
    func Save_as_JSON() {
        
        if Category=="" || Question == "" || Answer == "" {
            statusInfo = "Please fill All Field"
            return
        }

        //Applied_JOB_info 28_01_2023  2_24 AM  45 sec
        let filename = "QA_Later "+Get_Current_DateTime_forFileName();

   
        //JSON Object
        let QA_Detail_Object = QADetail(Category: Category, Question: Question, Answer: Answer)
    
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted , .sortedKeys , .withoutEscapingSlashes]
        
        //Converting JSON Object to JSON DATA
        let jsonData = (try? encoder.encode(QA_Detail_Object))!
        
    
        do {
            _ = try save_From_JSON_Data(data: jsonData, toFilename: filename)
        }
        catch let error {
           print("error is \(error)")
        }
        
        getDocumentsDirectory1()
    }
    
    func save_From_JSON_Data(data: Data, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            try data.write(to: fileURL, options: [.atomicWrite])
            statusInfo = "Saved Successfully"
            ClearAllState()
            return true
        }
        return false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        print(documentsDirectory)
        
        return documentsDirectory
    }
    func getDocumentsDirectory1() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        print(documentsDirectory)
        

    }
    
    
    var body: some View {
        VStack {
            
            HStack {
                
                let kequi:KeyEquivalent = "y"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Category,kkey:"Y")

                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                Text("Category")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                
                
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Category", text: $Category).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            HStack {
                let kequi:KeyEquivalent = "t"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Question,kkey:"T")

                Spacer()
                    .frame(width: 10)
                    .clipped()
                Text("Question")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Question", text: $Question).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            HStack {
                let kequi:KeyEquivalent = "u"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Answer,kkey:"U")


                Spacer()
                    .frame(width: 10)
                    .clipped()
                Text("Answer")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextEditor(text: $Answer)
                    .frame(height: 200)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(25)
                    .font(Font.custom("AvenirNext-Regular", size: 20, relativeTo: .body))
                    .disableAutocorrection(true)
                    .border(Color.gray, width: 3)
                    .padding([.leading, .bottom, .trailing])
                
                
                
                Spacer()
            }
            .padding()
            
            Text(statusInfo)
                .padding(.vertical, 12)
                .padding(.horizontal, 34)
                .foregroundColor(.yellow)
                .padding(.bottom, 0)
                .font(.largeTitle)
            
            HStack {
                Spacer()
                Button("Save") {
                    
                    Save_as_JSON()
                    

                }    .keyboardShortcut("s", modifiers: [.command])
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 34)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                
                    .background(.orange.opacity(0.5))
                    .buttonStyle(PlainButtonStyle())
                    .mask {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                    }
                    .disabled(Category=="" || Question == "" || Answer == "")
                Spacer()
                    .frame(width: 40)
                    .clipped()
                
                
                Button("Clear") {
                    ClearAllState()
                   
                }    .keyboardShortcut("k", modifiers: [.command])
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 34)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .background(.orange.opacity(0.5))
                    .buttonStyle(PlainButtonStyle())
                    .mask {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                    }
                
                Spacer()
            }
            .padding()
            .padding(.bottom, 40)
            
            .clipped()
        }
        .padding()
        .clipped()
        .background(Color(.sRGB, red: 40/255, green: 44/255, blue: 51/255))
    }
    
    
}



struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height:35)
            .clipped()
            .font(.largeTitle)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color("ClrTxtField"), Color("ClrTxtField")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.black)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
