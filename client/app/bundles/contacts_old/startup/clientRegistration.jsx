import ReactOnRails from 'react-on-rails';

import AppContacts from './AppContacts';

import contactsStore from '../store/contactsStore';

ReactOnRails.setOptions({
  traceTurbolinks: TRACE_TURBOLINKS, // eslint-disable-line no-undef
});

ReactOnRails.register({
  AppContacts,
});

ReactOnRails.registerStore({
  contactsStore,
});
