//
//  ContentView.swift
//  Password_App
//
//  Created by 近藤秀人 on 2023/03/04.
//
import SwiftUI
import Amplify
import LocalAuthentication

struct ContentView: View {
    // title:保存するアプリケーション名、user:保存するユーザー名、pass:保存するパスワード
    @State private var title:String = ""
    @State private var user:String = ""
    @State private var pass:String = ""
    //読み込んだPassのセットを格納する配列
    @State var passAll:[Pass] = []
    //削除時アラート表示するトグル
    @State private var showingAlert = false
    //削除するアプリケーション名
    @State private var deleteName = ""
    @State private var faceID_toggle = false
    @State private var message=""
    @State private var result_comment=""
    let face:FaceAuth = FaceAuth()

    var body: some View {
        if faceID_toggle{
            ZStack {
            //START-登録フォーム
                NavigationView{
                    Form{
                        TextField("AppName", text: $title)
                        TextField("User", text: $user)
                        SecureField("Pass", text: $pass).keyboardType(.emailAddress)
                        Button("登録"){
                            let title = self.title
                            let user = self.user
                            let pass = self.pass
                            Task{
                                await save_data(title: title, user: user, pass: pass)
                                await load_data()
                            }
                            self.title = ""
                            self.user = ""
                            self.pass = ""
                        }
                    }
                    .navigationTitle("PassWord登録")
                }
            }
            //END-登録フォーム
            //START-登録PASS表示部分
            if passAll.count > 0 {
                List(0..<passAll.count, id: \.self) { index in
                    Section{
                        HStack{
                            Text(passAll[index].user_name)
                            Spacer()
                            Button(action:{
                                UIPasteboard.general.string = passAll[index].user_name
                            }){
                                Image(systemName: "doc.on.doc")
                            }
                        }
                        HStack{
                            Text("PassWord")
                            Spacer()
                            Button(action:{
                                UIPasteboard.general.string = passAll[index].pass
                            }){
                                Image(systemName: "doc.on.doc")
                            }
                        }
                        Button("削除"){
                            self.showingAlert = true
                            self.deleteName = passAll[index].app_name
                        }
                        .alert(isPresented:$showingAlert){
                            Alert(
                                title:Text("\(deleteName)を削除しますか？"),
                                primaryButton: .default(Text("キャンセル")),
                                secondaryButton: .default(Text("削除"),
                                                          action: {
                                                              Task{
                                                                  await delete_data(title:deleteName)
                                                                  await load_data()
                                                                  
                                                              }
                                                          }
                                                         )
                            )
                        }
                    }header: {
                        Text(passAll[index].app_name)
                    }
                }
            }
        }else{
            Text("\(result_comment)").onAppear{
                faceID()
                Task{
                    await load_data()
                }
            //END-登録PASS表示部分
            }
            Button(action: {
                faceID()
            }) {
                Text("再認証")
                    .bold()
                    .padding()
                    .frame(width: 100, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
        }
    }

    func faceID() {
        // クロージャで非同期実行
        face.auth { result in
            result_comment = result
            if result == "認証が成功しました"{
                // 結果をメッセージに格納
                faceID_toggle = true
            }

        }
    }

    //データの保存
    func save_data(title:String,user:String,pass:String) async {
        do {
            let item = Pass(app_name: title,
                            user_name: user,
                            pass: pass)
            let savedItem = try await Amplify.DataStore.save(item)
            print("Saved item: \(savedItem.app_name)")
        } catch {
            print("Could not save item to DataStore: \(error)")
        }
    }
    //データの読み込み
    func load_data() async {
        do {
            let result = try await Amplify.DataStore.query(Pass.self)
            passAll = result
        } catch {
            print("Could not query DataStore: \(error)")
        }
    }
    //データの削除
    func delete_data(title:String) async {
        do {
            let passes = try await Amplify.DataStore.query(Pass.self, where: Pass.keys.app_name.eq(title))
            guard  let toDeletePass = passes.first else {
                print("Did not find exactly one pass, bailing")
                return
            }
            try await Amplify.DataStore.delete(toDeletePass)
            print("Deleted item: \(toDeletePass.app_name)")
        } catch {
            print("Unable to perform operation: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
