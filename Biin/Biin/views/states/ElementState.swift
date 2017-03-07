//  ElementState.swift
//  biin
//  Created by Esteban Padilla on 10/7/15.
//  Copyright © 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class ElementState:BNState {
    
    override init(context:BNView, view:BNView?){
        super.init(context:context, view: view)
        self.stateType = BNStateType.ElementState
    }
    
    override func action() {
        view!.transitionIn()
    }
    
    override func next( state:BNState? ) {
        context!.state = state
        view!.transitionOut( context!.state )
    }
}

