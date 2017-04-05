/* eslint new-cap: 0 */

import Immutable from 'immutable';

import * as actionTypes from '../constants/contactsConstants';

export const $$initialState = Immutable.fromJS({
  $$contacts: [],
  sort: {
    sortMethod: 'First Name',
    search: '',
  },
  fetchContactError: null,
  submitContactError: null,
  isFetching: false,
  isSaving: false,
  $$selectedContacts: [],
});

export default function contactsReducer($$state = $$initialState, action = null) {
  const { type, contact, contacts, error, payload } = action;

  // console.log('ACTION:');
  // console.log(action);

  switch (type) {

    case actionTypes.FETCH_CONTACTS_SUCCESS: {
      return $$state.merge({
        $$contacts: contacts,
        fetchContactError: null,
        isFetching: false,
      });
    }

    case actionTypes.FETCH_CONTACTS_FAILURE: {
      return $$state.merge({
        fetchContactError: error,
        isFetching: false,
      });
    }

    case actionTypes.SUBMIT_CONTACT_SUCCESS: {
      return $$state.withMutations(state => (
        state
          .updateIn(
            ['$$contacts'],
            $$contacts => $$contacts.unshift(Immutable.fromJS(contact)),
          )
          .merge({
            submitContactError: null,
            isSaving: false,
          })
      ));
    }

    case actionTypes.SUBMIT_CONTACT_FAILURE: {
      return $$state.merge({
        submitContactError: error,
        isSaving: false,
      });
    }

    case actionTypes.SET_IS_FETCHING: {
      return $$state.merge({
        isFetching: true,
      });
    }

    case actionTypes.SET_IS_SAVING: {
      return $$state.merge({
        isSaving: true,
      });
    }

    case actionTypes.SET_SELECTED_CONTACTS: {
      return $$state.merge({
        ...action.payload,
      });
    }

    case actionTypes.SET_SEARCH_TERM: {
      console.log('SET_SEARCH_TERM reducer', action.payload.term);
      // return $$state.merge({
      //   sort: { search: action.payload.term }
      // });
      return $$state.setIn(['sort', 'search'], payload.term)
    }

    // case actionTypes.SET_SELECTED_CONTACTS: {
    //   return $$state.withMutations(state => (
    //     state
    //       .updateIn(
    //         ['$$selectedContacts'],

    //       )
    //     ))
    // }

    default: {
      return $$state;
    }
  }
}
