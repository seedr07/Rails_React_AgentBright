import React, { Component, PropTypes } from 'react';
import { Grid, Segment } from 'semantic-ui-react';
import { connect } from 'react-redux';

import { bindActionCreators } from 'redux';

import ContactsFilter from '../components/ContactsFilter';
import ContactsSearchBar from '../components/ContactsSearchBar';
import ContactsTable from '../components/ContactsTable';
import SelectedContactsMenu from '../components/SelectedContactsMenu';
import EditGroupsMenu from '../components/EditGroupsMenu';

import * as contactActions from '../actions/contactsActionCreators';

const sortUtil = (field) => contact => contact.get(field)

const sortMethods = (originalContacts, sort) => {
  const filter = sort.get('search').toLowerCase();
  const method = sort.get('sortMethod');

  const contacts = originalContacts.filter(
    contact => contact.get('name').toLowerCase().indexOf(filter) !== -1
  );

  switch (method) {
    case 'First Name':
      return contacts.sortBy(sortUtil('first_name'));

    case 'First Name (Z-A)':
      return contacts.sortBy(sortUtil('first_name')).reverse();
  };
};

export const ContactsPage = (props) => {
  const {$$contacts, sort, contactActions: {setSearchTerm}} = props;
  return (
    <div>
      <Grid stackable>
        <Grid.Column width={3}>
          <ContactsFilter />
        </Grid.Column>
        <Grid.Column width={13}>
          <Segment.Group>
            <Segment>
              <ContactsSearchBar onSearch={setSearchTerm} search={sort.get('search')} />
            </Segment>
            <Segment className="p-a-0">
              <SelectedContactsMenu />
              <ContactsTable contacts={sortMethods($$contacts, sort)} />
            </Segment>
          </Segment.Group>
        </Grid.Column>
      </Grid>
      <EditGroupsMenu />
    </div>
  );
}

export default connect(
  (state) => ({
    $$contacts: state.$$contactsStore.get('$$contacts'),
    sort: state.$$contactsStore.get('sort')
  }),
  function (dispatch) {
    return {
      contactActions: bindActionCreators(contactActions, dispatch),
    }
  }
  )(ContactsPage);
