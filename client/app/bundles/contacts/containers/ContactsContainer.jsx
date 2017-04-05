import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import ContactsPage from '../components/ContactsPage';

import * as contactsActionCreators from '../actions/contactsActionCreators';

// const mapStateToProps = (state) => ({
//   $$contacts: state.$$contactsStore.get('$$contacts'),
// });

// Don't forget to actually use connect!
export default (ContactsPage);
