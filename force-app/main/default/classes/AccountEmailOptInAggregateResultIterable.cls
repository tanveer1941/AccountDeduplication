global class AccountEmailOptInAggregateResultIterable implements Iterable<AggregateResult> {
    global Iterator<AggregateResult> Iterator(){
       return new AccountEmailOptInAggregateResultIterator();
    }
 }