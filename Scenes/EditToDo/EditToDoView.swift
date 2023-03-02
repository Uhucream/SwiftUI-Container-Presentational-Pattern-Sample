//
//  EditToDoView.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import SwiftUI

struct EditToDoView: View {
    
    @Binding var title: String
    
    @Binding var dueAt: Date
    
    @Binding var memo: String
    
    @Binding var shouldEnableSaveChangesButton: Bool
    
    private(set) var onTapDismissButtonCallback: (() -> Void)?
    private(set) var onTapSaveChangesButtonCallback: (() -> Void)?
    
    func onTapDismissButton(action: @escaping () -> Void) -> Self {
        var view = self
        
        view.onTapDismissButtonCallback = action
        
        return view
    }

    func onTapSaveChangesButton(action: @escaping () -> Void) -> Self {
        var view = self
        
        view.onTapSaveChangesButtonCallback = action
        
        return view
    }
    
    var body: some View {
        Form {
            Section {
                TextField("タイトル", text: $title)
            }
            
            Section {
                DatePicker(selection: $dueAt, in: Calendar.current.startOfDay(for: .now)...) {
                    Text("期日")
                }
            }
            
            Section {
                TextEditor(text: $memo)
                    .frame(minHeight: 60)
                    .background {
                        if memo.count == 0 {
                            Text("メモ")
                                .foregroundColor(Color(uiColor: .placeholderText))
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(
                    action: {
                        onTapDismissButtonCallback?()
                    }
                ) {
                    Text("キャンセル")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(
                    action: {
                        onTapSaveChangesButtonCallback?()
                    }
                ) {
                    Text("変更を保存")
                }
                .disabled(!shouldEnableSaveChangesButton)
            }
        }
    }
}

struct EditToDoView_Previews: PreviewProvider {
    static var previews: some View {
        EditToDoView(
            title: .constant("自炊"),
            dueAt: .constant(.now.addingTimeInterval(5000)),
            memo: .constant("めもめも"),
            shouldEnableSaveChangesButton: .constant(true)
        )
    }
}
