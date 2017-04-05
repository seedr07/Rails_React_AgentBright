import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import ContactsList from '../components/ContactsList';

import * as contactsActionCreators from '../actions/contactsActionCreators';

// const mapStateToProps = (state) => ({
//   $$contacts: state.$$contactsStore.get('$$contacts'),
//   sort: state.$$contactsStore.get('sort')
// });

export default (ContactsList);
