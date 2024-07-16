//
//  ActionIsEmpty.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import SwiftUI

func isEmptyClosure(_ closure: @escaping () -> Void) -> Bool {
    return closure as AnyObject === {} as AnyObject
}
