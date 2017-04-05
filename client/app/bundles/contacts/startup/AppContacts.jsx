import React from 'react';
import { Provider } from 'react-redux';
import ReactOnRails from 'react-on-rails';
import createStore from '../store/store';

import ContactsContainer from '../containers/ContactsContainer';

export default (railsProps, _railsContext) => {
  const store = createStore(railsProps);

  return (
    <Provider store={store}>
      <ContactsContainer />
    </Provider>
  );
};
