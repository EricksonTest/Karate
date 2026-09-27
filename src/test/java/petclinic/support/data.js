function fn() {
  function letters() {
    var source = java.lang.System.nanoTime().toString().replace('-', '');
    var alphabet = 'abcdefghij';
    var value = '';
    for (var i = 0; i < source.length; i++) {
      value += alphabet.charAt(parseInt(source.charAt(i)));
    }
    return value.substring(Math.max(0, value.length - 8));
  }

  function digits() {
    var value = java.lang.System.nanoTime().toString().replace('-', '');
    return value.substring(Math.max(0, value.length - 10));
  }

  return {
    owner: function () {
      var token = letters();
      return {
        firstName: 'Karate',
        lastName: 'Owner' + token,
        address: '1 Test Avenue',
        city: 'London',
        telephone: digits()
      };
    },
    pet: function (petType) {
      return {
        name: 'Pet' + letters(),
        birthDate: '2020-01-15',
        type: petType
      };
    },
    visit: function () {
      return {
        date: '2024-06-15',
        description: 'Karate framework health check ' + letters()
      };
    },
    petType: function () {
      return { name: 'type' + letters() };
    },
    specialty: function () {
      return { name: 'specialty' + letters() };
    },
    vet: function (specialties) {
      return {
        firstName: 'Karate',
        lastName: 'Vet' + letters(),
        specialties: specialties || []
      };
    },
    user: function () {
      return {
        username: 'karate.' + letters(),
        password: 'ChangeMe123!',
        enabled: true,
        roles: [{ name: 'admin' }]
      };
    },
    distinct: function (values) {
      var seen = {};
      for (var i = 0; i < values.length; i++) {
        if (seen[values[i]]) return false;
        seen[values[i]] = true;
      }
      return true;
    }
  };
}
