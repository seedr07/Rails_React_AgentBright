import React from 'react';
import { Provider } from 'react-redux';
import ReactOnRails from 'react-on-rails';

import ContactsContainer from '../containers/ContactsContainer';

export default (_props, _railsContext) => {
  const store = ReactOnRails.getStore('contactsStore');

  return (
    <Provider store={store}>
      <ContactsContainer />
    </Provider>
  );
};
