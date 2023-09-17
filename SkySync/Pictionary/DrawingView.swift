//
//  DrawingView.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    @Binding var enableErase: Bool
    @ObservedObject var manageMatch: ManageMatch


    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 6)
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // handle user update
        if enableErase {
                // When enableErase is true, use the eraser tool (clear color and a width of 20)
                uiView.tool = PKEraserTool(.bitmap)
        } else {
            // When enableErase is false, use the pen tool (black color and a width of 6)
                uiView.tool = PKInkingTool(.pen, color: .black, width: 6)
            }
    }
}

struct DrawingView_Previews: PreviewProvider {
    @State static var erase = false
    static var previews: some View {
        DrawingView(enableErase: $erase, manageMatch: ManageMatch())
    }
}
