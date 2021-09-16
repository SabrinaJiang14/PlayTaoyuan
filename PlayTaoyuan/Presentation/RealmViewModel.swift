//
//  RealmViewModel.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/14.
//

import Foundation
import Combine
import RealmSwift

protocol DatabaseProtocol {
    var storesPublisher:Published<[StoreProtocol]>.Publisher { get }
    func viewDidLoad()
    func createStore()
    func deleteStore(index:IndexPath)
}

extension DatabaseProtocol {
    func viewDidLoad() { }
}


class RealmViewModel:NSObject, DatabaseProtocol {

    @Published var mStores:[StoreProtocol] = []
    var storesPublisher: Published<[StoreProtocol]>.Publisher { $mStores }
    
    var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    var delegate : ViewModelDelegate?
    
    override init() {
        super.init()
        let config = Realm.Configuration(
            schemaVersion : 3 ,
            migrationBlock : { migration , oldSchemaVersion in
                //if (oldSchemaVersion < 1) {
                //    如果你有必須針對舊板本遷移到新版本的資料改變，就寫在這裡。
                //    詳細的做法可以參考官方的範例
                //}
            }
        )

        Realm.Configuration.defaultConfiguration = config
    }
    
    func viewDidLoad() {
        let realm = try! Realm()
        realm.objects(RealmStore.self).collectionPublisher
            .sink(receiveCompletion: { _ in }) { (result:Results<RealmStore>) in
                self.mStores = result.map({ $0 })
        }.store(in: &cancellables)
    }
    
    func createStore() {
        let realm = try! Realm()
        try! realm.write({
            let store = RealmStore()
            store.address = "台北市內湖區內湖路三段1088號"
            store.name = "Hello Restaurant"
            store.phone = "023449885839"
            realm.add(store)
        })
    }
    
    func deleteStore(index:IndexPath) {
        let realm = try! Realm()
        try! realm.write({
            if let deleteObj = self.mStores[index.row] as? RealmStore {
                realm.delete(deleteObj)
            }
        })
    }
    
}

//@Persisted is used to declare properties on Object subclasses which should be managed by Realm.
class RealmStore: Object , ObjectKeyIdentifiable, StoreProtocol{
//    @Persisted(primaryKey: true) var _id :ObjectId = ObjectId.generate()
    @Persisted var name:String = ""
    @Persisted var phone:String = ""
    @Persisted var address:String = ""
    @Persisted var number:String = "1"
    
    func getName() -> String {
        return self.name + "-" + self.number
    }
    
    func getPhone() -> String {
        return self.phone
    }
    
    func getAddress() -> String {
        return self.address
    }
}
