function fn() {
  var system = java.lang.System;
  var configuredUrl = system.getenv('PETCLINIC_BASE_URL');
  var baseUrl = configuredUrl || 'http://localhost:9966/petclinic/api';
  var localTarget = baseUrl.indexOf('localhost') !== -1 || baseUrl.indexOf('127.0.0.1') !== -1;
  var destructiveOverride = system.getenv('PETCLINIC_ALLOW_DESTRUCTIVE') === 'true';
  var runId = system.getProperty('petclinic.runId') || java.util.UUID.randomUUID() + '';

  var config = {
    baseUrl: baseUrl.replace(/\/$/, ''),
    environment: karate.env || 'local',
    runId: runId,
    allowDestructive: localTarget || destructiveOverride
  };

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 10000);
  karate.configure('headers', function () {
    return {
      Accept: 'application/json',
      'X-Test-Run-Id': runId
    };
  });
  return config;
}

