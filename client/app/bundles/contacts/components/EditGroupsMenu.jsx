import React, { Component } from 'react';
import { Button, Checkbox, List, Search, Segment } from 'semantic-ui-react';

export default class EditGroupsMenu extends Component {
  render() {
    return (
      <div style={{ maxWidth: '350px' }}>
        <Segment.Group>
          <Segment>
            <h3>Edit Groups</h3>
            <Search fluid placeholder="Search for a group..." />
          </Segment>
          <Segment className="p-r-0 p-b-0">
            <div style={{ maxHeight: '250px', overflowY: 'scroll', overflowX: 'hidden' }}>
              <List selection>
                <List.Item><Checkbox label="Friends" /></List.Item>
                <List.Item><Checkbox label="Current Clients" /></List.Item>
                <List.Item><Checkbox label="Family" /></List.Item>
                <List.Item><Checkbox label="Mortgage Brokers" /></List.Item>
                <List.Item><Checkbox label="Neighbors" /></List.Item>
                <List.Item><Checkbox label="Past Clients" /></List.Item>
                <List.Item><Checkbox label="Realtors" /></List.Item>
                <List.Item><Checkbox label="Rotary Club" /></List.Item>
                <List.Item><Checkbox label="Vendors" /></List.Item>
              </List>
            </div>
          </Segment>
          <Segment>
            <Button primary>Save</Button>
            <Button>Cancel</Button>
          </Segment>
        </Segment.Group>
      </div>
    )
  }
}
