import requestsManager from 'libs/requestsManager';
import * as actionTypes from '../constants/contactsConstants';

export function setIsFetching() {
  return {
    type: actionTypes.SET_IS_FETCHING,
  };
}

export function setIsSaving() {
  return {
    type: actionTypes.SET_IS_SAVING,
  };
}

export function fetchContactsSuccess(data) {
  return {
    type: actionTypes.FETCH_CONTACTS_SUCCESS,
    contacts: data.contacts,
  };
}

export function fetchContactsFailure(error) {
  return {
    type: actionTypes.FETCH_CONTACTS_FAILURE,
    error,
  };
}

export function submitContactSuccess(contact) {
  return {
    type: actionTypes.SUBMIT_CONTACT_SUCCESS,
    contact,
  };
}

export function submitContactFailure(error) {
  return {
    type: actionTypes.SUBMIT_CONTACT_FAILURE,
    error,
  };
}

export function fetchContacts() {
  return (dispatch) => {
    dispatch(setIsFetching());
    return (
      requestsManager
        .fetchEntities()
        .then(res => dispatch(fetchContactsSuccess(res.data)))
        .catch(error => dispatch(fetchContactsFailure(error)))
    );
  };
}

export function submitContact(contact) {
  return (dispatch) => {
    dispatch(setIsSaving());
    return (
      requestsManager
        .submitEntity({ contact })
        .then(res => dispatch(submitContactSuccess(res.data)))
        .catch(error => dispatch(submitContactFailure(error)))
    );
  };
}

export function setSelectedContacts($$selectedContacts) {
  return {
    type: actionTypes.SET_SELECTED_CONTACTS,
    payload: { $$selectedContacts },
  };
}

export function setSearchTerm(term) {
  console.log('setsearchTerm', term);
  return {
    type: actionTypes.SET_SEARCH_TERM,
    payload: { term },
  }
}
