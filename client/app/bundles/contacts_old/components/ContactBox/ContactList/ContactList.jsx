import BaseComponent from 'libs/components/BaseComponent';
import Immutable from 'immutable';
import React, { PropTypes } from 'react';
import ReactCSSTransitionGroup from 'react/lib/ReactCSSTransitionGroup';
import { Table } from 'semantic-ui-react';
import _ from 'lodash';

import Contact from './Contact/Contact';

export default class ContactList extends BaseComponent {
  static propTypes = {
    // $$contacts: PropTypes.instanceOf(Immutable.List).isRequired,
    error: PropTypes.any,
    cssTransitionGroupClassNames: PropTypes.object.isRequired,
  };

  constructor(props, context) {
    super(props, context);
    this.state = {};
    _.bindAll(this, 'errorWarning');
  }

  errorWarning() {
    // If there is no error, there is nothing to add to the DOM
    if (!this.props.error) return null;
    return (
      <strong>Contacts could not be retrieved. Please try again.</strong>
    );
  }

  render() {
    const { $$contacts, cssTransitionGroupClassNames } = this.props;
    console.log('ContactList - $$contacts');
    console.log($$contacts);
    const contactNodes = $$contacts.map(($$contact, index) =>

      // 'key' is a React-specific concept and is not mandatory for the
      // purpose of this tutorial. If you're curious, see more here:
      // http://facebook.github.io/react/docs/multiple-components.html#dynamic-children
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
    );
  }
}
