//
//  WelcomeView.swift
//  Cleaner4Xcode
//
//  Created by Baye Wayly on 2019/10/5.
//  Copyright © 2019 Baye. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(.white)
      .padding(.horizontal, 25)
      .padding(.vertical, 10)
      .background(Color.pink)
      .cornerRadius(25)
      .contentShape(Rectangle())
  }
}

struct WelcomeView: View {
  @EnvironmentObject var appData: AppData
  
  func onAnalyze() {
    withAnimation{
      if appData.selectedDeveloperPath == nil {
        let fh = FileHelper.standard
        let defaultPath = fh.getDefaultXcodePath()
        
        fh.validateDeveloperPath(default: defaultPath) {path in
          self.appData.selectedDeveloperPath = path
          self.appData.analyze()
        }
        
      } else {
        self.appData.analyze()
      }
    }
  }
  
  func choseDeveloperPath() {
    appData.selectedDeveloperPath = nil
    onAnalyze()
  }
  
  var analyzingView: some View {
    VStack (alignment: .center, spacing: 10) {
      Text(humanize(appData.totalSize))
        .font(Font.largeTitle.monospacedDigit())
        .bold()
        .foregroundColor(.pink)

      if appData.isAnalyzing {
        ProgressBar(progress: CGFloat(appData.progress), height: 6)
          .frame(minHeight: 40, alignment: .center)

      } else {
        Text("welcome.button_analyze_again")
          .modifier(ButtonModifier())
          .frame(minHeight: 40, alignment: .center)
          .onTapGesture(perform: onAnalyze)
      }
    }.frame(maxWidth: .infinity, minHeight: 140)
  }
  
  var startView: some View {
    VStack{
      Text("welcome.button_analyze")
        .modifier(ButtonModifier())
        .onTapGesture(perform: onAnalyze)
      
      if appData.selectedDeveloperPath != nil {
        VStack{
          Text("Selected \(appData.selectedDeveloperPath!)")
            .foregroundColor(.secondary)
            .padding()
          
          Text("welcome.button_change_location")
            .foregroundColor(.pink)
            .padding()
            .contentShape(Rectangle())
            .onTapGesture(perform: choseDeveloperPath)
        }
      }
    }
    .frame(height: 140)
  }
  
  
  var body: some View {
    VStack{
      Spacer()
      
      Image("icon512")
        .resizable()
        .frame(width: 128, height: 128, alignment: .center)
      
      Spacer()
      
      Text("Cleaner for Xcode")
        .font(Font.system(.largeTitle, design: .rounded))

      Text("welcome.need_authorize")
        .multilineTextAlignment(.center)
        .font(.footnote)
        .foregroundColor(.secondary)
        .padding(.top, 5)
      
      Spacer()
      
      if appData.totalSize > 0 {
        analyzingView
        
      } else {
        startView
      }
      
    }
    .padding(.horizontal, 40)
    .padding(.vertical, 25)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    let appData = AppData()
    appData.isAnalyzing = false
    appData.totalCount = 500
    appData.analyzedCount = 400
    appData.totalSize = 6 * 10 * 1000 * 1000 * 1000
    
    let analyzing = AppData()
    analyzing.isAnalyzing = true
    analyzing.totalCount = 500
    analyzing.analyzedCount = 400
    analyzing.totalSize = 6 * 10 * 1000 * 1000 * 1000
    
    return Group{
      HStack {
        WelcomeView()
          .frame(width: 400, height: 500)
          .environmentObject(AppData())
        
        WelcomeView()
          .frame(width: 400, height: 500)
          .environmentObject(appData)
        
        WelcomeView()
          .frame(width: 400, height: 500)
          .environmentObject(analyzing)
      }
    }
    .environment(\.locale, Locale(identifier: "zh"))
  }
}
