function fn() {
  var petType = { id: '#number', name: '#string' };
  var specialty = { id: '#number', name: '#string' };

  return {
    petType: petType,
    specialty: specialty,
    owner: {
      id: '#number',
      firstName: '#string',
      lastName: '#string',
      address: '#string',
      city: '#string',
      telephone: '#regex ^[0-9]+$',
      pets: '#[]'
    },
    pet: {
      id: '#number',
      name: '#string',
      birthDate: '#regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}$',
      type: petType,
      ownerId: '##number',
      visits: '#[]'
    },
    visit: {
      id: '#number',
      date: '#regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}$',
      description: '#string',
      petId: '#number'
    },
    vet: {
      id: '#number',
      firstName: '#string',
      lastName: '#string',
      specialties: '#[]'
    },
    user: {
      username: '#string',
      password: '##string',
      enabled: '#boolean',
      roles: '#[]'
    },
    page: {
      content: '#[]',
      page: '#number',
      size: '#number',
      totalElements: '#number',
      totalPages: '#number'
    },
    problem: {
      type: '#string',
      title: '#string',
      status: '#number',
      detail: '#string',
      instance: '#string',
      timestamp: '#string',
      schemaValidationErrors: '#[]'
    }
  };
}
