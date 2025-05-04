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
                TTSettingListCell(title: Localized.string(.Language_Button_SystemLanguage), subTitle: currentLanguage, isSelectable: true, isSelected: isSelected(.system)) {
                    viewModel.selected = .system
                }
                
                TTSettingListCell(title: "한국어", subTitle: Localized.string(.Language_Button_Korean), isSelectable: true, isSelected: isSelected(.ko)) {
                    viewModel.selected = .ko
                }
                
                TTSettingListCell(title: "English", subTitle: Localized.string(.Language_Button_English), isSelectable: true, isSelected: isSelected(.en)) {
                    viewModel.selected = .en
                }
                
                TTSettingListCell(title: "简体中文", subTitle: Localized.string(.Language_Button_Chinese), isSelectable: true, isSelected: isSelected(.zh)) {
                    viewModel.selected = .zh
                }
            }
        }
    }
    
    var currentLanguage: String {
        switch Language.system {
        case .ko: return Localized.string(.Language_Button_Korean)
        case .en: return Localized.string(.Language_Button_English)
        case .zh: return Localized.string(.Language_Button_Chinese)
        }
    }
    
    func isSelected(_ language: language) -> Bool {
        return viewModel.selected == language
    }
}

#Preview {
    SettingLanguageListView(viewModel: SettingLanguageVM())
}
