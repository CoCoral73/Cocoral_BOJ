import Foundation

//빠른 입출력
final class FileIO {
    private let buffer:[UInt8]
    private var index: Int = 0

    init(fileHandle: FileHandle = FileHandle.standardInput) {
        
        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }

    @inline(__always) private func read() -> UInt8 {
        defer { index += 1 }

        return buffer[index]
    }

    @inline(__always) func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true

        while now == 10
                || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }

        return sum * (isPositive ? 1:-1)
    }

    @inline(__always) func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시

        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    @inline(__always) func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시

        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return Array(buffer[beginIndex..<(index-1)])
    }
}

let fIO = FileIO()
//let n = Int(readLine()!)!
//let n = readLine()!.components(separatedBy: [" "]).map { Int($0)! }

func findParent(_ x: Int) -> Int {
    if x == parent[x] { return x }
    parent[x] = findParent(parent[x])
    return parent[x]
}
func unionParent(_ x: Int, _ y: Int) {
    let px = findParent(x), py = findParent(y)
    
    if px == py { return }
    if px < py { parent[py] = px }
    else { parent[px] = py }
}
func isConnected(_ x: Int, _ y: Int) -> Bool {
    let px = findParent(x), py = findParent(y)
    return px == py
}

let (n, m) = (fIO.readInt(), fIO.readInt())
var parent = (0..<n).map { $0 }

var answer = 0
for i in 0..<m {
    let (x, y) = (fIO.readInt(), fIO.readInt())
    if isConnected(x, y) { answer = i + 1; break }
    unionParent(x, y)
}
print(answer)

/*
Testcase

 */
