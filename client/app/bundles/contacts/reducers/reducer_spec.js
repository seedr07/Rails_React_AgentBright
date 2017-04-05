import { List, Map, fromJS } from 'immutable';
import { expect } from 'chai';

import contactsReducer from './contactsReducer';

describe('contactsReducer', () => {

  it('handles FETCH_CONTACTS_SUCCESS', () => {
    const $$initialState = Map();
    const action = {
      type: 'FETCH_CONTACTS_SUCCESS',
      contacts: [
        {
          id: 1,
          key: 1,
          firstName: 'John',
          lastName: 'Smith',
          grade: 2,
          phoneNumber: '860-504-3433',
          email: 'john@example.com',
        },
      ],
    };
    const $$nextState = contactsReducer($$initialState, action);

    expect($$nextState).to.equal(fromJS({
      $$contacts: [
        {
          id: 1,
          key: 1,
          firstName: 'John',
          lastName: 'Smith',
          grade: 2,
          phoneNumber: '860-504-3433',
          email: 'john@example.com',
        },
      ],
      fetchContactError: null,
      isFetching: false,
    }));
  });

});
