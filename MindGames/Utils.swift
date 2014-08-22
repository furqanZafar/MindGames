import Foundation

func randN(max:Int, count:Int) -> Array<Int> {
    
    var numbers:Array<Int> = []
    var number:Int!
    
    for i in 0...count - 1 {
        
        do {
            number = Int(rand()) % max
        } while(find(numbers, number) != nil)
        
        numbers.append(number)
        
    }
    
    return numbers
    
}
