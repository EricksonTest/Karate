Feature: Remove only records created and owned by the current scenario

  Scenario:
    * url baseUrl
    * def ids = ownerIds || []
    * def removeOwner =
      """
      function(id) {
        var result = karate.call('classpath:petclinic/support/delete-owner.feature',
          { baseUrl: baseUrl, ownerId: id });
        if (result.responseStatus == 500) {
          karate.log('Cleanup retry for owner', id, 'after transient cascade failure');
          result = karate.call('classpath:petclinic/support/delete-owner.feature',
            { baseUrl: baseUrl, ownerId: id });
        }
        if (result.responseStatus != 200 && result.responseStatus != 204 && result.responseStatus != 404) {
          karate.fail('Cleanup failed for owned owner ' + id + ': HTTP ' + result.responseStatus);
        }
      }
      """
    * karate.forEach(ids, removeOwner)
