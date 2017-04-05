import BaseComponent from 'libs/components/BaseComponent';
import React, { PropTypes } from 'react';
import Immutable from 'immutable';
import { Checkbox, Header, Image, Item, Label, Popup, Portal, Table } from 'semantic-ui-react';
// import { setSelectedContacts } from '../../../../actions/contactsActionCreators';
// import { connect } from 'react-redux';
// import _ from 'lodash';

// @connect(state => {
//   return {
//     $$selectedContacts: state.$$contactsStore.get('$$selectedContacts')
//   };
//  }, {setSelectedContacts})

export default class Contact extends BaseComponent {
  static propTypes = {
    firstName: PropTypes.string.isRequired,
    lastName: PropTypes.string.isRequired,
  };

  renderGradePopup() {
    return (
      <div>
        <h5>Change grade:</h5>
        <div className="ui large labels">
          <a className="ui green circular label">A+</a>
          <a className="ui teal circular basic label">A</a>
          <a className="ui yellow circular basic label">B</a>
          <a className="ui orange circular basic label">C</a>
          <a className="ui red circular basic label">D</a>
          <a className="ui grey circular basic label">NA</a>
          <a href="#">Cancel</a>
        </div>
      </div>

    );
  }

  renderCareerInfo(profession, company) {
    if (profession && company) {
      return (
        <div className="subheader">{profession}, {company}</div>
      );
    }
  }

  renderGroups(groups) {
    const moreGroups = (
      <span><br /><small>+ 1 more</small></span>
    );

    return (
      <Table.Cell>
        {groups.length > 1 ? groups[0].name : 'None'}
        <i className="dropdown icon"></i>
        {groups.lenght > 1 ? moreGroups : ''}
      </Table.Cell>
    );
  }

  render() {

    // console.log('selectedContacts');
    // console.log(this.props.selectedContacts);

    const {
      id,
      firstName,
      lastName,
      grade,
      phoneNumber,
      email,
      profession,
      company,
      lastContactedDate,
      groups,
      initials,
      avatarColor,
      $$selectedContacts,
      setSelectedContacts,
      $$contact,
    } = this.props;

    console.log("Contact.jsx rendered: " + id);

    const gradeLink = (
      <a>{grade === '?' ? 'None' : grade}</a>
    );

    const lastContactedDateCell = (
      <Table.Cell disabled={lastContactedDate === 'None'}>
        {lastContactedDate}
      </Table.Cell>
    );

    /* eslint-disable react/no-danger */

    // return (
    //   <div>
    //     <h2 className="js-contact-author">
    //       {author}
    //     </h2>
    //     <span dangerouslySetInnerHTML={{ __html: rawMarkup }} />
    //   </div>
    // );

    // console.log(selectedContacts)

    // function handleCheckSelect(event, { checked }) {
    //   console.log('$$selectedContacts:');
    //   console.log($$selectedContacts);
    //   console.log('$$contact:');
    //   console.log($$contact);
    //   if (checked) {
    //     return setSelectedContacts($$selectedContacts.push($$contact));
    //   }
    //   const nextSelectedContacts = $$selectedContacts.
    //     filterNot(x => x.get('id') === $$contact.get('id'));
    //   setSelectedContacts(nextSelectedContacts);
    // }

    return (
      <Table.Row>
        <Table.Cell className="ab-status-column">
          <div className="ab-status ab-positive-status"></div>
        </Table.Cell>
        <Table.Cell>
          <Checkbox
            fitted
          />
        </Table.Cell>
        <Table.Cell>
          <Label className={'ab-avi abg' + avatarColor} size="large">
            {initials}
          </Label>
        </Table.Cell>
        <Table.Cell>
          <Item>
            <Header className="small">
              <Item.Content>
                {firstName} {lastName}
                <a className="sub header">{email}</a>
                {this.renderCareerInfo(profession, company)}
              </Item.Content>
            </Header>
          </Item>
        </Table.Cell>
        <Table.Cell>
          <Popup
            trigger={gradeLink}
            on="click"
            positioning="top left"
            flowing
            content={this.renderGradePopup()}
            mountNode={document.body}
          />
        </Table.Cell>
        <Table.Cell />
        {lastContactedDateCell}
        <Table.Cell>{phoneNumber}</Table.Cell>
      </Table.Row>
    );
  }
}
