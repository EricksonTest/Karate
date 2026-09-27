Feature: Remove only global resources created by the current scenario

  Scenario:
    * def owned = resources || []
    * def reversed = owned.slice().reverse()
    * def removeResource =
      """
      function(resource) {
        var result = karate.call('classpath:petclinic/support/delete-resource.feature',
          { baseUrl: baseUrl, resourcePath: resource.path, resourceId: resource.id });
        if (result.responseStatus != 200 && result.responseStatus != 204 && result.responseStatus != 404) {
          karate.fail('Cleanup failed for ' + resource.path + '/' + resource.id + ': HTTP ' + result.responseStatus);
        }
      }
      """
    * karate.forEach(reversed, removeResource)
