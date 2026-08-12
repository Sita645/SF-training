global class CandidateHistoricalSyncScheduler
    implements Schedulable {

    global void execute(SchedulableContext sc) {

        Database.executeBatch(
            new CandidateHistoricalSyncBatch(),
            200
        );
    }
}