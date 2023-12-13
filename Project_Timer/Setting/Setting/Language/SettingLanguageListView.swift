//
//  SettingLanguageListView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/13.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SettingLanguageListView: View {
    @ObservedObject var viewModel: SettingLanguageVM
    
    init(viewModel: SettingLanguageVM) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    enum language: String {
        case system
        case ko
        case en
        case zh
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
                TTSettingSelectableCell(title: Localized.string(.Settings_Button_SystemLanguage), subTitle: currentLanguage, isSelected: isSelected(.system)) {
                    viewModel.selected = .system
                }
                
                TTSettingSelectableCell(title: "한국어", subTitle: Localized.string(.Settings_Button_Korean), isSelected: isSelected(.ko)) {
                    viewModel.selected = .ko
                }
                
                TTSettingSelectableCell(title: "English", subTitle: Localized.string(.Settings_Button_English), isSelected: isSelected(.en)) {
                    viewModel.selected = .en
                }
                
                TTSettingSelectableCell(title: "简体中文", subTitle: Localized.string(.Settings_Button_Chinese), isSelected: isSelected(.zh)) {
                    viewModel.selected = .zh
                }
            }
        }
    }
    
    var currentLanguage: String {
        switch Language.current {
        case .ko: return Localized.string(.Settings_Button_Korean)
        case .en: return Localized.string(.Settings_Button_English)
        case .zh: return Localized.string(.Settings_Button_Chinese)
        }
    }
    
    func isSelected(_ language: language) -> Bool {
        return viewModel.selected == language
    }
}

#Preview {
    SettingLanguageListView(viewModel: SettingLanguageVM())
}
