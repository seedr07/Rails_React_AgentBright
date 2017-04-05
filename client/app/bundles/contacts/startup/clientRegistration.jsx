import ReactOnRails from 'react-on-rails';

import AppContacts from './AppContacts';

import createStore from '../store/store';

ReactOnRails.setOptions({
  traceTurbolinks: TRACE_TURBOLINKS, // eslint-disable-line no-undef
});

ReactOnRails.register({
  AppContacts,
});
