global class AccountMobileAggregateResultIterable implements Iterable<AggregateResult> {
   global Iterator<AggregateResult> Iterator(){
      return new AccountMobileAggregateResultIterator();
   }
}