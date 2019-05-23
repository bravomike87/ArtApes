import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.getElementById('profile_address');
  if (addressInput) {
    places({ container: addressInput });
  }
};

const initAutocompleteLocation = () => {
  const searchLocationInput = document.getElementById('search_location');
  if (searchLocationInput) {
    places({ container: searchLocationInput });
  }
};

export { initAutocomplete };
export { initAutocompleteLocation };
