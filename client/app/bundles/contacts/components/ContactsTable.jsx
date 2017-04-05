import React, { Component } from 'react';
import { Checkbox, Table } from 'semantic-ui-react';

import ContactsList from './ContactsList';

export default class ContactsTable extends Component {
  render() {
    const {contacts} = this.props;
    return (
      <Table basic="very">
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell collapsing></Table.HeaderCell>
            <Table.HeaderCell collapsing>
              <Checkbox
                fitted
                defaultIndeterminate
              />
            </Table.HeaderCell>
            <Table.HeaderCell collapsing></Table.HeaderCell>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell collapsing>Grade</Table.HeaderCell>
            <Table.HeaderCell>Groups</Table.HeaderCell>
            <Table.HeaderCell collapsing>Last Contact</Table.HeaderCell>
            <Table.HeaderCell>Phone</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <ContactsList $$contacts={contacts}/>
      </Table>
    )
  }
}
