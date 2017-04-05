import React, { Component } from 'react';
import Immutable from 'immutable';
import { Table } from 'semantic-ui-react';
import _ from 'lodash';

import Contact from './Contact';

export default class ContactsList extends Component {
  render() {
    const { $$contacts } = this.props;
    const contactNodes = $$contacts.map(($$contact, index) =>
      <Contact
        key={$$contact.get('id') || index}
        id={$$contact.get('id')}
        firstName={$$contact.get('first_name')}
        lastName={$$contact.get('last_name')}
        grade={$$contact.get('grade_to_s')}
        phoneNumber={$$contact.get('phone_number')}
        email={$$contact.get('email')}
        name={$$contact.get('name')}
        profession={$$contact.get('profession')}
        company={$$contact.get('company')}
        lastContactedDate={$$contact.get('last_contacted_date')}
        groups={$$contact.get('groups')}
        initials={$$contact.get('initials')}
        avatarColor={$$contact.get('avatar_color')}
        $$contact={$$contact}
      />
    );

    return (
      <Table.Body>
        {contactNodes}
      </Table.Body>
    )
  }
}
