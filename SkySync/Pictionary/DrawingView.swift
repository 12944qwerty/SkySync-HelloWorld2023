//
//  DrawingView.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var manageMatch: ManageMatch
        
        init(manageMatch: ManageMatch) {
            self.manageMatch = manageMatch
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // set up canvas
        }
    }
    
    var canvasView = PKCanvasView()
    @ObservedObject var manageMatch: ManageMatch
    @Binding var enableErase: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(manageMatch: manageMatch)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 6)
        canvasView.isUserInteractionEnabled = manageMatch.currentlyDrawing
        canvasView.delegate = context.coordinator
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // handle user update
        if enableErase {
                // When enableErase is true, use the eraser tool (clear color and a width of 20)
                canvasView.tool = PKEraserTool(.bitmap)
            } else {
                // When enableErase is false, use the pen tool (black color and a width of 6)
                canvasView.tool = PKInkingTool(.pen, color: .black, width: 6)
            }
    }
}

struct DrawingView_Previews: PreviewProvider {
    @State static var erase = false
    static var previews: some View {
        
        DrawingView(manageMatch: ManageMatch(), enableErase: $erase)
    }
}
