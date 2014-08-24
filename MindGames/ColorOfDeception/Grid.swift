import UIKit

extension ColorOfDeception {

    class Grid: UIView {
        
        var minSize:CGFloat!
        var maxSize:CGFloat!
        var minTileSize:CGFloat!
        var maxTileSize:CGFloat!
        var colors:Array<(name:String, color:UIColor)>!
        var size:Int = 0
        
        required init(coder aDecoder: NSCoder) {
            return super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        init (minSize:CGFloat, maxSize:CGFloat, minTileSize:CGFloat, maxTileSize:CGFloat, colors:Array<(name:String, color:UIColor)>) {
            super.init()
            self.minSize = minSize
            self.maxSize = maxSize
            self.minTileSize = minTileSize
            self.maxTileSize = maxTileSize
            self.colors = colors
        }
        
        func setSize(size:CGFloat) {
            self.size = Int(size)
            var tileSize:CGFloat = maxTileSize - (((size - minSize) / (maxSize - minSize)) * (maxTileSize - minTileSize))
            for i in 0...self.size - 1 {
                for j in 0...self.size - 1 {
                    var frame:CGRect = CGRectMake(CGFloat(j) * (tileSize + 10), CGFloat(i) * (tileSize + 10), tileSize, tileSize)
                    var tag:Int = 1000 + (i * self.size) + j
                    var tile:Tile! = self.viewWithTag(tag) as Tile?
                    if tile == nil {
                        tile = Tile(frame: frame)
                        tile.tag = tag
                    }
                    self.addSubview(tile)
                }
            }
            var frame = self.frame
            frame.size.width = size * (tileSize + 10) - 10
            frame.size.height = size * (tileSize + 10) - 10
            self.frame = frame
        }
        
        func refresh() {
            
            var indices = randN(self.colors.count, self.size * self.size)
            
            for i in 0...self.size - 1 {
                for j in 0...self.size - 1 {
                    var index:Int = (i * self.size) + j
                    var tag:Int = 1000 + index
                    var tile:Tile! = self.viewWithTag(tag) as Tile?
                    tile.defective = false
                    var tuple = self.colors[indices[index]]
                    tile.backgroundColor = tuple.color
                    tile.setText(tuple.name)
                }
            }
            
            var defectiveTile:Tile = self.viewWithTag(1000 + Int(rand()) % (self.size * self.size)) as Tile
            defectiveTile.defective = true
            
            for i in 0...self.colors.count - 1 {
                if (find(indices, i) == nil) {
                    defectiveTile.setText(self.colors[i].name)
                    break
                }
            }
            
        }
        
    }

}