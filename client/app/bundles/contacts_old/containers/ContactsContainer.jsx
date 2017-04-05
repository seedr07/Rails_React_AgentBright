import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import BaseComponent from 'libs/components/BaseComponent';

import ContactScreen from '../components/ContactScreen/ContactScreen';
import * as contactsActionCreators from '../actions/contactsActionCreators';

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return { data: state.$$contactsStore };
}

class ContactsContainer extends BaseComponent {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    data: PropTypes.object.isRequired,
  };

  render() {
    const { dispatch, data } = this.props;
    const actions = bindActionCreators(contactsActionCreators, dispatch);
    return (
      <ContactScreen {...{ actions, data }} />
    );
  }
}

// Don't forget to actually use connect!
export default connect(select)(ContactsContainer);
