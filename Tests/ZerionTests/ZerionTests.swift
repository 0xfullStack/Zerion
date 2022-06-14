import XCTest
import RxSwift
import SocketIO
@testable import Zerion

final class ZerionTests: XCTestCase {

    private let zerion = Zerion.shared
    private let bag = DisposeBag()
    
    func testZerion() {
        let expectation = XCTestExpectation(description: "Subscribe address's positions failure")
        
        zerion
            .on(.positions(address: "0x6079433E43Bf3244Bceef85a2FBfbfFa6864C82c"))
            .subscribe(onNext: { data in
                guard let dic = data.first as? [String: [String: Any]] else {
                    return
                }
                guard let dic = dic["payload"]?["positions"],
                      let dic = dic as? [String: Any],
                      let array = dic["positions"] as? [Any] else {
                    return
                }
                guard let jsonData = try? JSONSerialization.data(withJSONObject: array) else {
                    return
                }
                if let objects = try? JSONDecoder().decode([Position].self, from: jsonData) {
                    print(objects)
                }
            })
            .disposed(by: bag)
        
        wait(for: [expectation], timeout: TimeInterval(10000))
    }
}
