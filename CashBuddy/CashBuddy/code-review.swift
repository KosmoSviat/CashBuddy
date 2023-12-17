
GeneralViewController
- TransactionList
  - TransactionService

protocol TransactionService {
    func getTransactions(completion: ([Transaction]) -> Void)
    func setTransactions(completion: () -> Void)
}

class CoreDataTransactionService: TransactionService {

}

class RealmTransactionService: TransactionService {

}

class RemoteTransactionService: TransactionService {

}
