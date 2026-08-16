public class RepresentativePerformanceWrapper {

    @AuraEnabled
    public Id representativeId;

    @AuraEnabled
    public String representativeName;

    @AuraEnabled
    public Integer totalVisits;

    @AuraEnabled
    public Integer completedVisits;

    @AuraEnabled
    public Decimal completionPercentage;

    public RepresentativePerformanceWrapper(
        Id representativeId,
        String representativeName
    ) {

        this.representativeId = representativeId;
        this.representativeName = representativeName;

        this.totalVisits = 0;
        this.completedVisits = 0;
        this.completionPercentage = 0;
    }
}
